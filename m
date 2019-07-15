Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDCD69622
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388370AbfGOOK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388790AbfGOOJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:09:58 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB0492081C;
        Mon, 15 Jul 2019 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199797;
        bh=27+fkck8RvRlwgSnIlrM1SjnoQ9LSZnfru2P0EIgqow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hc4ZfLNmfKxYVNXNYraI4A/QfmKMMkFYeIiG1qgvs4IKYrvHIJ/mvjbUx/DWiqrT7
         daibrLdqFLc1Dz/jPDc+uROpg+OYUCYjh5YqDk+jqP9hogswLcxv/h2hhnHUrmsMpF
         D2cf7OK2dwSB45eAKtEa0WbETxl1j+X4hzxguIfY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>,
        Suresh Udipi <sudipi@jp.adit-jv.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 108/219] ASoC: rsnd: fixup mod ID calculation in rsnd_ctu_probe_
Date:   Mon, 15 Jul 2019 10:01:49 -0400
Message-Id: <20190715140341.6443-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>

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

