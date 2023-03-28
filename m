Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7EF6CC5DF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjC1PTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbjC1PS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:18:29 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69099BDC6;
        Tue, 28 Mar 2023 08:17:20 -0700 (PDT)
Received: from vm02.corp.microsoft.com (unknown [167.220.197.27])
        by linux.microsoft.com (Postfix) with ESMTPSA id 89F4E20FD945;
        Tue, 28 Mar 2023 08:16:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 89F4E20FD945
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680016601;
        bh=4wfUXWdj4oVNf4M9M6kxy7m6WtmwRmZ9/vKCpDdemjg=;
        h=From:To:Cc:Subject:Date:From;
        b=ahUYFXqX7hTR7FwJDnDyJURJgQZD0AcoFgTvWMEVjeUG5CG6dUXovRdOHYJ9iPDuX
         OL3cTN1jUmd9QGFfV19Ll8l9qdIBd4C6I2looSA1m+eFUmGb1lzEpHDK78YY+9eeDr
         TL7je9PVE2pTsjEO9OMHWmv6RV0Mmh9Td88Ooes0=
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     linux-crypto@vger.kernel.org
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] crypto: ccp - Clear PSP interrupt status register before calling handler
Date:   Tue, 28 Mar 2023 15:16:36 +0000
Message-Id: <20230328151636.1353846-1-jpiotrowski@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PSP IRQ is edge-triggered (MSI or MSI-X) in all cases supported by
the psp module so clear the interrupt status register early in the
handler to prevent missed interrupts. sev_irq_handler() calls wake_up()
on a wait queue, which can result in a new command being submitted from
a different CPU. This then races with the clearing of isr and can result
in missed interrupts. A missed interrupt results in a command waiting
until it times out, which results in the psp being declared dead.

This is unlikely on bare metal, but has been observed when running
virtualized. In the cases where this is observed, sev->cmdresp_reg has
PSP_CMDRESP_RESP set which indicates that the command was processed
correctly but no interrupt was asserted.

The full sequence of events looks like this:

CPU 1: submits SEV cmd #1
CPU 1: calls wait_event_timeout()
CPU 0: enters psp_irq_handler()
CPU 0: calls sev_handler()->wake_up()
CPU 1: wakes up; finishes processing cmd #1
CPU 1: submits SEV cmd #2
CPU 1: calls wait_event_timeout()
PSP:   finishes processing cmd #2; interrupt status is still set; no interrupt
CPU 0: clears intsts
CPU 0: exits psp_irq_handler()
CPU 1: wait_event_timeout() times out; psp_dead=true

Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
---
 drivers/crypto/ccp/psp-dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index c9c741ac8442..949a3fa0b94a 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -42,6 +42,9 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 	/* Read the interrupt status: */
 	status = ioread32(psp->io_regs + psp->vdata->intsts_reg);
 
+	/* Clear the interrupt status by writing the same value we read. */
+	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
+
 	/* invoke subdevice interrupt handlers */
 	if (status) {
 		if (psp->sev_irq_handler)
@@ -51,9 +54,6 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 			psp->tee_irq_handler(irq, psp->tee_irq_data, status);
 	}
 
-	/* Clear the interrupt status by writing the same value we read. */
-	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
-
 	return IRQ_HANDLED;
 }
 
-- 
2.34.1

