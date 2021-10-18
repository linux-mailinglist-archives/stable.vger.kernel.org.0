Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8FC431D88
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhJRNwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234073AbhJRNu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:50:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55189610A5;
        Mon, 18 Oct 2021 13:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564274;
        bh=y0n7kyhm5j4wVsG7PIJa74jBhKrDlk53l6L4zr9sTKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpHU/ts+P0Md4LoJVwqbveKibvxFSf5Zm+9THXnX2I6/CRjyQ1Krkcmo6hMy20zF7
         yMJaUiYMFTGKBNJ14bSUDr+O5R4oAieTvDzYxyNnnHjNzEBeekoimR50vvEcbRq8yb
         Ft+Q3ktz922Pnea6+jEXHKvCD6A5AXL95eycBR2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.14 027/151] drm/nouveau/fifo: Reinstate the correct engine bit programming
Date:   Mon, 18 Oct 2021 15:23:26 +0200
Message-Id: <20211018132341.570069684@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit d1d94b0129dccd226784633c60b7df90e8a051b5 upstream.

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
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211007214117.231472-1-marex@denx.de
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
@@ -82,7 +82,7 @@ g84_fifo_chan_engine_fini(struct nvkm_fi
 	if (offset < 0)
 		return 0;
 
-	engn = fifo->base.func->engine_id(&fifo->base, engine);
+	engn = fifo->base.func->engine_id(&fifo->base, engine) - 1;
 	save = nvkm_mask(device, 0x002520, 0x0000003f, 1 << engn);
 	nvkm_wr32(device, 0x0032fc, chan->base.inst->addr >> 12);
 	done = nvkm_msec(device, 2000,


