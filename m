Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77CF5AEAD0
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiIFNo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbiIFNno (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:43:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC277EFE7;
        Tue,  6 Sep 2022 06:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22667B818D4;
        Tue,  6 Sep 2022 13:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DF3C433B5;
        Tue,  6 Sep 2022 13:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471404;
        bh=0EXyUN4GSeBLi+VobqJP+bM+RNAVi0vcD4EVerxT1b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1BT2DQGl7WTURwk4qxH7UGNKOX5gvTxVsOTXvz67gyOjYPm3DgqZrOqtumpFf/cC
         uuyhiwWluHJOAue1WHQz9ERXKUol80ELy3oQu+pRh499wL4a2JKs7b2xF3jnfPYdkw
         NMiP/N/hy5rfWdv+v1sSOQVoguGvvGWPAjk136pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/107] Revert "xhci: turn off port power in shutdown"
Date:   Tue,  6 Sep 2022 15:29:57 +0200
Message-Id: <20220906132822.451129681@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 8531aa1659f7278d4f2ec7408cc000eaa8d85217 ]

This reverts commit 83810f84ecf11dfc5a9414a8b762c3501b328185.

Turning off port power in shutdown did cause issues such as a laptop not
proprly powering off, and some specific usb devies failing to enumerate the
subsequent boot after a warm reset.

So revert this.

Fixes: 83810f84ecf1 ("xhci: turn off port power in shutdown")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220825150840.132216-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c |  2 +-
 drivers/usb/host/xhci.c     | 15 ++-------------
 drivers/usb/host/xhci.h     |  2 --
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index fc322a9526c8c..f65f1ba2b5929 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 	__must_hold(&xhci->lock)
 {
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index d76c10f9ad807..e3767651c9a9e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -776,8 +776,6 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	unsigned long flags;
-	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -793,21 +791,12 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		del_timer_sync(&xhci->shared_hcd->rh_timer);
 	}
 
-	spin_lock_irqsave(&xhci->lock, flags);
+	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-
-	/* Power off USB2 ports*/
-	for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
-		xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
-
-	/* Power off USB3 ports*/
-	for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
-		xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
-
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
-	spin_unlock_irqrestore(&xhci->lock, flags);
+	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 101f1956a96ca..81e1bfdf83988 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2174,8 +2174,6 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
-			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
-- 
2.35.1



