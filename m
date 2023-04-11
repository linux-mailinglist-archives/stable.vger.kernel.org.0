Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849BF6DD7DB
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 12:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDKK02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 06:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjDKK01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 06:26:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13318F2
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 03:26:26 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pmBCX-00077U-29; Tue, 11 Apr 2023 12:26:13 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pmBCT-0001IE-Ha; Tue, 11 Apr 2023 12:26:09 +0200
Date:   Tue, 11 Apr 2023 12:26:09 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Tim K <tpkuester@gmail.com>, "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
Message-ID: <20230411102609.GB19113@pengutronix.de>
References: <20230404072508.578056-1-s.hauer@pengutronix.de>
 <20230404072508.578056-3-s.hauer@pengutronix.de>
 <e9c9b7d470904d9f8c8d6892cb8efd7d@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c9b7d470904d9f8c8d6892cb8efd7d@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
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

On Thu, Apr 06, 2023 at 01:54:55AM +0000, Ping-Ke Shih wrote:
> 
> 
> > -----Original Message-----
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > Sent: Tuesday, April 4, 2023 3:25 PM
> > To: linux-wireless <linux-wireless@vger.kernel.org>
> > Cc: Hans Ulli Kroll <linux@ulli-kroll.de>; Larry Finger <Larry.Finger@lwfinger.net>; Ping-Ke Shih
> > <pkshih@realtek.com>; Tim K <tpkuester@gmail.com>; Alex G . <mr.nuke.me@gmail.com>; Nick Morrow
> > <morrownr@gmail.com>; Viktor Petrenko <g0000ga@gmail.com>; Andreas Henriksson <andreas@fatal.se>;
> > ValdikSS <iam@valdikss.org.ru>; kernel@pengutronix.de; Sascha Hauer <s.hauer@pengutronix.de>;
> > stable@vger.kernel.org
> > Subject: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
> > 
> > On my RTW8821CU chipset rfe_option reads as 0x22. Looking at the
> > downstream driver suggests that the field width of rfe_option is 5 bit,
> > so rfe_option should be masked with 0x1f.
> 
> I don't aware of this. Could you point where you get it?

See
https://github.com/morrownr/8821cu-20210916/blob/main/hal/btc/halbtc8821c1ant.c#L2480
and
https://github.com/morrownr/8821cu-20210916/blob/main/hal/btc/halbtc8821c2ant.c#L2519

But I now see that this masked value is only used at the places I
pointed to, there are other places in the driver that use the unmasked
value.

> 
> As I check it internally, 0x22 is expected, so I suggest to have 0x22 entry
> as below
> 
> -       [34] = RTW_DEF_RFE(8821c, 0, 0),
> +       [34] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),  // copy from type 2

That alone is not enough. There are other places in rtw8821c.c that
compare with rfe_option. See below for a patch with annotations where to
find the corresponding code in the downstream driver. Note how BIT(5) is
irrelevant for all decisions. I can't tell of course if that's just by
chance or by intent.

I don't know where to go from here. It looks like we really only want to
make a decision between SWITCH_TO_WLG and SWITCH_TO_BTG at most places,
so it might be better to store a flag somewhere rather than having the
big switch/case in multiple places.

Sascha

