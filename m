Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4273F64FD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhHXRJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239423AbhHXRHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3060F619F5;
        Tue, 24 Aug 2021 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824395;
        bh=pLs82OelJL9LUH8RveNb15o+L75oXkJrFfpT6ggYLLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TM2Fd2NJF3fxRknH2ij/r98wYtT+6mzWRJBp692sTHmcIEJK0tkJZTlUGgvTUEFTW
         PZ8SXd/Al6yRkvG1JFylDLEr5d1Mw+r3jGpNQDYV4p30Y9yCYhXWdthJoWrD2LjbMU
         NUL0nwyqMf0VOz0ajsOWhPZKK6qBjP6RFimP/O3drYRgnIC0x6RIWxG7pSoyi/kDdU
         6+6P8Lez4YFP73jF/zI98ZntaW15LRH8rxQgAqkJvx6m926RNjO26a3yXJymL9Y85K
         sInTw6uikkC/ukpJ4jzifYb8xEs3xVUaJWGvKpNNQTjIn+C0jGTJP6NcAuCSzM6lON
         f3J/ze66/V5ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Niu <yongqiang.niu@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/98] drm/mediatek: Fix aal size config
Date:   Tue, 24 Aug 2021 12:58:16 -0400
Message-Id: <20210824165908.709932-47-sashal@kernel.org>
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

From: Yongqiang Niu <yongqiang.niu@mediatek.com>

[ Upstream commit 71dcadba34203d8dd35152e368720f977e9cdb81 ]

The orginal setting is not correct, fix it to follow hardware data sheet.
If keep this error setting, mt8173/mt8183 display ok
but mt8192 display abnormal.

Fixes: 0664d1392c26 ("drm/mediatek: Add AAL engine basic function")

Signed-off-by: Yongqiang Niu <yongqiang.niu@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index 3064eac1a750..fe58edcf57b5 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -180,7 +180,7 @@ static void mtk_aal_config(struct mtk_ddp_comp *comp, unsigned int w,
 			   unsigned int h, unsigned int vrefresh,
 			   unsigned int bpc, struct cmdq_pkt *cmdq_pkt)
 {
-	mtk_ddp_write(cmdq_pkt, h << 16 | w, comp, DISP_AAL_SIZE);
+	mtk_ddp_write(cmdq_pkt, w << 16 | h, comp, DISP_AAL_SIZE);
 }
 
 static void mtk_aal_start(struct mtk_ddp_comp *comp)
-- 
2.30.2

