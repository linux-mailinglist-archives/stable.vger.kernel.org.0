Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD622727F6
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgIUOkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgIUOka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36B82311D;
        Mon, 21 Sep 2020 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699230;
        bh=ddpaCm8p5ORQV5vg1PVb89chVnV7o2HOUgXpkZ1SUy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/xpoinfrUbahm5pVR44/vvDXOLCDsd1jjQlSTUpN1uWYU7nVy3ccV1ZTys9dzCS0
         Yk6GFfYNv9QQidB5vwCS1nnWgaP5NcjOA2NrxVQFOUpZUopmqUayTGaLnvp5iUFoEI
         YJjt0+LfpGK9XaMTnY/vL/wX6tWJN2QvkBYnoUno=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 02/20] ASoC: pcm3168a: ignore 0 Hz settings
Date:   Mon, 21 Sep 2020 10:40:09 -0400
Message-Id: <20200921144027.2135390-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 7ad26d6671db758c959d7e1d100b138a38483612 ]

Some sound card try to set 0 Hz as reset, but it is impossible.
This patch ignores it to avoid error return.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87a6yjy5sy.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index 9711fab296ebc..045c6f8b26bef 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -306,6 +306,13 @@ static int pcm3168a_set_dai_sysclk(struct snd_soc_dai *dai,
 	struct pcm3168a_priv *pcm3168a = snd_soc_component_get_drvdata(dai->component);
 	int ret;
 
+	/*
+	 * Some sound card sets 0 Hz as reset,
+	 * but it is impossible to set. Ignore it here
+	 */
+	if (freq == 0)
+		return 0;
+
 	if (freq > PCM3168A_MAX_SYSCLK)
 		return -EINVAL;
 
-- 
2.25.1

