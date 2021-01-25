Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DAB304B82
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbhAZEnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:43:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbhAYSms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CFB9230FE;
        Mon, 25 Jan 2021 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600112;
        bh=du7oJrbTuBu5U1oNDSjNAn64cgutbMWetU71tr4xy/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sirI6vjXS7gz0LX57zNvTT38HFpcp3QKqt6lo/GaiT/K/XRXvmn+8cUR/dg22u/fZ
         Bybm+rRQSgGXQNxyVsfKa11TJctzcYtImhOjmfMtPSYBrv8hE2ZkEWxoFQ2WDMA/VI
         8rC/pXe9EaZ3db2od0qG8pjFZ+fE1KDMQ/CoJiXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Eugene Korenevsky <ekorenevsky@astralinux.ru>
Subject: [PATCH 4.19 36/58] ehci: fix EHCI host controller initialization sequence
Date:   Mon, 25 Jan 2021 19:39:37 +0100
Message-Id: <20210125183158.261001494@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Korenevsky <ekorenevsky@astralinux.ru>

commit 280a9045bb18833db921b316a5527d2b565e9f2e upstream.

According to EHCI spec, EHCI HC clears USBSTS.HCHalted whenever
USBCMD.RS=1.

However, it is a good practice to wait some time after setting USBCMD.RS
(approximately 100ms) until USBSTS.HCHalted become zero.

Without this waiting, VirtualBox's EHCI virtual HC accidentally hangs
(see BugLink).

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211095
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210110173609.GA17313@himera.home
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hcd.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -574,6 +574,7 @@ static int ehci_run (struct usb_hcd *hcd
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
 	u32			temp;
 	u32			hcc_params;
+	int			rc;
 
 	hcd->uses_new_polling = 1;
 
@@ -629,9 +630,20 @@ static int ehci_run (struct usb_hcd *hcd
 	down_write(&ehci_cf_port_reset_rwsem);
 	ehci->rh_state = EHCI_RH_RUNNING;
 	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
+
+	/* Wait until HC become operational */
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
 	msleep(5);
+	rc = ehci_handshake(ehci, &ehci->regs->status, STS_HALT, 0, 100 * 1000);
+
 	up_write(&ehci_cf_port_reset_rwsem);
+
+	if (rc) {
+		ehci_err(ehci, "USB %x.%x, controller refused to start: %d\n",
+			 ((ehci->sbrn & 0xf0)>>4), (ehci->sbrn & 0x0f), rc);
+		return rc;
+	}
+
 	ehci->last_periodic_enable = ktime_get_real();
 
 	temp = HC_VERSION(ehci, ehci_readl(ehci, &ehci->caps->hc_capbase));


