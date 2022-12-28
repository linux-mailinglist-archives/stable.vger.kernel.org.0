Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4B4657C85
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbiL1Pdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiL1PdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D52F1648F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E8D6155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943D1C433EF;
        Wed, 28 Dec 2022 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241597;
        bh=jeOSHteDiIvJJeJcSRj4KpxFzP0oa5ghNss+BUgdy1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRfIQywJfvQYxEE1e8NMPqS18uFScW0POnfyz79F1CpfTUFaKcwEyxgAt10YAYR2w
         WRuqCiUoGw/QGDHtg3ZTyrLjxh7zzveKuQSHnV2QPJ2qBvowhekl0YfE3aU1leRy+i
         nnbnWkbJ+QOSCPlTNkXpESFP/J82Mg7F5hEO3kSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0302/1073] wifi: rtw89: use u32_encode_bits() to fill MAC quota value
Date:   Wed, 28 Dec 2022 15:31:30 +0100
Message-Id: <20221228144336.214693724@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 525c06c81d75690a9b795cc62a758838c1a6b6fe ]

Coverity reported shift 16 bits could cause sign extension and might get
an unexpected value. Since the input values are predefined and no this
kind of case, original code is safe so far. But, still changing them to
use u32_encode_bits() will be more clear and prevent mistakes in the
future.

The original message of Coverity is:
  Suspicious implicit sign extension: "max_cfg->cma0_dma" with type "u16"
  (16 bits, unsigned) is promoted in "max_cfg->cma0_dma << 16" to type
  "int" (32 bits, signed), then sign-extended to type "unsigned long"
  (64 bits, unsigned).  If "max_cfg->cma0_dma << 16" is greater than
  0x7FFFFFFF, the upper bits of the result will all be 1."

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527095 ("Integer handling issues")
Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221108013858.10806-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 93124b815825..1afc14531194 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1387,10 +1387,8 @@ static int dle_mix_cfg(struct rtw89_dev *rtwdev, const struct rtw89_dle_mem *cfg
 #define INVALID_QT_WCPU U16_MAX
 #define SET_QUOTA_VAL(_min_x, _max_x, _module, _idx)			\
 	do {								\
-		val = ((_min_x) &					\
-		       B_AX_ ## _module ## _MIN_SIZE_MASK) |		\
-		      (((_max_x) << 16) &				\
-		       B_AX_ ## _module ## _MAX_SIZE_MASK);		\
+		val = u32_encode_bits(_min_x, B_AX_ ## _module ## _MIN_SIZE_MASK) | \
+		      u32_encode_bits(_max_x, B_AX_ ## _module ## _MAX_SIZE_MASK);  \
 		rtw89_write32(rtwdev,					\
 			      R_AX_ ## _module ## _QTA ## _idx ## _CFG,	\
 			      val);					\
-- 
2.35.1



