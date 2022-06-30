Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A61561CE2
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbiF3OJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbiF3OIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:08:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E42599FF;
        Thu, 30 Jun 2022 06:55:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FEBF61FDB;
        Thu, 30 Jun 2022 13:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B37FC34115;
        Thu, 30 Jun 2022 13:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597311;
        bh=D4HoO050c3aJJTK/c0qhVi+v3wZq7QnP8S3rtyT7FqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyIgr8PDJs5rTqRW+VZSX8SYm9Owi4mh4yGT2Gu5vIz6dRVTM1XdSL4QNNODVavCp
         6zrU0KnlASzH6hHAR+Vd/lep/VBOzToqB83osII0TMUEc+4e6IH9kXPXzjtlbOhFfX
         saYE4Z+lkH/wj9m3TUHzXYJLQT1tWfNl0aoQgG54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo-Feng Fan <vincent_fann@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH 5.15 25/28] rtw88: 8821c: support RFE type4 wifi NIC
Date:   Thu, 30 Jun 2022 15:47:21 +0200
Message-Id: <20220630133233.672607668@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo-Feng Fan <vincent_fann@realtek.com>

commit b789e3fe7047296be0ccdbb7ceb0b58856053572 upstream.

RFE type4 is a new NIC which has one RF antenna shares with BT.
RFE type4 HW is the same as RFE type2 but attaching antenna to
aux antenna connector.

RFE type2 attach antenna to main antenna connector.
Load the same parameter as RFE type2 when initializing NIC.

Signed-off-by: Guo-Feng Fan <vincent_fann@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210922023637.9357-1-pkshih@realtek.com
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -304,7 +304,8 @@ static void rtw8821c_set_channel_rf(stru
 	if (channel <= 14) {
 		if (rtwdev->efuse.rfe_option == 0)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_WLG);
-		else if (rtwdev->efuse.rfe_option == 2)
+		else if (rtwdev->efuse.rfe_option == 2 ||
+			 rtwdev->efuse.rfe_option == 4)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_BTG);
 		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTDBG, BIT(6), 0x1);
 		rtw_write_rf(rtwdev, RF_PATH_A, 0x64, 0xf, 0xf);
@@ -777,6 +778,15 @@ static void rtw8821c_coex_cfg_ant_switch
 	if (switch_status == coex_dm->cur_switch_status)
 		return;
 
+	if (coex_rfe->wlg_at_btg) {
+		ctrl_type = COEX_SWITCH_CTRL_BY_BBSW;
+
+		if (coex_rfe->ant_switch_polarity)
+			pos_type = COEX_SWITCH_TO_WLA;
+		else
+			pos_type = COEX_SWITCH_TO_WLG_BT;
+	}
+
 	coex_dm->cur_switch_status = switch_status;
 
 	if (coex_rfe->ant_switch_diversity &&
@@ -1502,6 +1512,7 @@ static const struct rtw_intf_phy_para_ta
 static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8821c, 0, 0),
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {


