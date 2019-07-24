Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E03973892
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbfGXTay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388426AbfGXTax (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:30:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 341CB20659;
        Wed, 24 Jul 2019 19:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996652;
        bh=RHgChTb5kJ4u726IVWqaoD99WXZwv8fFPgWtTGxTtps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzHfEzu6Au+vD9/fuusPV7kNzMtptI80KSdJJWaCOHZGTwtAE1aY/JnnC7GPzruDg
         M3GzYDNuHdWS5mqBHlJ/Gu71+rjxiDO3e5faH8yWJN5VJvW5LlxPQxSfc8Kl2sUU0W
         3BQdzJfYN6488jhaDnixkxT4xi0zduw6aFDD9kME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>,
        Suresh Udipi <sudipi@jp.adit-jv.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 119/413] ASoC: rsnd: fixup mod ID calculation in rsnd_ctu_probe_
Date:   Wed, 24 Jul 2019 21:16:50 +0200
Message-Id: <20190724191743.774552265@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ac28ec07ae1c5c1e18ed6855eb105a328418da88 ]

commit c16015f36cc1 ("ASoC: rsnd: add .get_id/.get_id_sub")
introduces rsnd_ctu_id which calcualates and gives
the main Device id of the CTU by dividing the id by 4.
rsnd_mod_id uses this interface to get the CTU main
Device id. But this commit forgets to revert the main
Device id calcution previously done in rsnd_ctu_probe_
which also divides the id by 4. This path corrects the
same to get the correct main Device id.

The issue is observered when rsnd_ctu_probe_ is done for CTU1

Fixes: c16015f36cc1 ("ASoC: rsnd: add .get_id/.get_id_sub")

Signed-off-by: Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>
Signed-off-by: Suresh Udipi <sudipi@jp.adit-jv.com>
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/ctu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sh/rcar/ctu.c b/sound/soc/sh/rcar/ctu.c
index 8cb06dab234e..7647b3d4c0ba 100644
--- a/sound/soc/sh/rcar/ctu.c
+++ b/sound/soc/sh/rcar/ctu.c
@@ -108,7 +108,7 @@ static int rsnd_ctu_probe_(struct rsnd_mod *mod,
 			   struct rsnd_dai_stream *io,
 			   struct rsnd_priv *priv)
 {
-	return rsnd_cmd_attach(io, rsnd_mod_id(mod) / 4);
+	return rsnd_cmd_attach(io, rsnd_mod_id(mod));
 }
 
 static void rsnd_ctu_value_init(struct rsnd_dai_stream *io,
-- 
2.20.1



