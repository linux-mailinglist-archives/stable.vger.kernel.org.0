Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0832B1F67BF
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 14:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgFKMRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 08:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgFKMRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 08:17:51 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0754C20801;
        Thu, 11 Jun 2020 12:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591877870;
        bh=0K1+88Lwj0beX+rNYr54Ww8Eh+bQyL1InVpN0BEVars=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zbj1BWtTAkR3mu+IcmjYDx0Y/c3josgMOafjaVvfGSguZSemFH+8QNJ4qF+RImfid
         bSjDdGRPuLClXBR5fqVlYwdzbVgyumr0ifNHqYhOtJ0cEIyFF6ARh/SHkkdfLt0DQM
         iemiIxnAgtH9U82uJeWtL0XR2kbBBSudmfU4wL2s=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Robin Gong <yibin.gong@nxp.com>, Peng Ma <peng.ma@nxp.com>,
        Fabio Estevam <festevam@gmail.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] dmaengine: fsl-edma: Fix NULL pointer exception in fsl_edma_tx_handler
Date:   Thu, 11 Jun 2020 14:17:41 +0200
Message-Id: <1591877861-28156-2-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591877861-28156-1-git-send-email-krzk@kernel.org>
References: <1591877861-28156-1-git-send-email-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

NULL pointer exception happens occasionally on serial output initiated
by login timeout.  This was reproduced only if kernel was built with
significant debugging options and EDMA driver is used with serial
console.

    col-vf50 login: root
    Password:
    Login timed out after 60 seconds.
    Unable to handle kernel NULL pointer dereference at virtual address 00000044
    Internal error: Oops: 5 [#1] ARM
    CPU: 0 PID: 157 Comm: login Not tainted 5.7.0-next-20200610-dirty #4
    Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
      (fsl_edma_tx_handler) from [<8016eb10>] (__handle_irq_event_percpu+0x64/0x304)
      (__handle_irq_event_percpu) from [<8016eddc>] (handle_irq_event_percpu+0x2c/0x7c)
      (handle_irq_event_percpu) from [<8016ee64>] (handle_irq_event+0x38/0x5c)
      (handle_irq_event) from [<801729e4>] (handle_fasteoi_irq+0xa4/0x160)
      (handle_fasteoi_irq) from [<8016ddcc>] (generic_handle_irq+0x34/0x44)
      (generic_handle_irq) from [<8016e40c>] (__handle_domain_irq+0x54/0xa8)
      (__handle_domain_irq) from [<80508bc8>] (gic_handle_irq+0x4c/0x80)
      (gic_handle_irq) from [<80100af0>] (__irq_svc+0x70/0x98)
    Exception stack(0x8459fe80 to 0x8459fec8)
    fe80: 72286b00 e3359f64 00000001 0000412d a0070013 85c98840 85c98840 a0070013
    fea0: 8054e0d4 00000000 00000002 00000000 00000002 8459fed0 8081fbe8 8081fbec
    fec0: 60070013 ffffffff
      (__irq_svc) from [<8081fbec>] (_raw_spin_unlock_irqrestore+0x30/0x58)
      (_raw_spin_unlock_irqrestore) from [<8056cb48>] (uart_flush_buffer+0x88/0xf8)
      (uart_flush_buffer) from [<80554e60>] (tty_ldisc_hangup+0x38/0x1ac)
      (tty_ldisc_hangup) from [<8054c7f4>] (__tty_hangup+0x158/0x2bc)
      (__tty_hangup) from [<80557b90>] (disassociate_ctty.part.1+0x30/0x23c)
      (disassociate_ctty.part.1) from [<8011fc18>] (do_exit+0x580/0xba0)
      (do_exit) from [<801214f8>] (do_group_exit+0x3c/0xb4)
      (do_group_exit) from [<80121580>] (__wake_up_parent+0x0/0x14)

Issue looks like race condition between interrupt handler fsl_edma_tx_handler()
(called as result of fsl_edma_xfer_desc()) and terminating the transfer with
fsl_edma_terminate_all().

The fsl_edma_tx_handler() handles interrupt for a transfer with already freed
edesc and idle==true.

Fixes: d6be34fbd39b ("dma: Add Freescale eDMA engine driver support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/dma/fsl-edma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index eff7ebd8cf35..90bb72af306c 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -45,6 +45,13 @@ static irqreturn_t fsl_edma_tx_handler(int irq, void *dev_id)
 			fsl_chan = &fsl_edma->chans[ch];
 
 			spin_lock(&fsl_chan->vchan.lock);
+
+			if (!fsl_chan->edesc) {
+				/* terminate_all called before */
+				spin_unlock(&fsl_chan->vchan.lock);
+				continue;
+			}
+
 			if (!fsl_chan->edesc->iscyclic) {
 				list_del(&fsl_chan->edesc->vdesc.node);
 				vchan_cookie_complete(&fsl_chan->edesc->vdesc);
-- 
2.7.4

