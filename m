Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231B7490D5A
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241855AbiAQRCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241856AbiAQRBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0EBC061777;
        Mon, 17 Jan 2022 09:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B11CC611CB;
        Mon, 17 Jan 2022 17:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D791C36AEC;
        Mon, 17 Jan 2022 17:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438881;
        bh=ZyzMXIedkgTIw/WfYn0qeV0S+0BFxcF3RefNHmpwwok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnGtADk7veEbbYkMmqqFprSl+5/DRIn8RshZ/+jpjczek8Cxq3gOei4Xr5B4rXfhD
         LwuQEE91QT/pBPwK6fJ36GNfUgw4RdvjvrQikS9jV+jAL2N8+kTxhTS19zY/7uTA3w
         CWpYFlBg6oaVapRzNvuYSyEFRlY0Q6kmxMmwiS24YF6agC2PK4YuNRZu4igUyVSirg
         whC0TQzouuQ9XdkJrewesnts9ddXuCtxPNcJ0DNRKW8f1a+wfl539Oq1jOJHE49RZC
         OdHb4PKVRKDdM5O75sekpxTSspjZFa98cy3SYqFfGJpMDpvcvHYsBCLj94yB4A7qpn
         ddTHT0ibqz0dA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, vsujithkumar.reddy@amd.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 50/52] ASoC: amd: acp: acp-mach: Change default RT1019 amp dev id
Date:   Mon, 17 Jan 2022 11:58:51 -0500
Message-Id: <20220117165853.1470420-50-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>

[ Upstream commit 7112550890d7e415188a3351ec0a140be60f6deb ]

RT1019 components was initially registered with i2c1 and i2c2 but
now changed to i2c0 and i2c1 in most of our AMD platforms. Change
default rt1019 components to 10EC1019:00 and 10EC1019:01 which is
aligned with most of AMD machines.

Any exception to rt1019 device ids in near future board design can
be handled using dmi based quirk for that machine.

Signed-off-by: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>
Link: https://lore.kernel.org/r/20220106150525.396170-1-AjitKumar.Pandey@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-mach-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-mach-common.c b/sound/soc/amd/acp/acp-mach-common.c
index 7785f12aa0065..7386e5bb61b5e 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -268,8 +268,8 @@ static const struct snd_soc_ops acp_card_rt5682s_ops = {
 
 /* Declare RT1019 codec components */
 SND_SOC_DAILINK_DEF(rt1019,
-	DAILINK_COMP_ARRAY(COMP_CODEC("i2c-10EC1019:01", "rt1019-aif"),
-			  COMP_CODEC("i2c-10EC1019:02", "rt1019-aif")));
+	DAILINK_COMP_ARRAY(COMP_CODEC("i2c-10EC1019:00", "rt1019-aif"),
+			  COMP_CODEC("i2c-10EC1019:01", "rt1019-aif")));
 
 static const struct snd_soc_dapm_route rt1019_map_lr[] = {
 	{ "Left Spk", NULL, "Left SPO" },
@@ -278,11 +278,11 @@ static const struct snd_soc_dapm_route rt1019_map_lr[] = {
 
 static struct snd_soc_codec_conf rt1019_conf[] = {
 	{
-		 .dlc = COMP_CODEC_CONF("i2c-10EC1019:01"),
+		 .dlc = COMP_CODEC_CONF("i2c-10EC1019:00"),
 		 .name_prefix = "Left",
 	},
 	{
-		 .dlc = COMP_CODEC_CONF("i2c-10EC1019:02"),
+		 .dlc = COMP_CODEC_CONF("i2c-10EC1019:01"),
 		 .name_prefix = "Right",
 	},
 };
-- 
2.34.1

