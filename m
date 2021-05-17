Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2644D383136
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhEQOf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238075AbhEQOcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 369E961883;
        Mon, 17 May 2021 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260961;
        bh=G9rh/wjGe8KAlphEFiZxuD9BxwFSJwNa4pW7dZ3LJUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNIjXZK/h+iEEt2p0n1shKnGF1TbqjO5wzHT4Bz3SAAaRL40vyTkP/yefvuDL3k8g
         jeN0wgIb+srKA8+I5ahcPc3HLhpdeifGnQFq8bRQyZLup0HWkzuw7QKgVSxLMg85YU
         aS/HXzFc/1MG6fFeiyTByhavHFI5M/SJArP2T6L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 043/329] ASoC: Intel: bytcr_rt5640: Add quirk for the Chuwi Hi8 tablet
Date:   Mon, 17 May 2021 15:59:14 +0200
Message-Id: <20210517140303.496807559@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 875c40eadf6ac6644c0f71842a4f30dd9968d281 ]

The Chuwi Hi8 tablet is using an analog mic on IN1 and has its
jack-detect connected to JD2_IN4N, instead of using the default
IN3 for its internal mic and JD1_IN4P for jack-detect.

It also only has 1 speaker.

Add a quirk applying the correct settings for this configuration.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210325221054.22714-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 07730ed7ab3c..d45f43290653 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -514,6 +514,23 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{
+		/* Chuwi Hi8 (CWI509) */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
+			DMI_MATCH(DMI_BOARD_NAME, "BYT-PA03C"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ilife"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S806"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Circuitco"),
-- 
2.30.2



