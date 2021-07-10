Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6103C2F03
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhGJCaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234317AbhGJC3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B3D461437;
        Sat, 10 Jul 2021 02:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883944;
        bh=3l0hm/n+PZ0Ti6m3rzVF1Hvo6vMMTW5neVE/CU70Buc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+Q+BtW9ZSxXgVZCK6YABOWb6YUwR2rGVS7n6PdVtbxAcocKRdYOxupMWTiKxnnky
         Mz5kIoZnV4DPCifqIsPZbJY9fGCaDh7/tvtLU/PoTBuzlQm7LtcONUZ41/iK9J9VyE
         2+lJPWBheJySEtcVZXyxOU/Md4ObpuXT3SB1kz5+LbVMZ7LzXW9XGfVSS9NFq8xbEq
         r451Y7to8LtLIgdqRHCY/GQQQH1s6NZzCo1WkV6nAuydLp1yMVGifwL8tqnHaKIpPL
         ihHbHwYvxNP5VUw9Nw3Rrtj0NF9gNvCoAKuc8+vtk2l7EahgOta8nacmi4QeztggLT
         3FAcU5XHg0MGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaroslav Kysela <perex@perex.cz>, Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 58/93] ASoC: soc-pcm: fix the return value in dpcm_apply_symmetry()
Date:   Fri,  9 Jul 2021 22:23:52 -0400
Message-Id: <20210710022428.3169839-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 91bf33958159..8b8a9aca2912 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1738,7 +1738,7 @@ static int dpcm_apply_symmetry(struct snd_pcm_substream *fe_substream,
 	struct snd_soc_dpcm *dpcm;
 	struct snd_soc_pcm_runtime *fe = asoc_substream_to_rtd(fe_substream);
 	struct snd_soc_dai *fe_cpu_dai;
-	int err;
+	int err = 0;
 	int i;
 
 	/* apply symmetry for FE */
-- 
2.30.2

