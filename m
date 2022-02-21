Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2D54BE627
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350617AbiBUJsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:48:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351431AbiBUJpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:45:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E44F24583;
        Mon, 21 Feb 2022 01:18:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BFF20CE0E95;
        Mon, 21 Feb 2022 09:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9057C340E9;
        Mon, 21 Feb 2022 09:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435097;
        bh=njprf4EQZkcdf9skW1BHjZeK2PaGU6yJPOz+Hrf9oxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJNrUXnT9Ufg8hzBcjNz20tKINP4Z/xxq7KvwP5RODk58VOvej02Db4o305cP5j3F
         hS+LL2JcyVCIStJ1TS/WUF6UBdYHc3q43De+u3Hh0tIZN0idqxMJ305TZ6RWbDgGPt
         NaWReurrcbrdHvJKj0T0qE45hAUGl26m7FmG/s3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergio Costas <rastersoft@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.16 011/227] HID:Add support for UGTABLET WP5540
Date:   Mon, 21 Feb 2022 09:47:10 +0100
Message-Id: <20220221084935.216097176@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Sergio Costas <rastersoft@gmail.com>

commit fd5dd6acd8f823ea804f76d3af64fa1be9d5fb78 upstream.

This patch adds support for the UGTABLET WP5540 digitizer tablet
devices. Without it, the pen moves the cursor, but neither the
buttons nor the tap sensor in the tip do work.

Signed-off-by: Sergio Costas <rastersoft@gmail.com>
Link: https://lore.kernel.org/r/63dece1d-91ca-1b1b-d90d-335be66896be@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1365,6 +1365,7 @@
 #define USB_VENDOR_ID_UGTIZER			0x2179
 #define USB_DEVICE_ID_UGTIZER_TABLET_GP0610	0x0053
 #define USB_DEVICE_ID_UGTIZER_TABLET_GT5040	0x0077
+#define USB_DEVICE_ID_UGTIZER_TABLET_WP5540	0x0004
 
 #define USB_VENDOR_ID_VIEWSONIC			0x0543
 #define USB_DEVICE_ID_VIEWSONIC_PD1011		0xe621
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -187,6 +187,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_KEYBOARD), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_KNA5), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_TWA60), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGTIZER, USB_DEVICE_ID_UGTIZER_TABLET_WP5540), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SIRIUS_BATTERY_FREE_TABLET), HID_QUIRK_MULTI_INPUT },


