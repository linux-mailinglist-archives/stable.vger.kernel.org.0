Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825B5657CCF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiL1PgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiL1PgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:36:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BDA140D0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F116E61542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E83BC433EF;
        Wed, 28 Dec 2022 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241772;
        bh=NmugsqAz/BMMq5Nu/yM0N88UDr78Cb/RJXIaC5Id5b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXCsSTx0hVCbre1rGcKtoMAkJNjqSfjL8Ceniaka6mClsermqCDsXjBrtq+nyPajP
         LKllfgtN7nsqztJ4dVlYBub/s8mP4u5I2t4l0m/1FEsJPe18LjrsWd42gavb8tnBXF
         lRiZVdn9WIuTLpCWb66F/wxxEtp03zm7C1n8LQUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moudy Ho <moudy.ho@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0287/1146] media: platform: mtk-mdp3: fix error handling in mdp_cmdq_send()
Date:   Wed, 28 Dec 2022 15:30:26 +0100
Message-Id: <20221228144337.935758335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moudy Ho <moudy.ho@mediatek.com>

[ Upstream commit 64e0a0804b1a7a77ee364f44ffa6a8e0e7b157d2 ]

Increase and refine the goto label in mdp_cmdq_send() to avoid
double free and facilitate traceability.
Also, remove redundant work queue event in blocking function
mdp_cmdq_send().

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Signed-off-by: Moudy Ho <moudy.ho@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mediatek/mdp3/mtk-mdp3-cmdq.c    | 47 ++++++++++---------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c
index 86c054600a08..e194dec8050a 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c
@@ -252,10 +252,9 @@ static int mdp_cmdq_pkt_create(struct cmdq_client *client, struct cmdq_pkt *pkt,
 	dma_addr_t dma_addr;
 
 	pkt->va_base = kzalloc(size, GFP_KERNEL);
-	if (!pkt->va_base) {
-		kfree(pkt);
+	if (!pkt->va_base)
 		return -ENOMEM;
-	}
+
 	pkt->buf_size = size;
 	pkt->cl = (void *)client;
 
@@ -368,25 +367,30 @@ int mdp_cmdq_send(struct mdp_dev *mdp, struct mdp_cmdq_param *param)
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
-		goto err_cmdq_data;
+		goto err_cancel_job;
 	}
 
-	if (mdp_cmdq_pkt_create(mdp->cmdq_clt, &cmd->pkt, SZ_16K)) {
-		ret = -ENOMEM;
-		goto err_cmdq_data;
-	}
+	ret = mdp_cmdq_pkt_create(mdp->cmdq_clt, &cmd->pkt, SZ_16K);
+	if (ret)
+		goto err_free_cmd;
 
 	comps = kcalloc(param->config->num_components, sizeof(*comps),
 			GFP_KERNEL);
 	if (!comps) {
 		ret = -ENOMEM;
-		goto err_cmdq_data;
+		goto err_destroy_pkt;
 	}
 
 	path = kzalloc(sizeof(*path), GFP_KERNEL);
 	if (!path) {
 		ret = -ENOMEM;
-		goto err_cmdq_data;
+		goto err_free_comps;
+	}
+
+	ret = mtk_mutex_prepare(mdp->mdp_mutex[MDP_PIPE_RDMA0]);
+	if (ret) {
+		dev_err(dev, "Fail to enable mutex clk\n");
+		goto err_free_path;
 	}
 
 	path->mdp_dev = mdp;
@@ -406,15 +410,13 @@ int mdp_cmdq_send(struct mdp_dev *mdp, struct mdp_cmdq_param *param)
 	ret = mdp_path_ctx_init(mdp, path);
 	if (ret) {
 		dev_err(dev, "mdp_path_ctx_init error\n");
-		goto err_cmdq_data;
+		goto err_free_path;
 	}
 
-	mtk_mutex_prepare(mdp->mdp_mutex[MDP_PIPE_RDMA0]);
-
 	ret = mdp_path_config(mdp, cmd, path);
 	if (ret) {
 		dev_err(dev, "mdp_path_config error\n");
-		goto err_cmdq_data;
+		goto err_free_path;
 	}
 	cmdq_pkt_finalize(&cmd->pkt);
 
@@ -433,7 +435,7 @@ int mdp_cmdq_send(struct mdp_dev *mdp, struct mdp_cmdq_param *param)
 	ret = mdp_comp_clocks_on(&mdp->pdev->dev, cmd->comps, cmd->num_comps);
 	if (ret) {
 		dev_err(dev, "comp %d failed to enable clock!\n", ret);
-		goto err_clock_off;
+		goto err_free_path;
 	}
 
 	dma_sync_single_for_device(mdp->cmdq_clt->chan->mbox->dev,
@@ -450,17 +452,20 @@ int mdp_cmdq_send(struct mdp_dev *mdp, struct mdp_cmdq_param *param)
 	return 0;
 
 err_clock_off:
-	mtk_mutex_unprepare(mdp->mdp_mutex[MDP_PIPE_RDMA0]);
 	mdp_comp_clocks_off(&mdp->pdev->dev, cmd->comps,
 			    cmd->num_comps);
-err_cmdq_data:
+err_free_path:
+	mtk_mutex_unprepare(mdp->mdp_mutex[MDP_PIPE_RDMA0]);
 	kfree(path);
-	atomic_dec(&mdp->job_count);
-	wake_up(&mdp->callback_wq);
-	if (cmd && cmd->pkt.buf_size > 0)
-		mdp_cmdq_pkt_destroy(&cmd->pkt);
+err_free_comps:
 	kfree(comps);
+err_destroy_pkt:
+	mdp_cmdq_pkt_destroy(&cmd->pkt);
+err_free_cmd:
 	kfree(cmd);
+err_cancel_job:
+	atomic_dec(&mdp->job_count);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mdp_cmdq_send);
-- 
2.35.1



