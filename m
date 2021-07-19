Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325193CE1E2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346154AbhGSP2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239618AbhGSPZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C5D56008E;
        Mon, 19 Jul 2021 16:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710771;
        bh=YScusCExGV176r/kpK860fBFuQetm23YemSEX6cobH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=df6BCi5zzdIw19X9WVUd83x8THbEvBO/YKdI+dOeUB/HkRtbK5psEFlM3cPy7juyM
         LtlE2o5CgmtIRaNMjPsD4d32QKBYSySE2f+zzHU1OFRF/ZDnfcL/9lgeuW+Kd3JqNE
         xIAAs/2OsQOzvI5LrvxQKhUc+qk3CZ4p5uXmdBtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 103/351] ASoC: soc-pcm: fix the return value in dpcm_apply_symmetry()
Date:   Mon, 19 Jul 2021 16:50:49 +0200
Message-Id: <20210719144947.904406317@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit 12ffd726824a2f52486f72338b6fd3244b512959 ]

In case, where the loops are not executed for a reason, the uninitialized
variable 'err' is returned to the caller. Make code fully predictible
and assign zero in the declaration.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Cc: Mark Brown <broonie@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20210614071746.1787072-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 8659089a87a0..46513bb97904 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1700,7 +1700,7 @@ static int dpcm_apply_symmetry(struct snd_pcm_substream *fe_substream,
 	struct snd_soc_dpcm *dpcm;
 	struct snd_soc_pcm_runtime *fe = asoc_substream_to_rtd(fe_substream);
 	struct snd_soc_dai *fe_cpu_dai;
-	int err;
+	int err = 0;
 	int i;
 
 	/* apply symmetry for FE */
-- 
2.30.2



