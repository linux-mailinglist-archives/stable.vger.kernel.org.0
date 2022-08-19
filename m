Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774A859A304
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353651AbiHSQml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353554AbiHSQkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:40:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D488A062B;
        Fri, 19 Aug 2022 09:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9178B8280D;
        Fri, 19 Aug 2022 16:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37272C433C1;
        Fri, 19 Aug 2022 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925322;
        bh=fRpaHOTVvjGhWoeLgmyrtXPSRl5K4DcJaXeRA0U0+9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsmDPZp0JmsVJiw3BnPi4CJIESHcuJcmw87nipeZ816lhR+xPW/G1b+UtSrmNWpc3
         uBK0OpjPgC9fI1OfKjc9n1G+ZQvJO7x7CB77aHFOH9943gMlVsduBMHibXW/qhJE0r
         tBqXODcDVyEpYRe7Qw6ZWhzaRL3polNcKTI7F3JE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elia Devito <eliadevito@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 455/545] HID: Ignore battery for Elan touchscreen on HP Spectre X360 15-df0xxx
Date:   Fri, 19 Aug 2022 17:43:45 +0200
Message-Id: <20220819153849.760682240@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Elia Devito <eliadevito@gmail.com>

[ Upstream commit decfe496fe77061dea658a0bfa11afd4f92b540d ]

Battery status is reported for the HP Spectre X360 Convertible 15-df0xxx
even if it does not have a battery. Prevent it to always report the
battery as low.

Signed-off-by: Elia Devito <eliadevito@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3744c3db5140..cf69191b6693 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -389,6 +389,7 @@
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
+#define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 
 #define USB_VENDOR_ID_ELECOM		0x056e
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index a17d1dda9570..329b7ffb7e6a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -324,6 +324,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.35.1



