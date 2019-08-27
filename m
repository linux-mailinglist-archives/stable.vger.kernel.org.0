Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB2299E13A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbfH0ICV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731940AbfH0ICV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02EB3206BF;
        Tue, 27 Aug 2019 08:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892940;
        bh=dHl6+KoD8OPrNumf8l17wWgVRJhE0CepafrgyhtPWGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRRkp6BYJjex/ujV/cGfmPEbkEw4kDOIjhu4dbq4dq2zWK6OURWH1jJ6O+/45Bznf
         BOCPGYVi4mtawjwdg7hMecbc1izcqYTy3NCjKpJ369EkEkSv7KurFtxRYbclMeH0KZ
         2aVP813qP8z+63Y1w/WKdz+evEcg2q2OKOU2PB1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijendar Mukunda <vijendar.mukunda@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 068/162] ASoC: amd: acp3x: use dma_ops of parent device for acp3x dma driver
Date:   Tue, 27 Aug 2019 09:49:56 +0200
Message-Id: <20190827072740.514603453@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 88639051017fb61a414b636dd0fc490da2b62b64 ]

AMD platform device acp3x_rv_i2s created by parent PCI device
driver. Pass struct device of the parent to
snd_pcm_lib_preallocate_pages() so dma_alloc_coherent() can use
correct dma_ops. Otherwise, it will use default dma_ops which
is nommu_dma_ops on x86_64 even when IOMMU is enabled and
set to non passthrough mode.

Signed-off-by: Vijendar Mukunda <vijendar.mukunda@amd.com>
Link: https://lore.kernel.org/r/1564753899-17124-1-git-send-email-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 9775bda2a4ca3..d8aa6ab3f68bc 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -367,9 +367,11 @@ static snd_pcm_uframes_t acp3x_dma_pointer(struct snd_pcm_substream *substream)
 
 static int acp3x_dma_new(struct snd_soc_pcm_runtime *rtd)
 {
+	struct snd_soc_component *component = snd_soc_rtdcom_lookup(rtd,
+								    DRV_NAME);
+	struct device *parent = component->dev->parent;
 	snd_pcm_lib_preallocate_pages_for_all(rtd->pcm, SNDRV_DMA_TYPE_DEV,
-					      rtd->pcm->card->dev,
-					      MIN_BUFFER, MAX_BUFFER);
+					      parent, MIN_BUFFER, MAX_BUFFER);
 	return 0;
 }
 
-- 
2.20.1



