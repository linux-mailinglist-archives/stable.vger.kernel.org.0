Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4CD66776B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbjALOmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239823AbjALOmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:42:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7950F3D9D1
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:31:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 134A662038
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DFEC433EF;
        Thu, 12 Jan 2023 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533917;
        bh=OmyZyVBMJZKXXpFr7OQElCvCt4twLTrPwMkKlcFWwos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jX1FQHUSi3GyLzXuFrIg0euOEAeLSWP1aYiNyoPk+yJ91RcPY1187MMgxatOrDGT8
         cfKFx1dqc4+TCnfc9v/8AXzPascJd5K/HdfiRl9upuA3SAVS3FBt7XU5pg5tubMW5w
         gdag5F5SML4ds/4mSy+X0pqkp5dam3fR9b8RdnY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kalle Valo <kvalo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Semyon Verchenko <semverchenko@factor-ts.ru>
Subject: [PATCH 5.10 604/783] wifi: rtlwifi: remove always-true condition pointed out by GCC 12
Date:   Thu, 12 Jan 2023 14:55:20 +0100
Message-Id: <20230112135552.268765333@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit ee3db469dd317e82f57b13aa3bc61be5cb60c2b4 upstream.

The .value is a two-dim array, not a pointer.

struct iqk_matrix_regs {
	bool iqk_done;
        long value[1][IQK_MATRIX_REG_NUM];
};

Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Semyon Verchenko <semverchenko@factor-ts.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2385,10 +2385,7 @@ void rtl92d_phy_reload_iqk_setting(struc
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Just Read IQK Matrix reg for channel:%d....\n",
 				channel);
-			if ((rtlphy->iqk_matrix[indexforchannel].
-			     value[0] != NULL)
-				/*&&(regea4 != 0) */)
-				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
 					rtlphy->iqk_matrix[
 					indexforchannel].value,	0,
 					(rtlphy->iqk_matrix[


