Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93852F3C7
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 21:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbiETTbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 15:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353226AbiETTby (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 15:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222C6195792
        for <stable@vger.kernel.org>; Fri, 20 May 2022 12:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF84861B5A
        for <stable@vger.kernel.org>; Fri, 20 May 2022 19:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D2FC385A9;
        Fri, 20 May 2022 19:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653075112;
        bh=Rswnx8MAVy06CUGPbWLPckdT7bNAlPj/7MttQQh3S/M=;
        h=Subject:To:From:Date:From;
        b=VAS00o4kBpVy3KeLL1uMDeVNnqIhsecpDCm69Xucu7Sm5sRaWhjMc0QsJ0jcxF6iB
         CsRHIRwuhqYDHnEIxEmJaPGTaWYdjYteBn3P22fqw0EiEXDhoEdsitWipkB3zOMXpT
         Xu0rtM56Agu2By+D8b1L1Z1NsUwIWaou8Pq0DPJo=
Subject: patch "USB: new quirk for Dell Gen 2 devices" added to usb-testing
To:     monish.kumar.r@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 20 May 2022 21:18:53 +0200
Message-ID: <165307433327232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: new quirk for Dell Gen 2 devices

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 97fa5887cf283bb75ffff5f6b2c0e71794c02400 Mon Sep 17 00:00:00 2001
From: Monish Kumar R <monish.kumar.r@intel.com>
Date: Fri, 20 May 2022 18:30:44 +0530
Subject: USB: new quirk for Dell Gen 2 devices

Add USB_QUIRK_NO_LPM and USB_QUIRK_RESET_RESUME quirks for Dell usb gen
2 device to not fail during enumeration.

Found this bug on own testing

Signed-off-by: Monish Kumar R <monish.kumar.r@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220520130044.17303-1-monish.kumar.r@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 97b44a68668a..f99a65a64588 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -510,6 +510,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* DELL USB GEN2 */
+	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
+
 	/* VCOM device */
 	{ USB_DEVICE(0x4296, 0x7570), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
 
-- 
2.36.1


