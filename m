Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A283CE492
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348613AbhGSPoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346731AbhGSPlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:41:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2114460FDC;
        Mon, 19 Jul 2021 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711674;
        bh=ZKJVrmLYGVPSJrHqQHBq6fK9ClMXludSvV3cqZNaBzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppg2ssB9/j/cSdIjqvK3IAUr/HwZNCyGSzd3PSA+NOkWAeEcLxtDmxqchn+VAxBck
         ffIWe6vT8Afw0JrmZw8/tJFbVHLQvcfKOyApZr67Tl13f8P8vouwvkmhQyA/rJ7ssb
         pT8GTEPkgjxN91vYyGjOWD61BU6H+PFtRHJY34ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 091/292] ASoC: soc-pcm: fix the return value in dpcm_apply_symmetry()
Date:   Mon, 19 Jul 2021 16:52:33 +0200
Message-Id: <20210719144945.501844366@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 14d85ca1e435..4a25a1e39831 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1695,7 +1695,7 @@ static int dpcm_apply_symmetry(struct snd_pcm_substream *fe_substream,
 	struct snd_soc_dpcm *dpcm;
 	struct snd_soc_pcm_runtime *fe = asoc_substream_to_rtd(fe_substream);
 	struct snd_soc_dai *fe_cpu_dai;
-	int err;
+	int err = 0;
 	int i;
 
 	/* apply symmetry for FE */
-- 
2.30.2



