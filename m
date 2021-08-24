Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA94C3F64F6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbhHXRJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234352AbhHXRHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1211C61A02;
        Tue, 24 Aug 2021 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824396;
        bh=KxKT5dg6jfAVKH7PBjCP38BgyrrJrz8xojPAJsd30fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCUO9cuy+vB+JZ1JSourWB2gXzE6rhg/euNympZKNR3L3Y7NZRuGB590u1Fb83mYG
         o3q8w7tk4FYRJH2sVAVAhv5zWTBxLCSZXVF466dwjGDOQfSxmDWxGwZhmPLFNtFVbp
         uuuDAALEuYjl+ks041r2c/lqq1YCbB5UN/YIVr44Y9w0T80ucWArTmrm62Z6znaEJj
         hWDSBohOXdh9xL4mIRhxqOv/OmOH0QW0qyOXLDB863AAPHTlJmJiaw9opODVpT7fcw
         yLYinl+/0IO1AAfNBXNPAa6yn8x0kedNSjSlXNLjFPV4P0K6F453aA7Jc5pP0lsefc
         Xb6vJBE2etv0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/98] drm/mediatek: Add AAL output size configuration
Date:   Tue, 24 Aug 2021 12:58:17 -0400
Message-Id: <20210824165908.709932-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "jason-jh.lin" <jason-jh.lin@mediatek.com>

[ Upstream commit 71ac6f390f6a3017f58d05d677b961bb1f851338 ]

To avoid the output width and height is incorrect,
AAL_OUTPUT_SIZE configuration should be set.

Fixes: 0664d1392c26 ("drm/mediatek: Add AAL engine basic function")
Signed-off-by: jason-jh.lin <jason-jh.lin@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index fe58edcf57b5..e747ff7ba3dc 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -34,6 +34,7 @@
 
 #define DISP_AAL_EN				0x0000
 #define DISP_AAL_SIZE				0x0030
+#define DISP_AAL_OUTPUT_SIZE			0x04d8
 
 #define DISP_CCORR_EN				0x0000
 #define CCORR_EN				BIT(0)
@@ -181,6 +182,7 @@ static void mtk_aal_config(struct mtk_ddp_comp *comp, unsigned int w,
 			   unsigned int bpc, struct cmdq_pkt *cmdq_pkt)
 {
 	mtk_ddp_write(cmdq_pkt, w << 16 | h, comp, DISP_AAL_SIZE);
+	mtk_ddp_write(cmdq_pkt, w << 16 | h, comp, DISP_AAL_OUTPUT_SIZE);
 }
 
 static void mtk_aal_start(struct mtk_ddp_comp *comp)
-- 
2.30.2

