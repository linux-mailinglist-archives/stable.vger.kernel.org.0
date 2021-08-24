Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15A3F63D0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238576AbhHXQ6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235227AbhHXQ5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B182613D3;
        Tue, 24 Aug 2021 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824215;
        bh=N/qaXpFGICmYvToOYJmnhFCg8SmtGv9fGC1zJ+ta6zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8lNyCzLzV2WAExpeenYQiZp3KIWdR4XpvsKz2tZG1kRnhiN8YZDd8msS+fdWY1qf
         qulUZMuljEhWcOkUeBF80g1Tu84oPsYplOpWaM8FAy6+0yGz3ZE+IZcWpBbn6SwIV2
         3TfxT5sYxq9mWYvTiU1RrEKXlt6CqrqYkOqkQ4qnpnI2aVcBoQ8uMEM83Ew5qS/6ae
         MXFb3GJ9cSoVJnOGVSuISTHHbBXuS4u3RauC34HU+BoQwCZfoed/B+0WKm5/U+MZ4P
         qOHkpaJhRY92aVova2rEHKUWTLO8sRKGlvlyjZp11czHeNPP+CyUDBlAsoW/TJVpu1
         IFKpB9KB5zztA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 048/127] drm/mediatek: Add AAL output size configuration
Date:   Tue, 24 Aug 2021 12:54:48 -0400
Message-Id: <20210824165607.709387-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index 75bc00e17fc4..50d20562e612 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -34,6 +34,7 @@
 
 #define DISP_AAL_EN				0x0000
 #define DISP_AAL_SIZE				0x0030
+#define DISP_AAL_OUTPUT_SIZE			0x04d8
 
 #define DISP_DITHER_EN				0x0000
 #define DITHER_EN				BIT(0)
@@ -197,6 +198,7 @@ static void mtk_aal_config(struct device *dev, unsigned int w,
 	struct mtk_ddp_comp_dev *priv = dev_get_drvdata(dev);
 
 	mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
+	mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_OUTPUT_SIZE);
 }
 
 static void mtk_aal_gamma_set(struct device *dev, struct drm_crtc_state *state)
-- 
2.30.2

