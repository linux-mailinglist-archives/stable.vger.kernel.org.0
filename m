Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29986328F3E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbhCATsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238342AbhCAThT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:37:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9CAF64EE1;
        Mon,  1 Mar 2021 17:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618789;
        bh=oH5Pp1LqGFyLTprX5Ex1z/4ukUshR6UmE3FUtvYo8p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ap48byCf0QQ7nEsIjao26PxjMyLIjzXl663utJfI8JNqoTwd6U5obWq1q1tC40iqN
         EeuLczofb4DlQ2Xmspvgm8GcSv+ksZ0jfkJA4yd8RvbruxmukAvbMoOSO1+R+KsmUf
         yrbbsiRTxqJM1ETcHFrXeP73dCEEQHvWa6HmSfiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongqiang Niu <yongqiang.niu@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/663] drm/mediatek: Fix aal size config
Date:   Mon,  1 Mar 2021 17:07:45 +0100
Message-Id: <20210301161152.529130643@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 71dcadba34203d8dd35152e368720f977e9cdb81 ]

The orginal setting is not correct, fix it to follow hardware data sheet.
If keep this error setting, mt8173/mt8183 display ok
but mt8192 display abnormal.

Fixes: 0664d1392c26 ("drm/mediatek: Add AAL engine basic function")

Signed-off-by: Yongqiang Niu <yongqiang.niu@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index 3064eac1a7507..7fcb717f256c9 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -180,7 +180,9 @@ static void mtk_aal_config(struct mtk_ddp_comp *comp, unsigned int w,
 			   unsigned int h, unsigned int vrefresh,
 			   unsigned int bpc, struct cmdq_pkt *cmdq_pkt)
 {
-	mtk_ddp_write(cmdq_pkt, h << 16 | w, comp, DISP_AAL_SIZE);
+	struct mtk_ddp_comp_dev *priv = dev_get_drvdata(comp->dev);
+
+	mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
 }
 
 static void mtk_aal_start(struct mtk_ddp_comp *comp)
-- 
2.27.0



