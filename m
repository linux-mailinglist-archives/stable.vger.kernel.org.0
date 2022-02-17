Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E54C4BA402
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 16:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiBQPLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 10:11:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235746AbiBQPLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 10:11:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6E927829C
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 07:11:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DD8361E72
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 15:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A7CC340E8;
        Thu, 17 Feb 2022 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645110660;
        bh=5o1+QVA3b/AW6GdVLN2qUXz3RiiG4D4Dni2OfgMVGW4=;
        h=Subject:To:From:Date:From;
        b=slwaKSy5QXiDl9fefW7PEtgw2P0uI39p7GxCzWUijShYl6boKId3JCGvkX4nnkmcy
         aVmQf36pC5Ip3CDoufyjSwMF4xg4OZ/iL4y93xTZEU/I5lrfu2juAa0R1mJCeUjRWY
         8l5oBWnLuvKnlB6rvibsOju68YmgOScSnp89NQ58=
Subject: patch "usb: dwc2: drd: fix soft connect when gadget is unconfigured" added to usb-linus
To:     fabrice.gasnier@foss.st.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Feb 2022 16:10:44 +0100
Message-ID: <1645110644133190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: drd: fix soft connect when gadget is unconfigured

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 32fde84362c40961726a5c91f35ad37355ccc0c6 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Date: Wed, 16 Feb 2022 09:12:15 +0100
Subject: usb: dwc2: drd: fix soft connect when gadget is unconfigured

When the gadget driver hasn't been (yet) configured, and the cable is
connected to a HOST, the SFTDISCON gets cleared unconditionally, so the
HOST tries to enumerate it.
At the host side, this can result in a stuck USB port or worse. When
getting lucky, some dmesg can be observed at the host side:
 new high-speed USB device number ...
 device descriptor read/64, error -110

Fix it in drd, by checking the enabled flag before calling
dwc2_hsotg_core_connect(). It will be called later, once configured,
by the normal flow:
- udc_bind_to_driver
 - usb_gadget_connect
   - dwc2_hsotg_pullup
     - dwc2_hsotg_core_connect

Fixes: 17f934024e84 ("usb: dwc2: override PHY input signals with usb role switch support")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/1644999135-13478-1-git-send-email-fabrice.gasnier@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core.h | 2 ++
 drivers/usb/dwc2/drd.c  | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index 8a63da3ab39d..88c337bf564f 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -1418,6 +1418,7 @@ void dwc2_hsotg_core_connect(struct dwc2_hsotg *hsotg);
 void dwc2_hsotg_disconnect(struct dwc2_hsotg *dwc2);
 int dwc2_hsotg_set_test_mode(struct dwc2_hsotg *hsotg, int testmode);
 #define dwc2_is_device_connected(hsotg) (hsotg->connected)
+#define dwc2_is_device_enabled(hsotg) (hsotg->enabled)
 int dwc2_backup_device_registers(struct dwc2_hsotg *hsotg);
 int dwc2_restore_device_registers(struct dwc2_hsotg *hsotg, int remote_wakeup);
 int dwc2_gadget_enter_hibernation(struct dwc2_hsotg *hsotg);
@@ -1454,6 +1455,7 @@ static inline int dwc2_hsotg_set_test_mode(struct dwc2_hsotg *hsotg,
 					   int testmode)
 { return 0; }
 #define dwc2_is_device_connected(hsotg) (0)
+#define dwc2_is_device_enabled(hsotg) (0)
 static inline int dwc2_backup_device_registers(struct dwc2_hsotg *hsotg)
 { return 0; }
 static inline int dwc2_restore_device_registers(struct dwc2_hsotg *hsotg,
diff --git a/drivers/usb/dwc2/drd.c b/drivers/usb/dwc2/drd.c
index 1b39c4776369..d8d6493bc457 100644
--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -130,8 +130,10 @@ static int dwc2_drd_role_sw_set(struct usb_role_switch *sw, enum usb_role role)
 		already = dwc2_ovr_avalid(hsotg, true);
 	} else if (role == USB_ROLE_DEVICE) {
 		already = dwc2_ovr_bvalid(hsotg, true);
-		/* This clear DCTL.SFTDISCON bit */
-		dwc2_hsotg_core_connect(hsotg);
+		if (dwc2_is_device_enabled(hsotg)) {
+			/* This clear DCTL.SFTDISCON bit */
+			dwc2_hsotg_core_connect(hsotg);
+		}
 	} else {
 		if (dwc2_is_device_mode(hsotg)) {
 			if (!dwc2_ovr_bvalid(hsotg, false))
-- 
2.35.1


