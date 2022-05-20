Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DAC52F3CB
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 21:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353226AbiETTcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 15:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353236AbiETTcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 15:32:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3411912E4
        for <stable@vger.kernel.org>; Fri, 20 May 2022 12:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77643B82A55
        for <stable@vger.kernel.org>; Fri, 20 May 2022 19:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2CCC385A9;
        Fri, 20 May 2022 19:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653075122;
        bh=1dDoJ/qyoZrNAd59cyxsiBRTUOERaBm9PEgUfjxHOjU=;
        h=Subject:To:From:Date:From;
        b=Ql2bmwf5p/WG+Kv5VZygI2cPg2bcrO5Hw3OEU/p53jGokVIjwCVtgXoEEI93ah5vl
         lkPmSHBt68ZJZK7Q81X7e+S03Q5klIUE++UpDNX85LeDoYGFab1H9QfPcVzomiIqrM
         3PiT7Jlw0zaKzkCixfnCxz0hbMHkwCAv76aVYaXs=
Subject: patch "USB: new quirk for Dell Gen 2 devices" added to usb-next
To:     monish.kumar.r@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 20 May 2022 21:19:51 +0200
Message-ID: <165307439198107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


