Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0833E101707
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbfKSFqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731076AbfKSFqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:46:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F6562082F;
        Tue, 19 Nov 2019 05:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142379;
        bh=EGOy6xUak/D4P5zc7KNc2Rs4carT6OwSr6QBfTr+Sm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doTdZkVcvasfMbCABV3DRdXFKHVW/ZNMOcPckuL6V6nqHyePctBqKwWvPe8zX1Bkv
         UJt0NlU6NRHYoCQQzWN5pCEkX/paoW+p/wWnSJFCKh5fW2RbL+eLkXF9nYiqSZWDg8
         5OapgJGhSI+mNY5QYPRMoE+OjEj6n1mXN9XHr+hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiada Wang <jiada_wang@mentor.com>,
        Timo Wischer <twischer@de.adit-jv.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 061/239] ASoC: rsnd: ssi: Fix issue in dma data address assignment
Date:   Tue, 19 Nov 2019 06:17:41 +0100
Message-Id: <20191119051310.567501461@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1768a0ae469d0..c68b31483c7be 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -432,6 +432,7 @@ struct rsnd_dai_stream {
 	char name[RSND_DAI_NAME_SIZE];
 	struct snd_pcm_substream *substream;
 	struct rsnd_mod *mod[RSND_MOD_MAX];
+	struct rsnd_mod *dma;
 	struct rsnd_dai *rdai;
 	u32 parent_ssi_status;
 };
diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index 60cc550c5a4ca..cae9ed6a0cdb9 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -66,7 +66,6 @@
 
 struct rsnd_ssi {
 	struct rsnd_mod mod;
-	struct rsnd_mod *dma;
 
 	u32 flags;
 	u32 cr_own;
@@ -868,7 +867,6 @@ static int rsnd_ssi_dma_probe(struct rsnd_mod *mod,
 			      struct rsnd_dai_stream *io,
 			      struct rsnd_priv *priv)
 {
-	struct rsnd_ssi *ssi = rsnd_mod_to_ssi(mod);
 	int ret;
 
 	/*
@@ -883,7 +881,7 @@ static int rsnd_ssi_dma_probe(struct rsnd_mod *mod,
 		return ret;
 
 	/* SSI probe might be called many times in MUX multi path */
-	ret = rsnd_dma_attach(io, mod, &ssi->dma);
+	ret = rsnd_dma_attach(io, mod, &io->dma);
 
 	return ret;
 }
-- 
2.20.1



