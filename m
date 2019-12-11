Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B2E11B03C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731768AbfLKPU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732121AbfLKPU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B6622527;
        Wed, 11 Dec 2019 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077655;
        bh=xjFHwy3tKm92+fBMltwUj/RklLKzz/nTDFtDUYRkT7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KO5zD5EwugBx/Ix0aV2IwJZGkX+tI8GV0hhgBcnLd3VPzo73wur1c8H5qqknQj4K1
         FcW0a9GRrZI4Z6LgXn+GgOLPh+jTLXIqGVzOwzDndXE2ciS8A1Xs+ao3vH35oBXwAT
         6XysL7uxfx8sqnqPD1KFDwQtZWYg80Dd1zGL3y54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nguyen Viet Dung <dung.nguyen.aj@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/243] ASoC: rsnd: tidyup registering method for rsnd_kctrl_new()
Date:   Wed, 11 Dec 2019 16:04:43 +0100
Message-Id: <20191211150347.300543701@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 9c698e8481a15237a5b1db5f8391dd66d59e42a4 ]

Current rsnd dvc.c is using flags to avoid duplicating register for
MIXer case. OTOH, commit e894efef9ac7 ("ASoC: core: add support to card
rebind") allows to rebind sound card without rebinding all drivers.

Because of above patch and dvc.c flags, it can't re-register kctrl if
only sound card was rebinded, because dvc is keeping old flags.
(Of course it will be no problem if rsnd driver also be rebinded,
but it is not purpose of above patch).

This patch checks current card registered kctrl when registering.
In MIXer case, it can avoid duplicate register if card already has same
kctrl. In rebind case, it can re-register kctrl because card registered
kctl had been removed when unbinding.

This patch is updated version of commit b918f1bc7f1ce ("ASoC: rsnd: DVC
kctrl sets once")

Reported-by: Nguyen Viet Dung <dung.nguyen.aj@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Nguyen Viet Dung <dung.nguyen.aj@renesas.com>
Cc: Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/core.c | 12 ++++++++++++
 sound/soc/sh/rcar/dvc.c  |  8 --------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 15a31820df169..99cd52b9ff228 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1344,6 +1344,18 @@ int rsnd_kctrl_new(struct rsnd_mod *mod,
 	};
 	int ret;
 
+	/*
+	 * 1) Avoid duplicate register (ex. MIXer case)
+	 * 2) re-register if card was rebinded
+	 */
+	list_for_each_entry(kctrl, &card->controls, list) {
+		struct rsnd_kctrl_cfg *c = kctrl->private_data;
+
+		if (strcmp(kctrl->id.name, name) == 0 &&
+		    c->mod == mod)
+			return 0;
+	}
+
 	if (size > RSND_MAX_CHANNELS)
 		return -EINVAL;
 
diff --git a/sound/soc/sh/rcar/dvc.c b/sound/soc/sh/rcar/dvc.c
index 2b16e0ce6bc53..024ece46bf685 100644
--- a/sound/soc/sh/rcar/dvc.c
+++ b/sound/soc/sh/rcar/dvc.c
@@ -40,11 +40,8 @@ struct rsnd_dvc {
 	struct rsnd_kctrl_cfg_s ren;	/* Ramp Enable */
 	struct rsnd_kctrl_cfg_s rup;	/* Ramp Rate Up */
 	struct rsnd_kctrl_cfg_s rdown;	/* Ramp Rate Down */
-	u32 flags;
 };
 
-#define KCTRL_INITIALIZED	(1 << 0)
-
 #define rsnd_dvc_get(priv, id) ((struct rsnd_dvc *)(priv->dvc) + id)
 #define rsnd_dvc_nr(priv) ((priv)->dvc_nr)
 
@@ -227,9 +224,6 @@ static int rsnd_dvc_pcm_new(struct rsnd_mod *mod,
 	int channels = rsnd_rdai_channels_get(rdai);
 	int ret;
 
-	if (rsnd_flags_has(dvc, KCTRL_INITIALIZED))
-		return 0;
-
 	/* Volume */
 	ret = rsnd_kctrl_new_m(mod, io, rtd,
 			is_play ?
@@ -285,8 +279,6 @@ static int rsnd_dvc_pcm_new(struct rsnd_mod *mod,
 	if (ret < 0)
 		return ret;
 
-	rsnd_flags_set(dvc, KCTRL_INITIALIZED);
-
 	return 0;
 }
 
-- 
2.20.1



