Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE1EF4AB0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387596AbfKHLjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387583AbfKHLjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DE621D7E;
        Fri,  8 Nov 2019 11:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213171;
        bh=at/HoHkmjnY+BK7GL6shu8EYd2ZI3hl/LZhn9cks92k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNRbBhUpnUPcB9IbXZhzSTIJ9pmsIjivU1W2GcJBoPTq0X32pfD2gn1H+6sNOPwBJ
         5A0+hbg1elJtEL8fOADttiTL9IqgTon1/1r2qz0S9gJyanpDS3yAQiBw2QKjSAv82i
         tZh5hZlx2B0WiVy+90NbFyZ5vJu6+AwfA6RNk1Ig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiada Wang <jiada_wang@mentor.com>,
        Timo Wischer <twischer@de.adit-jv.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 070/205] ASoC: rsnd: ssi: Fix issue in dma data address assignment
Date:   Fri,  8 Nov 2019 06:35:37 -0500
Message-Id: <20191108113752.12502-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiada Wang <jiada_wang@mentor.com>

[ Upstream commit 0e289012b47a2de1f029a6b61c75998e2f159dd9 ]

Same SSI device may be used in different dai links,
by only having one dma struct in rsnd_ssi, after the first
instance's dma config be initilized, the following instances
can no longer configure dma, this causes issue, when their
dma data address are different from the first instance.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Timo Wischer <twischer@de.adit-jv.com>
[Kuninori: tidyup for upstream]
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/rsnd.h | 1 +
 sound/soc/sh/rcar/ssi.c  | 4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sh/rcar/rsnd.h b/sound/soc/sh/rcar/rsnd.h
index 8f7a0abfa751e..f64c7058b258b 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -438,6 +438,7 @@ struct rsnd_dai_stream {
 	char name[RSND_DAI_NAME_SIZE];
 	struct snd_pcm_substream *substream;
 	struct rsnd_mod *mod[RSND_MOD_MAX];
+	struct rsnd_mod *dma;
 	struct rsnd_dai *rdai;
 	struct device *dmac_dev; /* for IPMMU */
 	u32 parent_ssi_status;
diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index 9410e0a9b14b7..33dc8d6ad35b2 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -72,7 +72,6 @@
 
 struct rsnd_ssi {
 	struct rsnd_mod mod;
-	struct rsnd_mod *dma;
 
 	u32 flags;
 	u32 cr_own;
@@ -873,7 +872,6 @@ static int rsnd_ssi_dma_probe(struct rsnd_mod *mod,
 			      struct rsnd_dai_stream *io,
 			      struct rsnd_priv *priv)
 {
-	struct rsnd_ssi *ssi = rsnd_mod_to_ssi(mod);
 	int ret;
 
 	/*
@@ -888,7 +886,7 @@ static int rsnd_ssi_dma_probe(struct rsnd_mod *mod,
 		return ret;
 
 	/* SSI probe might be called many times in MUX multi path */
-	ret = rsnd_dma_attach(io, mod, &ssi->dma);
+	ret = rsnd_dma_attach(io, mod, &io->dma);
 
 	return ret;
 }
-- 
2.20.1

