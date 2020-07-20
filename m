Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B3C22658D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731613AbgGTPyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731600AbgGTPyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:54:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354BC22CBE;
        Mon, 20 Jul 2020 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260490;
        bh=wLxL1nVipSq7d1yTtdip3hxHzFOIH1b0rYTLz36sJ+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dM9mGhYm4Fu2yGaV7BUbkyYDLfrsMAiIt0ilihva8zu0xKDQZFeukh207/Y/hN4Do
         5XZS+wZzSKBEUx6JRPTSL/kwy6sjjNnwFMeYnjbDBF5GD83P1OW28gom7DZVqTuAp+
         cwH1DQZYRtPflhdHGOF00ET5FWkaXQtUuOqu/TMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 121/133] dmaengine: fsl-edma: Fix NULL pointer exception in fsl_edma_tx_handler
Date:   Mon, 20 Jul 2020 17:37:48 +0200
Message-Id: <20200720152809.576391347@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit f5e5677c420346b4e9788051c2e4d750996c428c upstream.

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
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Robin Gong <yibin.gong@nxp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1591877861-28156-2-git-send-email-krzk@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/fsl-edma.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -682,6 +682,13 @@ static irqreturn_t fsl_edma_tx_handler(i
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


