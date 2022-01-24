Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA6649A971
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322582AbiAYDWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35468 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384986AbiAXUbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:31:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D325EB81249;
        Mon, 24 Jan 2022 20:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B41DC340E5;
        Mon, 24 Jan 2022 20:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056268;
        bh=6EkDRNGlfa2QskW110D63DdZZVgyjLqd5vMfMotBes4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PXLdrYULCgQ6NLSCLaL7hzGj0dSGuSThWgI+WVlFPLhvneshrloqpMIbmtKF6U3N
         ZIKoBhyZd71po4DzcUQLlZbABLGo1VBHxa8FuRfwDWHVNfbDJ9APr0r7lGayr7rgNO
         G2VRB6PnqtrYydktUo9FOPwFvt9lw2rZmeeBReFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trevor Wu <trevor.wu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/846] ASoC: mediatek: mt8195: correct default value
Date:   Mon, 24 Jan 2022 19:39:03 +0100
Message-Id: <20220124184115.669005237@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trevor Wu <trevor.wu@mediatek.com>

[ Upstream commit 30e693ee82d20361f2caacca3b68c79e1a7cb16c ]

mt8195_cg_patch is used to reset the default value of audio cg, so the
register value could be consistent with CCF reference count.
Nevertheless, AUDIO_TOP_CON1[1:0] is used to control an internal mux,
and it's expected to keep the default value 0.

This patch corrects the default value in case an unexpected behavior
happens in the future.

Fixes: 6746cc8582599 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: Trevor Wu <trevor.wu@mediatek.com>
Link: https://lore.kernel.org/r/20211216022424.28470-1-trevor.wu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 6635c3f72eccc..2edb40fe27ccb 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -3028,7 +3028,7 @@ static const struct reg_sequence mt8195_afe_reg_defaults[] = {
 
 static const struct reg_sequence mt8195_cg_patch[] = {
 	{ AUDIO_TOP_CON0, 0xfffffffb },
-	{ AUDIO_TOP_CON1, 0xfffffffa },
+	{ AUDIO_TOP_CON1, 0xfffffff8 },
 };
 
 static int mt8195_afe_init_registers(struct mtk_base_afe *afe)
-- 
2.34.1



