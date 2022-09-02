Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04D15AB123
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbiIBNEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238723AbiIBNDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D95110F080;
        Fri,  2 Sep 2022 05:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3819F6211C;
        Fri,  2 Sep 2022 12:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E06FC433D6;
        Fri,  2 Sep 2022 12:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121943;
        bh=QXhlD+e++6kgBMShPi6oO6OcUkdZpztpCjKg39eR83k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzIP9wI8ajNBR1PwPlQd9BoYN+vOKJUxkADcx7j8iEJ4LqJGjJxpUOAJu8Q1L178K
         p/woON2/fN98iJXq0oT/co1vGFTLnrVh9eFDipadOIn7KmxKRHriBA7PXuK+tf1x1i
         WHgjDYrfMyePt+kne4DIv0cFMV/QEqT432hD1kbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 37/73] HID: add Lenovo Yoga C630 battery quirk
Date:   Fri,  2 Sep 2022 14:19:01 +0200
Message-Id: <20220902121405.661670249@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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
@@ -399,6 +399,7 @@
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
 #define I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN	0x2A1C
+#define I2C_DEVICE_ID_LENOVO_YOGA_C630_TOUCHSCREEN	0x279F
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -335,6 +335,8 @@ static const struct hid_device_id hid_ba
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_LENOVO_YOGA_C630_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 


