Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD845B7461
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiIMPYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbiIMPXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31B76B155;
        Tue, 13 Sep 2022 07:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD594614DF;
        Tue, 13 Sep 2022 14:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5178C433B5;
        Tue, 13 Sep 2022 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079404;
        bh=ULT3UulllkD6PnR0q3ChBNmifBLJcxOxva0bCFFsHCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt6KT6mAYlrt4vYWy3FEQd0jt7RjULMxlca5tf+BRdgWrjELrkHWXpzoLx91idrbh
         O8TQqGmY4WKxC0euhRmwUZUP/6e75Kk/TW6LvIRAjIf+C3JUudwwFWButhjRjiEp86
         budejYEiY4ZWEYnuoRpN1XQw1JKn5HqOYAR8PP1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/79] Revert "xhci: turn off port power in shutdown"
Date:   Tue, 13 Sep 2022 16:06:31 +0200
Message-Id: <20220913140349.496982808@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
index e40370ed7d8a5..1bb48e53449e6 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -565,7 +565,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 {
 	struct xhci_hub *rhub;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 677587479d260..a9e72fee87a77 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -774,8 +774,6 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	unsigned long flags;
-	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -791,21 +789,12 @@ void xhci_shutdown(struct usb_hcd *hcd)
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
index 3b29dfc6f79e3..3e6cb257fde5a 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2145,8 +2145,6 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
-void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
-			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
-- 
2.35.1



