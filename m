Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38F5742B5
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiGNEZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbiGNEZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:25:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D702A70A;
        Wed, 13 Jul 2022 21:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39F8DB82335;
        Thu, 14 Jul 2022 04:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A24EC34114;
        Thu, 14 Jul 2022 04:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772598;
        bh=pOS5a7puDGZ/iWqaJdM1223AaUj8iUfebzf3eXEB9Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdGYLRwcAqqMRDoHjVJFYgMXLwDUYH5GCHdg6QWuO+e3q9HoFlU0LKpsTUAxsMyMn
         AcBT5OD0NJlVvWx4SERZCgqDrxAVUTaE3ZcipTR1iCJVWdyG58rFluzrOtnMbNpjEI
         suZw7fcBnNcnPk+LyqJqWGS77Yw/pSlqEq7YRYF7ChvLh78Pbuf2RiyhZPsquLFJK/
         nCoovAihhzPSSO0evWDNoRWE41/CFyGl8WZFSV8mI3wsJsEGrZMWfmoHY53PA/riSJ
         eizqm/TVZDlMNeq1u/FMp8A9tGjVEkAzuOmNBbhCGYaU6ny7hQpZ0f1Ddk6438q/Zc
         HHuS9Gq9cuPcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, james.schulman@cirrus.com,
        david.rhodes@cirrus.com, tanureal@opensource.cirrus.com,
        rf@opensource.cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.18 22/41] ASoC: cs35l41: Add ASP TX3/4 source to register patch
Date:   Thu, 14 Jul 2022 00:22:02 -0400
Message-Id: <20220714042221.281187-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 46b0d050c8c7df6dfb2c376aaa149bf2cfc5ca3e ]

The mixer controls for ASP TX3/4 are set to values that are not included
in their enumeration control. This will cause spurious event
notifications when the controls are first changed, as the register value
changes whilst the actual visible enumeration value does not. Use the
register patch to set them to a known value, zero, which equates to zero
fill, thereby avoiding the spurious notifications.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220623105120.1981154-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41-lib.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs35l41-lib.c b/sound/soc/codecs/cs35l41-lib.c
index 17cf782f39af..538b5c4d3abf 100644
--- a/sound/soc/codecs/cs35l41-lib.c
+++ b/sound/soc/codecs/cs35l41-lib.c
@@ -36,8 +36,8 @@ static const struct reg_default cs35l41_reg[] = {
 	{ CS35L41_DAC_PCM1_SRC,			0x00000008 },
 	{ CS35L41_ASP_TX1_SRC,			0x00000018 },
 	{ CS35L41_ASP_TX2_SRC,			0x00000019 },
-	{ CS35L41_ASP_TX3_SRC,			0x00000020 },
-	{ CS35L41_ASP_TX4_SRC,			0x00000021 },
+	{ CS35L41_ASP_TX3_SRC,			0x00000000 },
+	{ CS35L41_ASP_TX4_SRC,			0x00000000 },
 	{ CS35L41_DSP1_RX1_SRC,			0x00000008 },
 	{ CS35L41_DSP1_RX2_SRC,			0x00000009 },
 	{ CS35L41_DSP1_RX3_SRC,			0x00000018 },
@@ -643,6 +643,8 @@ static const struct reg_sequence cs35l41_reva0_errata_patch[] = {
 	{ CS35L41_DSP1_XM_ACCEL_PL0_PRI, 0x00000000 },
 	{ CS35L41_PWR_CTRL2,		 0x00000000 },
 	{ CS35L41_AMP_GAIN_CTRL,	 0x00000000 },
+	{ CS35L41_ASP_TX3_SRC,		 0x00000000 },
+	{ CS35L41_ASP_TX4_SRC,		 0x00000000 },
 };
 
 static const struct reg_sequence cs35l41_revb0_errata_patch[] = {
@@ -654,6 +656,8 @@ static const struct reg_sequence cs35l41_revb0_errata_patch[] = {
 	{ CS35L41_DSP1_XM_ACCEL_PL0_PRI, 0x00000000 },
 	{ CS35L41_PWR_CTRL2,		 0x00000000 },
 	{ CS35L41_AMP_GAIN_CTRL,	 0x00000000 },
+	{ CS35L41_ASP_TX3_SRC,		 0x00000000 },
+	{ CS35L41_ASP_TX4_SRC,		 0x00000000 },
 };
 
 static const struct reg_sequence cs35l41_revb2_errata_patch[] = {
@@ -665,6 +669,8 @@ static const struct reg_sequence cs35l41_revb2_errata_patch[] = {
 	{ CS35L41_DSP1_XM_ACCEL_PL0_PRI, 0x00000000 },
 	{ CS35L41_PWR_CTRL2,		 0x00000000 },
 	{ CS35L41_AMP_GAIN_CTRL,	 0x00000000 },
+	{ CS35L41_ASP_TX3_SRC,		 0x00000000 },
+	{ CS35L41_ASP_TX4_SRC,		 0x00000000 },
 };
 
 static const struct cs35l41_otp_map_element_t cs35l41_otp_map_map[] = {
-- 
2.35.1

