Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDFC4B71A7
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiBOPa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:30:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240124AbiBOPaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:30:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07335A94DE;
        Tue, 15 Feb 2022 07:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9839061532;
        Tue, 15 Feb 2022 15:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBF8C340F1;
        Tue, 15 Feb 2022 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938924;
        bh=4XprZ8kVjqQf1hik5gV9O0oBPRZ4MmrgDLSO0ROKOT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRNXzlfaSEVdcltHARQyPDG0nBf5TF0oHtR+DJ/ABBVvKWkeQk7j5Di2p5cd2K535
         dgYj+Yzvkkta4yF8FcE7/4JTqBQC4VywODaDpNhoXmFy39cfpZ5TJCF9vMvrLc2vgQ
         VgeUQU8frrRZ+Pfdx9i3uwhHp5wTj4QqHlBB8ADyUf78CDWzmRyL4TCFeXlGnOcPdh
         um7XtWyChD/KmZ7jbiKEVRwd+yydpha/x7OIg6L1iciRJZ2tV5PfuLH1RsQqNGaGfR
         Dv+KgiLupgKWdsHDzRZ7oVTcgqebDJ8KIM6bHhe6dcfoReMaZBtxkl8JFMUc6WmrWI
         4TgvT/koJRV2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tommaso Merciai <tomm.merciai@gmail.com>,
        Richard Leitner <richard.leitner@linux.dev>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, richard.leitner@skidata.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/33] usb: usb251xb: add boost-up property support
Date:   Tue, 15 Feb 2022 10:28:04 -0500
Message-Id: <20220215152831.580780-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Tommaso Merciai <tomm.merciai@gmail.com>

[ Upstream commit 5c2b9c61ae5d8ad0a196d33b66ce44543be22281 ]

Add support for boost-up register of usb251xb hub.
boost-up property control USB electrical drive strength
This register can be set:

 - Normal mode -> 0x00
 - Low         -> 0x01
 - Medium      -> 0x10
 - High        -> 0x11

(Normal Default)

References:
 - http://www.mouser.com/catalog/specsheets/2514.pdf p29

Reviewed-by: Richard Leitner <richard.leitner@linux.dev>
Signed-off-by: Tommaso Merciai <tomm.merciai@gmail.com>
Link: https://lore.kernel.org/r/20220128181713.96856-1-tomm.merciai@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/usb251xb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usb251xb.c b/drivers/usb/misc/usb251xb.c
index 507deef1f7093..04c4e3fed0946 100644
--- a/drivers/usb/misc/usb251xb.c
+++ b/drivers/usb/misc/usb251xb.c
@@ -543,6 +543,9 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 	if (of_property_read_u16_array(np, "language-id", &hub->lang_id, 1))
 		hub->lang_id = USB251XB_DEF_LANGUAGE_ID;
 
+	if (of_property_read_u8(np, "boost-up", &hub->boost_up))
+		hub->boost_up = USB251XB_DEF_BOOST_UP;
+
 	cproperty_char = of_get_property(np, "manufacturer", NULL);
 	strlcpy(str, cproperty_char ? : USB251XB_DEF_MANUFACTURER_STRING,
 		sizeof(str));
@@ -584,7 +587,6 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 	 * may be as soon as needed.
 	 */
 	hub->bat_charge_en = USB251XB_DEF_BATTERY_CHARGING_ENABLE;
-	hub->boost_up = USB251XB_DEF_BOOST_UP;
 	hub->boost_57 = USB251XB_DEF_BOOST_57;
 	hub->boost_14 = USB251XB_DEF_BOOST_14;
 	hub->port_map12 = USB251XB_DEF_PORT_MAP_12;
-- 
2.34.1

