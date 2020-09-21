Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E164272851
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgIUOmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbgIUOlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 981E2238D7;
        Mon, 21 Sep 2020 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699279;
        bh=9+NOrGU8dt+Gv3foUibZTqJ3JDxBBjtMeuhCH6zfsVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4xzyWXepY5AAhS62LuQcxknU1HaJMFf8SEpyxCBD1muqjp7NgDLfzueQckTbErlj
         ijSK5JZWnFu1jhHA8dotaDyBXYfLlsWbDEpDYayCIaDuhkgGGWLxXjPWPJ9HzTyB8r
         Nv+t5XMCItBJhOZ+xCPpVCXnqRyoFd7k1C7B/Nbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 3/9] ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN Converter9 2-in-1
Date:   Mon, 21 Sep 2020 10:41:08 -0400
Message-Id: <20200921144114.2135773-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144114.2135773-1-sashal@kernel.org>
References: <20200921144114.2135773-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6a0137101f47301fff2da6ba4b9048383d569909 ]

The MPMAN Converter9 2-in-1 almost fully works with out default settings.
The only problem is that it has only 1 speaker so any sounds only playing
on the right channel get lost.

Add a quirk for this model using the default settings + MONO_SPEAKER.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200901080623.4987-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 0dcd249877c55..ec630127ef2f3 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -588,6 +588,16 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* MPMAN Converter 9, similar hw as the I.T.Works TW891 2-in-1 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MPMAN"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Converter9"),
+		},
+		.driver_data = (void *)(BYTCR_INPUT_DEFAULTS |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		/* MPMAN MPWIN895CL */
 		.matches = {
-- 
2.25.1

