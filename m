Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B0853CFFE
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346096AbiFCR6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346022AbiFCR6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:58:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE4857998;
        Fri,  3 Jun 2022 10:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F3FAB82189;
        Fri,  3 Jun 2022 17:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B12C385A9;
        Fri,  3 Jun 2022 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278880;
        bh=vTWiCd2qo69ZjfuxwNlgeer11jVQIY4xgUWXfDmgCgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vlm3RsqqJ94sJV0/CpPy4wwg16Kmf86MTd+lZpx+/BZ6jhZEbXcmZH9D4hYHByMRO
         ANRXgTkQ0oxOT3NapkQ3lPf84x7ypnb4GyuW9mAvvwThB4xZDfBoBmAyY7Ygu7l6+g
         OWXmb4gx/gn4gd39Yq+R/b0i/9Wc0O8JSagadUzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Jin <tao-j@outlook.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.17 56/75] HID: multitouch: add quirks to enable Lenovo X12 trackpoint
Date:   Fri,  3 Jun 2022 19:43:40 +0200
Message-Id: <20220603173823.328601324@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Jin <tao-j@outlook.com>

commit 95cd2cdc88c755dcd0a58b951faeb77742c733a4 upstream.

This applies the similar quirks used by previous generation devices
such as X1 tablet for X12 tablet, so that the trackpoint and buttons
can work.

This patch was applied and tested working on 5.17.1 .

Cc: stable@vger.kernel.org # 5.8+ given that it relies on 40d5bb87377a
Signed-off-by: Tao Jin <tao-j@outlook.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/CO6PR03MB6241CB276FCDC7F4CEDC34F6E1E29@CO6PR03MB6241.namprd03.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -760,6 +760,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
+#define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
 #define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2034,6 +2034,12 @@ static const struct hid_device_id mt_dev
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X1_TAB3) },
 
+	/* Lenovo X12 TAB Gen 1 */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_X12_TAB) },
+
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_ASUS,


