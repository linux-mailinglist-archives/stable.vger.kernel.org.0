Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720C0333E88
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhCJN0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233430AbhCJNZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C315E65030;
        Wed, 10 Mar 2021 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382734;
        bh=pldkc3PeVu0vad+lRb2KazC6M/zc/VeFmGew+OzjY34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlOAno1zby23VBLPLPgOwkVfbC89mm0j+hpGHvLqsQI73qG/SI4lXMkfqAWFgGHQT
         0jcEbdq62svc7PIMZw7fnSCk3z++rdpD3tZxDnw+d2dQmf89DQIoA9cTFUd93UzTgD
         tjtlAD4/QL5I0xB+TkYCmX8lJx9c65WB0BEIvX6I=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/20] drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register
Date:   Wed, 10 Mar 2021 14:24:57 +0100
Message-Id: <20210310132321.159204059@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.512307035@linuxfoundation.org>
References: <20210310132320.512307035@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 8f03c30cb814213e36032084a01f49a9e604a3e3 ]

The PC_DBG_ECO_CNTL register on the Adreno A5xx family gets
programmed to some different values on a per-model basis.
At least, this is what we intend to do here;

Unfortunately, though, this register is being overwritten with a
static magic number, right after applying the GPU-specific
configuration (including the GPU-specific quirks) and that is
effectively nullifying the efforts.

Let's remove the redundant and wrong write to the PC_DBG_ECO_CNTL
register in order to retain the wanted configuration for the
target GPU.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index f1aaa76cc2e4..92e767f3cc16 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -472,8 +472,6 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	if (adreno_gpu->info->quirks & ADRENO_QUIRK_TWO_PASS_USE_WFI)
 		gpu_rmw(gpu, REG_A5XX_PC_DBG_ECO_CNTL, 0, (1 << 8));
 
-	gpu_write(gpu, REG_A5XX_PC_DBG_ECO_CNTL, 0xc0200100);
-
 	/* Enable USE_RETENTION_FLOPS */
 	gpu_write(gpu, REG_A5XX_CP_CHICKEN_DBG, 0x02000000);
 
-- 
2.30.1



