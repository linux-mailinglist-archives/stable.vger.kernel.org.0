Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D275AB12A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbiIBNGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbiIBNE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:04:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883BF1123B5;
        Fri,  2 Sep 2022 05:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 225BC6215A;
        Fri,  2 Sep 2022 12:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D059C433D6;
        Fri,  2 Sep 2022 12:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122129;
        bh=IC0Xcmb1kumLQWLiI4eJziIM3Bb2aDtDDQkA3g87UtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbC8GQra80jAdf+wJ2iZS0FbMAJu01/GGlGEG5kKC4XY2irQWR+aPXStBi/Bujxyy
         uNDAlYWI84koikYFjl07UgUHTS9/hd7kQw4s87BhfiSObDfuBgUFKtEPizqcsiy0sq
         AjkcaTIWVNR5hu4JqCGCnVwAvC+PjcVIs8uNyg5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 21/72] HID: add Lenovo Yoga C630 battery quirk
Date:   Fri,  2 Sep 2022 14:18:57 +0200
Message-Id: <20220902121405.483023351@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Steev Klimaszewski <steev@kali.org>

commit 3a47fa7b14c7d9613909a844aba27f99d3c58634 upstream.

Similar to the Surface Go devices, the Elantech touchscreen/digitizer in
the Lenovo Yoga C630 mistakenly reports the battery of the stylus, and
always reports an empty battery.

Apply the HID_BATTERY_QUIRK_IGNORE quirk to ignore this battery and
prevent the erroneous low battery warnings.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-input.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -414,6 +414,7 @@
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
 #define I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN	0x2A1C
+#define I2C_DEVICE_ID_LENOVO_YOGA_C630_TOUCHSCREEN	0x279F
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -383,6 +383,8 @@ static const struct hid_device_id hid_ba
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_LENOVO_YOGA_C630_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 


