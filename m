Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7FF425F55
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 23:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242039AbhJGVnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 17:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhJGVnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 17:43:31 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A5EC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 14:41:37 -0700 (PDT)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 81051831B0;
        Thu,  7 Oct 2021 23:41:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1633642894;
        bh=fInwMaWN1j+5AjRLOCJ8WqzjwYwU7a4/Fu/B//8E1nw=;
        h=From:To:Cc:Subject:Date:From;
        b=Z/uylYb/+tFSSLedBMIeUw3rCZ1rMa0hhSA1jLjNFTQTFHv31pFwCXcQXpppx/V9T
         WOXzm3nMqhRPJiDTslzRwKwtYypS5Aw+Lg1FTZ5luYXvgWUw4TGTjyGgftE55Qup2i
         P5ipqybRTME+AhTCDxkW5UVS3/LCtaQ1vtceRJD3Y8COFhLGBkg2MLfw4xbnZ1BDt5
         I4lNftZr8BteE2pMfo+YOlXWPIVtKPhgb57MRZkKAZNNwLu3OjxBlPYCelMjtToa0f
         IUwyL3e4wfXhEmGifrfPxptU8Mlps32Hqu+popG4+FgvVO/zIBhry/ZB9R+1nayMHs
         A7hFUNdLb3olw==
From:   Marek Vasut <marex@denx.de>
To:     dri-devel@lists.freedesktop.org
Cc:     nouveau@lists.freedesktop.org, Marek Vasut <marex@denx.de>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH] drm/nouveau/fifo: Reinstate the correct engine bit programming
Date:   Thu,  7 Oct 2021 23:41:17 +0200
Message-Id: <20211007214117.231472-1-marex@denx.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 64f7c698bea9 ("drm/nouveau/fifo: add engine_id hook") replaced
fifo/chang84.c g84_fifo_chan_engine() call with an indirect call of
fifo/g84.c g84_fifo_engine_id(). The G84_FIFO_ENGN_* values returned
from the later g84_fifo_engine_id() are incremented by 1 compared to
the previous g84_fifo_chan_engine() return values.

This is fine either way for most of the code, except this one line
where an engine bit programmed into the hardware is derived from the
return value. Decrement the return value accordingly, otherwise the
wrong engine bit is programmed into the hardware and that leads to
the following failure:
nouveau 0000:01:00.0: gr: 00000030 [ILLEGAL_MTHD ILLEGAL_CLASS] ch 1 [003fbce000 DRM] subc 3 class 0000 mthd 085c data 00000420

On the following hardware:
lspci -s 01:00.0
01:00.0 VGA compatible controller: NVIDIA Corporation GT216GLM [Quadro FX 880M] (rev a2)
lspci -ns 01:00.0
01:00.0 0300: 10de:0a3c (rev a2)

Fixes: 64f7c698bea9 ("drm/nouveau/fifo: add engine_id hook")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: <stable@vger.kernel.org> # 5.12+
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
---
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
index 353b77d9b3dc..3492c561f2cf 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
@@ -82,7 +82,7 @@ g84_fifo_chan_engine_fini(struct nvkm_fifo_chan *base,
 	if (offset < 0)
 		return 0;
 
-	engn = fifo->base.func->engine_id(&fifo->base, engine);
+	engn = fifo->base.func->engine_id(&fifo->base, engine) - 1;
 	save = nvkm_mask(device, 0x002520, 0x0000003f, 1 << engn);
 	nvkm_wr32(device, 0x0032fc, chan->base.inst->addr >> 12);
 	done = nvkm_msec(device, 2000,
-- 
2.33.0