-------------------------------8<---------------------------------

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 17f800f6efbd0..5da7787cea129 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -317,11 +317,32 @@ static void rtw8821c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
 	}
 
 	if (channel <= 14) {
-		if (rtwdev->efuse.rfe_option == 0)
-			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_WLG);
-		else if (rtwdev->efuse.rfe_option == 2 ||
-			 rtwdev->efuse.rfe_option == 4)
+		/*
+		 * see:
+		 * https://github.com/morrownr/8821cu-20210916/blob/main/hal/phydm/rtl8821c/phydm_hal_api8821c.c#L338
+		 */
+		switch (rtwdev->efuse.rfe_option) {
+		case 0x02: case 0x22:
+		case 0x04: case 0x24:
+		case 0x07: case 0x27:
+		case 0x2a:
+		case 0x2c:
+		case 0x2f:
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_BTG);
+			break;
+		case 0x00: case 0x20:
+		case 0x01: case 0x21:
+		case 0x03: case 0x23:
+		case 0x05: case 0x25:
+		case 0x06: case 0x26:
+		case 0x28:
+		case 0x29:
+		case 0x2b:
+		case 0x2d:
+		case 0x2e:
+		default:
+			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_WLG);
+		}
 		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTDBG, BIT(6), 0x1);
 		rtw_write_rf(rtwdev, RF_PATH_A, 0x64, 0xf, 0xf);
 	} else {
@@ -501,12 +522,35 @@ static s8 get_cck_rx_pwr(struct rtw_dev *rtwdev, u8 lna_idx, u8 vga_idx)
 	s8 rx_pwr_all = 0;
 	s8 lna_gain = 0;
 
-	if (efuse->rfe_option == 0) {
-		lna_gain_table = lna_gain_table_0;
-		lna_gain_table_size = ARRAY_SIZE(lna_gain_table_0);
-	} else {
+	/*
+	 * see:
+	 * https://github.com/morrownr/8821cu-20210916/blob/main/hal/phydm/rtl8821c/phydm_hal_api8821c.c#L52
+	 * https://github.com/morrownr/8821cu-20210916/blob/main/hal/phydm/phydm.c#L178
+	 */
+	switch (rtwdev->efuse.rfe_option) {
+	case 0x02: case 0x22:
+	case 0x04: case 0x24:
+	case 0x07: case 0x27:
+	case 0x2a:
+	case 0x2c:
+	case 0x2f:
 		lna_gain_table = lna_gain_table_1;
 		lna_gain_table_size = ARRAY_SIZE(lna_gain_table_1);
+		break;
+	case 0x00: case 0x20:
+	case 0x01: case 0x21:
+	case 0x03: case 0x23:
+	case 0x05: case 0x25:
+	case 0x06: case 0x26:
+	case 0x28:
+	case 0x29:
+	case 0x2b:
+	case 0x2d:
+	case 0x2e:
+	default:
+		lna_gain_table = lna_gain_table_0;
+		lna_gain_table_size = ARRAY_SIZE(lna_gain_table_0);
+		break;
 	}
 
 	if (lna_idx >= lna_gain_table_size) {
@@ -821,6 +865,9 @@ static void rtw8821c_coex_cfg_ant_switch(struct rtw_dev *rtwdev, u8 ctrl_type,
 				DPDT_CTRL_PIN);
 
 		if (pos_type == COEX_SWITCH_TO_WLG_BT) {
+			/*
+			 * What here? Cannot find refval = 0x3 in downstream driver
+			 */
 			if (coex_rfe->rfe_module_type != 0x4 &&
 			    coex_rfe->rfe_module_type != 0x2)
 				regval = 0x3;
@@ -902,7 +949,12 @@ static void rtw8821c_coex_cfg_rfe_type(struct rtw_dev *rtwdev)
 	coex_rfe->ant_switch_exist = true;
 	coex_rfe->wlg_at_btg = false;
 
-	switch (coex_rfe->rfe_module_type) {
+	/*
+	 * see:
+	 * https://github.com/morrownr/8821cu-20210916/blob/main/hal/btc/halbtc8821c1ant.c#L2480
+	 * https://github.com/morrownr/8821cu-20210916/blob/main/hal/btc/halbtc8821c2ant.c#L2519
+	 */
+	switch (coex_rfe->rfe_module_type & 0x1f) {
 	case 0:
 	case 8:
 	case 1:
@@ -1533,11 +1585,30 @@ static const struct rtw_intf_phy_para_table phy_para_table_8821c = {
 };
 
 static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
-	[0] = RTW_DEF_RFE(8821c, 0, 0),
-	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
-	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
-	[6] = RTW_DEF_RFE(8821c, 0, 0),
-	[34] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x00] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x01] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x02] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[0x03] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x04] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[0x05] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x06] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x07] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[0x20] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x21] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x22] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[0x23] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x24] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[0x25] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x26] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x27] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[0x28] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x29] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x2a] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[0x2b] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x2c] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[0x2d] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x2e] = RTW_DEF_RFE(8821c, 0, 0),
+	[0x2f] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
-- 
2.39.2


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
