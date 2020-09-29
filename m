Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3249F27C7DE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbgI2L5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbgI2Ln0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E37E7206E5;
        Tue, 29 Sep 2020 11:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379805;
        bh=Mvp27jXAUA961Wpq7Px/syL4hfJjcknjgb34/tfBJWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6IAQohGPglp8JFZW7Sr8nbxrRJMaZ9RFzWLEhrYJNUuFpBTAeP8N7LyeoAOJ5lhQ
         +wvpAYZWAC8Z+cUw+kS6BmtoHphNCbpKzP+kJFGPDNeOKufP8QlxZYeTndR+s1KT1w
         cEEuT9tsAHEwzPbs09LKv3AxBgs91F2By01JaZr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 326/388] ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN Converter9 2-in-1
Date:   Tue, 29 Sep 2020 13:00:57 +0200
Message-Id: <20200929110026.247366533@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f7964d1ec486f..6012367f6fe48 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -591,6 +591,16 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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



