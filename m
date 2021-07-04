Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C273BB38E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhGDXSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233185AbhGDXOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E184F61375;
        Sun,  4 Jul 2021 23:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440181;
        bh=ckir8RldbnMAvlDvA4IMDq+PDg7k94QnMDElRdgMxng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jb17Yx80vH7NhFXdzzw5bpewlYUPgwqZBrHrS3+DFHhxvPGGE8AozqBoXKm6szP5i
         Q5TxE5uFwa6J6VMqTQVaP+T4zqGTHfKGtBi/aRV2qMI0MmijOF66TuoX3a/Bi8tQYN
         7X0BqDlKQJXpxqJk33qJ/Xuw4CNA5w0WWtkq0+7sJx1knyne+2pHasBd/nP/gB/62U
         GrB0zVYChLMmp+WoL8HtuYfeYjpMgkLorYqRC3Fndp3ktis/3aPiW+895Nznw2DNd8
         B2oHStU3X6B/gsIvbQJtpSGbIJqrh+QXIo/UNpSnbQfYaSD92IoZcfY0PBw1Qr5Ad3
         5yK95Ck9yQvdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 02/50] media: mdk-mdp: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:08:50 -0400
Message-Id: <20210704230938.1490742-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit d07bb9702cf5f5ccf3fb661e6cab54bbc33cd23f ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

While here, fix the return contition of mtk_mdp_m2m_start_streaming(),
as it doesn't make any sense to return 0 if the PM runtime failed
to resume.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 7c9e2d69e21a..34bc2949e1d6 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -402,12 +402,12 @@ static int mtk_mdp_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct mtk_mdp_ctx *ctx = q->drv_priv;
 	int ret;
 
-	ret = pm_runtime_get_sync(&ctx->mdp_dev->pdev->dev);
+	ret = pm_runtime_resume_and_get(&ctx->mdp_dev->pdev->dev);
 	if (ret < 0)
-		mtk_mdp_dbg(1, "[%d] pm_runtime_get_sync failed:%d",
+		mtk_mdp_dbg(1, "[%d] pm_runtime_resume_and_get failed:%d",
 			    ctx->id, ret);
 
-	return 0;
+	return ret;
 }
 
 static void *mtk_mdp_m2m_buf_remove(struct mtk_mdp_ctx *ctx,
-- 
2.30.2

