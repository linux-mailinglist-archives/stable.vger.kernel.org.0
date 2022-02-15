Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54D74B71B0
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240769AbiBOPhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:37:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240714AbiBOPf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BE0C12C7;
        Tue, 15 Feb 2022 07:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7282E615FD;
        Tue, 15 Feb 2022 15:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2883C340F2;
        Tue, 15 Feb 2022 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939068;
        bh=LLlU9Yz0qJd6M5GUEcjm4rSHGKVK6e1eS2D9+IWEWIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSW52LtcdnxtdwX+2+8Q/Ku/hsgId3rQxCoKQUn9LKzV2FcF2Peu20wfQlTHAddD2
         8SwllK5Oc79/pI65y3OD3qGU5bo3yh0A43Uumol8xND0InrVJ7Xo/Bba8RQhWB4byL
         6+Cjb/ETrbnG85vM0y8ztDeTig7QlPWG5c3FNzdABNkQj1ml28Wf0kVuPPnop6YdAH
         RhZds3SPBoYVE/mUv2Z+Ac0VPs82ufBfQzuIizRYKCfbs0Lt+5ABkyXHkE/v45zA+M
         z98hm59rSdx7wAoW2iellA2mKp2uWdp350w/AEK+ktVbTOjIvgA+vvN5jJUozJVf+3
         kOVIyMGzQAPhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tommaso Merciai <tomm.merciai@gmail.com>,
        Richard Leitner <richard.leitner@linux.dev>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, richard.leitner@skidata.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/11] usb: usb251xb: add boost-up property support
Date:   Tue, 15 Feb 2022 10:30:55 -0500
Message-Id: <20220215153104.581786-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153104.581786-1-sashal@kernel.org>
References: <20220215153104.581786-1-sashal@kernel.org>
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
index 5f7734c729b1d..8444b92f9737f 100644
--- a/drivers/usb/misc/usb251xb.c
+++ b/drivers/usb/misc/usb251xb.c
@@ -510,6 +510,9 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 	if (of_property_read_u16_array(np, "language-id", &hub->lang_id, 1))
 		hub->lang_id = USB251XB_DEF_LANGUAGE_ID;
 
+	if (of_property_read_u8(np, "boost-up", &hub->boost_up))
+		hub->boost_up = USB251XB_DEF_BOOST_UP;
+
 	cproperty_char = of_get_property(np, "manufacturer", NULL);
 	strlcpy(str, cproperty_char ? : USB251XB_DEF_MANUFACTURER_STRING,
 		sizeof(str));
@@ -543,7 +546,6 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 	 * may be as soon as needed.
 	 */
 	hub->bat_charge_en = USB251XB_DEF_BATTERY_CHARGING_ENABLE;
-	hub->boost_up = USB251XB_DEF_BOOST_UP;
 	hub->boost_57 = USB251XB_DEF_BOOST_57;
 	hub->boost_14 = USB251XB_DEF_BOOST_14;
 	hub->port_swap = USB251XB_DEF_PORT_SWAP;
-- 
2.34.1

