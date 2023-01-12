Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D334A66776C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239850AbjALOnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239528AbjALOm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:42:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511C33DBF9
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:32:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAC63B81E69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B0DC433D2;
        Thu, 12 Jan 2023 14:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533920;
        bh=sAMR6M0hVvIb5l5F/K7JFO5SQr4iph0IbX3YF8saXZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuerMVQqaTui26VNywdmpd67DxdcHkf37ssqykx0+GOKwkiz1wa1SpQ5dfdKw5+MH
         +Uzy67fmI0DERYBKa8SAaHJZ72gcRcGP4XfGQp6M0dyfiA2nud4zXgj19hFNa/Ueux
         /21CzLHQuNyHGGXG/WdO0/+5Ydku2KKoKDR/Dr3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>,
        Semyon Verchenko <semverchenko@factor-ts.ru>
Subject: [PATCH 5.10 605/783] wifi: rtlwifi: 8192de: correct checking of IQK reload
Date:   Thu, 12 Jan 2023 14:55:21 +0100
Message-Id: <20230112135552.318554078@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

commit 93fbc1ebd978cf408ef5765e9c1630fce9a8621b upstream.

Since IQK could spend time, we make a cache of IQK result matrix that looks
like iqk_matrix[channel_idx].val[x][y], and we can reload the matrix if we
have made a cache. To determine a cache is made, we check
iqk_matrix[channel_idx].val[0][0].

The initial commit 7274a8c22980 ("rtlwifi: rtl8192de: Merge phy routines")
make a mistake that checks incorrect iqk_matrix[channel_idx].val[0] that
is always true, and this mistake is found by commit ee3db469dd31
("wifi: rtlwifi: remove always-true condition pointed out by GCC 12"), so
I recall the vendor driver to find fix and apply the correctness.

Fixes: 7274a8c22980 ("rtlwifi: rtl8192de: Merge phy routines")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220801113345.42016-1-pkshih@realtek.com
Signed-off-by: Semyon Verchenko <semverchenko@factor-ts.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2385,11 +2385,10 @@ void rtl92d_phy_reload_iqk_setting(struc
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Just Read IQK Matrix reg for channel:%d....\n",
 				channel);
-			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
-					rtlphy->iqk_matrix[
-					indexforchannel].value,	0,
-					(rtlphy->iqk_matrix[
-					indexforchannel].value[0][2] == 0));
+			if (rtlphy->iqk_matrix[indexforchannel].value[0][0] != 0)
+				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+					rtlphy->iqk_matrix[indexforchannel].value, 0,
+					rtlphy->iqk_matrix[indexforchannel].value[0][2] == 0);
 			if (IS_92D_SINGLEPHY(rtlhal->version)) {
 				if ((rtlphy->iqk_matrix[
 					indexforchannel].value[0][4] != 0)


