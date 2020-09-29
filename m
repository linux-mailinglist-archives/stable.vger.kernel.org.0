Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB627C77B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731256AbgI2LyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731018AbgI2Lqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4544D21941;
        Tue, 29 Sep 2020 11:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379993;
        bh=ddpaCm8p5ORQV5vg1PVb89chVnV7o2HOUgXpkZ1SUy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPm/bgoN+V6L0B30AknUOSGy1wem9Ix/NlMe4IOoraDlDQhJ65FnRh3phtyK5JD+R
         gazo/uzbHHf6psIK/jwjrlybaNFwLcT+dV3XOX973xJxaJArH9i7xF591HpO//W4/o
         RvVITl0ckXnqmVjpgZRo6/rrYxsTIgUSGGtFfyag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 02/99] ASoC: pcm3168a: ignore 0 Hz settings
Date:   Tue, 29 Sep 2020 13:00:45 +0200
Message-Id: <20200929105929.837687886@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



