Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB47348FC4
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhCYL3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhCYL1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:27:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C91B61A41;
        Thu, 25 Mar 2021 11:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671623;
        bh=D/TdGHCz0nh2AkteC7zpmLlb/JMwRxAz+qcPmLQohVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzYJgV9zprQ0SO830+46nYbWy+V0RmLqiPB1whOViSnCNNcN5ifIbk1esRcXsDDmb
         x/5AvVlPcCrwDewB+qV6sZTcJhM1MLHZIf5U5pxVGaipJeUy9g/EW9Q5hjTlvlDBmv
         DHogud7OVM71/eFBpri1V4OKSDrMRhmd1BC78Q+NVWNZotCKYNstLG6YZD9WKRSr0B
         C26OSIIAHo10diWmUI6IM2PHhFfEeTefXX/lI8RTwNkL7VVWdHc69VqsAWAIoCUwOB
         eTGT6syhI2DcSqnJWOy6xkDSfUvDq4LOdI/XMSApk3zoQ+DI+VoZcRAwTMSSqod7nt
         XXL43kHVFONBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 09/24] ASoC: es8316: Simplify adc_pga_gain_tlv table
Date:   Thu, 25 Mar 2021 07:26:35 -0400
Message-Id: <20210325112651.1927828-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bb18c678754ce1514100fb4c0bf6113b5af36c48 ]

Most steps in this table are steps of 3dB (300 centi-dB), so we can
simplify the table.

This not only reduces the amount of space it takes inside the kernel,
this also makes alsa-lib's mixer code actually accept the table, where
as before this change alsa-lib saw the "ADC PGA Gain" control as a
control without a dB scale.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210228160441.241110-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index 36eef1fb3d18..b781b28de012 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -63,13 +63,8 @@ static const SNDRV_CTL_TLVD_DECLARE_DB_RANGE(adc_pga_gain_tlv,
 	1, 1, TLV_DB_SCALE_ITEM(0, 0, 0),
 	2, 2, TLV_DB_SCALE_ITEM(250, 0, 0),
 	3, 3, TLV_DB_SCALE_ITEM(450, 0, 0),
-	4, 4, TLV_DB_SCALE_ITEM(700, 0, 0),
-	5, 5, TLV_DB_SCALE_ITEM(1000, 0, 0),
-	6, 6, TLV_DB_SCALE_ITEM(1300, 0, 0),
-	7, 7, TLV_DB_SCALE_ITEM(1600, 0, 0),
-	8, 8, TLV_DB_SCALE_ITEM(1800, 0, 0),
-	9, 9, TLV_DB_SCALE_ITEM(2100, 0, 0),
-	10, 10, TLV_DB_SCALE_ITEM(2400, 0, 0),
+	4, 7, TLV_DB_SCALE_ITEM(700, 300, 0),
+	8, 10, TLV_DB_SCALE_ITEM(1800, 300, 0),
 );
 
 static const SNDRV_CTL_TLVD_DECLARE_DB_RANGE(hpout_vol_tlv,
-- 
2.30.1

