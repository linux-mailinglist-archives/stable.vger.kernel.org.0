Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A1D3A95D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbfFIRDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388328AbfFIRDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:03:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9AD206DF;
        Sun,  9 Jun 2019 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099780;
        bh=7HI6N91vbKXJrX1wN4OS7tsYTq/hOQxF0ZkTbp8oJ14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x161tVJRBTfpEDOCDUs0HOmh43kCEmmqCBqpt/i/RIt19IQYo816+460CO/p4uNUa
         HMypRMkQDH1f5raiDqgpbj5ghV0OfWCSXw5dEevbP97DxJzZtrfvKaC56ZtGmDHYmb
         eSFTHpnRdBX2CmEjUXD0ei06D6Yy2nKf2OSJZflk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Timur Tabi <timur@kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 163/241] ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put
Date:   Sun,  9 Jun 2019 18:41:45 +0200
Message-Id: <20190609164152.477243008@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c705247136a523488eac806bd357c3e5d79a7acd ]

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./sound/soc/fsl/fsl_utils.c:74:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 38, but without a corresponding     object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Timur Tabi <timur@kernel.org>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: Xiubo Li <Xiubo.Lee@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/fsl_utils.c b/sound/soc/fsl/fsl_utils.c
index b9e42b503a377..4f8bdb7650e84 100644
--- a/sound/soc/fsl/fsl_utils.c
+++ b/sound/soc/fsl/fsl_utils.c
@@ -75,6 +75,7 @@ int fsl_asoc_get_dma_channel(struct device_node *ssi_np,
 	iprop = of_get_property(dma_np, "cell-index", NULL);
 	if (!iprop) {
 		of_node_put(dma_np);
+		of_node_put(dma_channel_np);
 		return -EINVAL;
 	}
 	*dma_id = be32_to_cpup(iprop);
-- 
2.20.1



