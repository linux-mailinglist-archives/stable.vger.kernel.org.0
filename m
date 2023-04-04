Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785686D5977
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjDDHZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbjDDHZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:25:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3695910D3
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 00:25:23 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pjb2V-000749-15; Tue, 04 Apr 2023 09:25:11 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1pjb2U-008rco-D6; Tue, 04 Apr 2023 09:25:10 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1pjb2T-002UPq-HU; Tue, 04 Apr 2023 09:25:09 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless <linux-wireless@vger.kernel.org>
Cc:     Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Tim K <tpkuester@gmail.com>,
        "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
Date:   Tue,  4 Apr 2023 09:25:08 +0200
Message-Id: <20230404072508.578056-3-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404072508.578056-1-s.hauer@pengutronix.de>
References: <20230404072508.578056-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On my RTW8821CU chipset rfe_option reads as 0x22. Looking at the
downstream driver suggests that the field width of rfe_option is 5 bit,
so rfe_option should be masked with 0x1f.

Without this the rfe_option comparisons with 2 further down the
driver evaluate as false when they should really evaluate as true.
The effect is that 2G channels do not work.

rfe_option is also used as an array index into rtw8821c_rfe_defs[].
rtw8821c_rfe_defs[34] (0x22) was added as part of adding USB support,
likely because rfe_option reads as 0x22. As this now becomes 0x2,
rtw8821c_rfe_defs[34] is no longer used and can be removed.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: ValdikSS <iam@valdikss.org.ru>
Tested-by: Alexandru gagniuc <mr.nuke.me@gmail.com>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 17f800f6efbd0..67efa58dd78ee 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -47,7 +47,7 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 
 	map = (struct rtw8821c_efuse *)log_map;
 
-	efuse->rfe_option = map->rfe_option;
+	efuse->rfe_option = map->rfe_option & 0x1f;
 	efuse->rf_board_option = map->rf_board_option;
 	efuse->crystal_cap = map->xtal_k;
 	efuse->pa_type_2g = map->pa_type;
@@ -1537,7 +1537,6 @@ static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 	[6] = RTW_DEF_RFE(8821c, 0, 0),
-	[34] = RTW_DEF_RFE(8821c, 0, 0),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
-- 
2.39.2

