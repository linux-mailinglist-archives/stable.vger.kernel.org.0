Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876653F66F5
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241039AbhHXR3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35803 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240264AbhHXR1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 737EF61B65;
        Tue, 24 Aug 2021 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824706;
        bh=/FBBv4v2oXgBpv36XmecER7xB6IkFHW7SsmoN8s1vh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUll0xQ6nafYb5DMyvCJZ7VLl2P6w8ADpTCKEfbbqvNR32+Y6bX6L4sLz8agfe7Aq
         brFuLTmpyoS6q5G5vlPNkfl3MXMYk596BGgy0NLYMElESI05mtu/O33+KR436u4qvG
         /+bHx2kv1Ax2robqqIKQ/NQbuP5Kqr6z1PTc+pCGQIxOOTSzgVChqe1p8QuR3WxkwA
         8JubXMYAqvYHUEf+7te81RuRl31djt+rkiI/qQp2Z6JAegLEy28jTvHKaToA6Ja93s
         oiQctAinYkJDjfmIufCgOsnYY+uR1Ein3f5hJY1hBQe0cF2R7SFfBKsJyb8XiOy8pl
         lWochN+l+wKnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/64] ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J
Date:   Tue, 24 Aug 2021 13:04:00 -0400
Message-Id: <20210824170457.710623-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1d997b2df477..bcfc32efef07 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -793,7 +793,6 @@ static int cs42l42_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-	case SND_SOC_DAIFMT_LEFT_J:
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2

