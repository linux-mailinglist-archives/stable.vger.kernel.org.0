Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1856584B0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbiL1RAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbiL1Q7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:59:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1CC1BEB5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BE2861558
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AE1C433F1;
        Wed, 28 Dec 2022 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246514;
        bh=wE2XrpPeJUTqefW0cp6dsPgxCFB6idxcSUHfgSjbmQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzGeCbLcc2EIYtjGj5LiTJaEWcF7QJmASQPfNbBX1HU1oxctvIGMWz35hRg1eoDRZ
         Rh87qKyp8KwKSPci+t/LYHGSoNvOF+dBel19dnwXqBH7R9PX7t+LvY1stMT+KZP5+K
         To/AczTvTfO0mjCjsnXuNaYjvKSoda96tuOxLj3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Denis Pauk <pauk.denis@gmail.com>,
        yutesdb <mundanedefoliation@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1035/1146] hwmon: (nct6775) add ASUS CROSSHAIR VIII/TUF/ProArt B550M
Date:   Wed, 28 Dec 2022 15:42:54 +0100
Message-Id: <20221228144358.469548779@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 1864069c695d475e0ce98a335c62274b81be57b4 ]

Boards such as
* ProArt B550-CREATOR
* ProArt Z490-CREATOR 10G
* ROG CROSSHAIR VIII EXTREME
* ROG CROSSHAIR VIII HERO (WI-FI)
* TUF GAMING B550M-E
* TUF GAMING B550M-E (WI-FI)
* TUF GAMING B550M-PLUS WIFI II
have got a nct6775 chip, but by default there's no use of it
because of resource conflict with WMI method.

This commit adds such boards to the WMI monitoring list.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Reported-by: yutesdb <mundanedefoliation@gmail.com>
Tested-by: yutesdb <mundanedefoliation@gmail.com>
Link: https://lore.kernel.org/r/20221114214456.3891-1-pauk.denis@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index b34783784213..bf43f73dc835 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1043,7 +1043,9 @@ static struct platform_device *pdev[2];
 
 static const char * const asus_wmi_boards[] = {
 	"PRO H410T",
+	"ProArt B550-CREATOR",
 	"ProArt X570-CREATOR WIFI",
+	"ProArt Z490-CREATOR 10G",
 	"Pro B550M-C",
 	"Pro WS X570-ACE",
 	"PRIME B360-PLUS",
@@ -1055,8 +1057,10 @@ static const char * const asus_wmi_boards[] = {
 	"PRIME X570-P",
 	"PRIME X570-PRO",
 	"ROG CROSSHAIR VIII DARK HERO",
+	"ROG CROSSHAIR VIII EXTREME",
 	"ROG CROSSHAIR VIII FORMULA",
 	"ROG CROSSHAIR VIII HERO",
+	"ROG CROSSHAIR VIII HERO (WI-FI)",
 	"ROG CROSSHAIR VIII IMPACT",
 	"ROG STRIX B550-A GAMING",
 	"ROG STRIX B550-E GAMING",
@@ -1080,8 +1084,11 @@ static const char * const asus_wmi_boards[] = {
 	"ROG STRIX Z490-G GAMING (WI-FI)",
 	"ROG STRIX Z490-H GAMING",
 	"ROG STRIX Z490-I GAMING",
+	"TUF GAMING B550M-E",
+	"TUF GAMING B550M-E (WI-FI)",
 	"TUF GAMING B550M-PLUS",
 	"TUF GAMING B550M-PLUS (WI-FI)",
+	"TUF GAMING B550M-PLUS WIFI II",
 	"TUF GAMING B550-PLUS",
 	"TUF GAMING B550-PLUS WIFI II",
 	"TUF GAMING B550-PRO",
-- 
2.35.1



