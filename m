Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72CB3ED497
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbhHPNES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236538AbhHPNEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67ED56328D;
        Mon, 16 Aug 2021 13:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119023;
        bh=koTVZmFHoGLi8Fg3mRj8AkL3AzW/EPrQUHxF60Fjbic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHQTpzF/rkndjG9td9w5Jx/msJDVrnoWcyONOJ6VmrYsRfFeU65maLm9iFqhRxMku
         vxZ6yNKJoS8kmin59mOzWV1QgJnuJafXyf4g5jQLtquClekLAtzE4+lmvLBY0IQnnP
         RbB4gIhF8dKDeZXTOqFD80JOH38EN7XdCw4xQoQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/62] ASoC: cs42l42: Dont allow SND_SOC_DAIFMT_LEFT_J
Date:   Mon, 16 Aug 2021 15:01:45 +0200
Message-Id: <20210816125428.645902755@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 64324bac750b84ca54711fb7d332132fcdb87293 ]

The driver has no support for left-justified protocol so it should
not have been allowing this to be passed to cs42l42_set_dai_fmt().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20210729170929.6589-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 5c6d288a92ab..978f5df1ff79 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -772,7 +772,6 @@ static int cs42l42_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-	case SND_SOC_DAIFMT_LEFT_J:
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2



