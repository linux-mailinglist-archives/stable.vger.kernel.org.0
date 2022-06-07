Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC76540D71
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353853AbiFGSsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354090AbiFGSqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FB018FA5C;
        Tue,  7 Jun 2022 11:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 262E1618E2;
        Tue,  7 Jun 2022 18:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AD2C385A5;
        Tue,  7 Jun 2022 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624805;
        bh=vGB1n8brpDPrHdWKQa7pCJKoXj8JrcL7rMvdRjJ6NNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2o4bfbMKx5uPf22ppNAQ2NRNdVKjdkjFHQqoJU+E2LsWjeF94PQThFs5azpvWPTB6
         xXjuWTzbBWpxRjBfTvc4q+i8b/wOAp1xzhDBrQ0VoVbDdiB1T87cz6pMiuj5X2/YSQ
         3rD7AhjXou/tz+fQDj4S6V4ks7UfncqcdNT/N3sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Badger <ebadger@purestorage.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 460/667] PCI/AER: Clear MULTI_ERR_COR/UNCOR_RCV bits
Date:   Tue,  7 Jun 2022 19:02:05 +0200
Message-Id: <20220607164948.508095839@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 203926da2bff8e172200a2f11c758987af112d4a ]

When a Root Port or Root Complex Event Collector receives an error Message
e.g., ERR_COR, it sets PCI_ERR_ROOT_COR_RCV in the Root Error Status
register and logs the Requester ID in the Error Source Identification
register.  If it receives a second ERR_COR Message before software clears
PCI_ERR_ROOT_COR_RCV, hardware sets PCI_ERR_ROOT_MULTI_COR_RCV and the
Requester ID is lost.

In the following scenario, PCI_ERR_ROOT_MULTI_COR_RCV was never cleared:

  - hardware receives ERR_COR message
  - hardware sets PCI_ERR_ROOT_COR_RCV
  - aer_irq() entered
  - aer_irq(): status = pci_read_config_dword(PCI_ERR_ROOT_STATUS)
  - aer_irq(): now status == PCI_ERR_ROOT_COR_RCV
  - hardware receives second ERR_COR message
  - hardware sets PCI_ERR_ROOT_MULTI_COR_RCV
  - aer_irq(): pci_write_config_dword(PCI_ERR_ROOT_STATUS, status)
  - PCI_ERR_ROOT_COR_RCV is cleared; PCI_ERR_ROOT_MULTI_COR_RCV is set
  - aer_irq() entered again
  - aer_irq(): status = pci_read_config_dword(PCI_ERR_ROOT_STATUS)
  - aer_irq(): now status == PCI_ERR_ROOT_MULTI_COR_RCV
  - aer_irq() exits because PCI_ERR_ROOT_COR_RCV not set
  - PCI_ERR_ROOT_MULTI_COR_RCV is still set

The same problem occurred with ERR_NONFATAL/ERR_FATAL Messages and
PCI_ERR_ROOT_UNCOR_RCV and PCI_ERR_ROOT_MULTI_UNCOR_RCV.

Fix the problem by queueing an AER event and clearing the Root Error Status
bits when any of these bits are set:

  PCI_ERR_ROOT_COR_RCV
  PCI_ERR_ROOT_UNCOR_RCV
  PCI_ERR_ROOT_MULTI_COR_RCV
  PCI_ERR_ROOT_MULTI_UNCOR_RCV

See the bugzilla link for details from Eric about how to reproduce this
problem.

[bhelgaas: commit log, move repro details to bugzilla]
Fixes: e167bfcaa4cd ("PCI: aerdrv: remove magical ROOT_ERR_STATUS_MASKS")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215992
Link: https://lore.kernel.org/r/20220418150237.1021519-1-sathyanarayanan.kuppuswamy@linux.intel.com
Reported-by: Eric Badger <ebadger@purestorage.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 9784fdcf3006..80fe3e83c9f5 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -101,6 +101,11 @@ struct aer_stats {
 #define ERR_COR_ID(d)			(d & 0xffff)
 #define ERR_UNCOR_ID(d)			(d >> 16)
 
+#define AER_ERR_STATUS_MASK		(PCI_ERR_ROOT_UNCOR_RCV |	\
+					PCI_ERR_ROOT_COR_RCV |		\
+					PCI_ERR_ROOT_MULTI_COR_RCV |	\
+					PCI_ERR_ROOT_MULTI_UNCOR_RCV)
+
 static int pcie_aer_disable;
 static pci_ers_result_t aer_root_reset(struct pci_dev *dev);
 
@@ -1196,7 +1201,7 @@ static irqreturn_t aer_irq(int irq, void *context)
 	struct aer_err_source e_src = {};
 
 	pci_read_config_dword(rp, aer + PCI_ERR_ROOT_STATUS, &e_src.status);
-	if (!(e_src.status & (PCI_ERR_ROOT_UNCOR_RCV|PCI_ERR_ROOT_COR_RCV)))
+	if (!(e_src.status & AER_ERR_STATUS_MASK))
 		return IRQ_NONE;
 
 	pci_read_config_dword(rp, aer + PCI_ERR_ROOT_ERR_SRC, &e_src.id);
-- 
2.35.1



