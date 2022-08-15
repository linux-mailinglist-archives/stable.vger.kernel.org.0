Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34103593D87
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiHOUGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345945AbiHOUFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:05:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1612547B9B;
        Mon, 15 Aug 2022 11:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 623C6B810C5;
        Mon, 15 Aug 2022 18:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5FAC433D6;
        Mon, 15 Aug 2022 18:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589693;
        bh=s9bXR2LcdQjUHgWzlKWD/cjyM09nvznL3+43Lz274b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFDSfh+B9SM9sx8Yvqqcl26oogsvqOKgNi/wIC+uscvWbShDEcPfUH4Z3F20wI1JZ
         dKfN93J4iWuonFa2pgvZevgIM9BC4d5NkxNRG7LVNqvFZjEMfiqllokNyMtZoN05Yg
         a7DlKyx8oPmlcDdN7bmr8rhnxJQSon1H8Zmmp5BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.18 0019/1095] HID: hid-input: add Surface Go battery quirk
Date:   Mon, 15 Aug 2022 19:50:18 +0200
Message-Id: <20220815180430.139759532@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Maximilian Luz <luzmaximilian@gmail.com>

commit db925d809011c37b246434fdce71209fc2e6c0c2 upstream.

Similar to the Surface Go (1), the (Elantech) touchscreen/digitizer in
the Surface Go 2 mistakenly reports the battery of the stylus. Instead
of over the touchscreen device, battery information is provided via
bluetooth and the touchscreen device reports an empty battery.

Apply the HID_BATTERY_QUIRK_IGNORE quirk to ignore this battery and
prevent the erroneous low battery warnings.

Cc: stable@vger.kernel.org
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-input.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -413,6 +413,7 @@
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
+#define I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN	0x2A1C
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -381,6 +381,8 @@ static const struct hid_device_id hid_ba
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 


