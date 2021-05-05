Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B951374257
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhEEQqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235638AbhEEQoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:44:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF9EC613F1;
        Wed,  5 May 2021 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232522;
        bh=slT+Q2dWhK/Pdvc0JkBxSi4ZYL05dsOo7M1WRdImxtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsJA/i5NsmkLnJHFgMqKNeR/bAVJo3exi4PWsym3X71QcWTpZ8Q9lyqZ7QFaFDehK
         09jx4tUVjRmZxetLNTVhbeys1pBKwkwh+hol6xGb5Lu8y3aX68bMApuBwYfXVBZg37
         wJHxDnhbd8EApr3hHU4tXZPBp4R5GvrxA33fJnXIYAgqGXCKuw6vI/T6XZbn+QOF7Q
         upm10Rzc4nrOcZJaZOCpHaCa/R5bHWWjFNABcPV3qJlqoDgVNn595uMQ5riD54zIIG
         4hrZ1REMxXMPw2HfYAqrY1ljrqwaU/gMXibXsTIqTwcnynalfc9N0fK5cQAaU5gp+x
         NV1XeEH2vJSsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gyeongtaek Lee <gt82.lee@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 048/104] ASoC: soc-compress: lock pcm_mutex to resolve lockdep error
Date:   Wed,  5 May 2021 12:33:17 -0400
Message-Id: <20210505163413.3461611-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gyeongtaek Lee <gt82.lee@samsung.com>

[ Upstream commit 45475bf60cc1d42da229a0aa757180c88bab8d22 ]

If panic_on_warn=1 is added in bootargs and compress offload playback with
DPCM is started, kernel panic would be occurred because rtd->card->pcm_mutex
isn't held in soc_compr_open_fe() and soc_compr_free_fe() and it generates
lockdep warning in the following code.

void snd_soc_runtime_action(struct snd_soc_pcm_runtime *rtd,
			    int stream, int action)
{
	struct snd_soc_dai *dai;
	int i;

	lockdep_assert_held(&rtd->card->pcm_mutex);

To prevent lockdep warning but minimize side effect by adding mutex,
pcm_mutex is held just before snd_soc_runtime_activate() and
snd_soc_runtime_deactivate() and is released right after them.

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Link: https://lore.kernel.org/r/1891546521.01617772502282.JavaMail.epsvc@epcpadp3
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-compress.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 246a5e32e22a..b4810266f5e5 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -153,7 +153,9 @@ static int soc_compr_open_fe(struct snd_compr_stream *cstream)
 	fe->dpcm[stream].state = SND_SOC_DPCM_STATE_OPEN;
 	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
 
+	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
 	snd_soc_runtime_activate(fe, stream);
+	mutex_unlock(&fe->card->pcm_mutex);
 
 	mutex_unlock(&fe->card->mutex);
 
@@ -181,7 +183,9 @@ static int soc_compr_free_fe(struct snd_compr_stream *cstream)
 
 	mutex_lock_nested(&fe->card->mutex, SND_SOC_CARD_CLASS_RUNTIME);
 
+	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
 	snd_soc_runtime_deactivate(fe, stream);
+	mutex_unlock(&fe->card->pcm_mutex);
 
 	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
 
-- 
2.30.2

