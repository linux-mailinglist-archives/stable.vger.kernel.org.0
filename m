Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A74657CD5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbiL1Pgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbiL1Pgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:36:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D38140E6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F6B3B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67A5C433D2;
        Wed, 28 Dec 2022 15:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241788;
        bh=a+A0/hU1/71tOtzTGsNnSczq7KsazouMZgYqwLVWedI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAxMACaDvJrvffnfJtpTK+4rYcJgofFUKOwSIWT4cfI2jnYM/GmJ+r0199NejZws5
         j5vGpZ5NuS9G+IKeGhYdy+HmDLXcq0eRe5NyeKjl/04wRS9K9g/WQzQkVZA7aejoVh
         T9Y8coW6mlS64BHsteEcemfrOh5x0KULAAc0HYpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moudy Ho <moudy.ho@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0289/1146] media: platform: mtk-mdp3: fix error handling in mdp_probe()
Date:   Wed, 28 Dec 2022 15:30:28 +0100
Message-Id: <20221228144337.989758953@linuxfoundation.org>
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

[ Upstream commit 82b7d4b5d393d6654148e885efca0a3df63806f6 ]

Adjust label "err_return" order to avoid double freeing, and
add two labels for easy traceability.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Signed-off-by: Moudy Ho <moudy.ho@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c  | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
index c413e59d4286..2d1f6ae9f080 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -196,27 +196,27 @@ static int mdp_probe(struct platform_device *pdev)
 	mm_pdev = __get_pdev_by_id(pdev, MDP_INFRA_MMSYS);
 	if (!mm_pdev) {
 		ret = -ENODEV;
-		goto err_return;
+		goto err_destroy_device;
 	}
 	mdp->mdp_mmsys = &mm_pdev->dev;
 
 	mm_pdev = __get_pdev_by_id(pdev, MDP_INFRA_MUTEX);
 	if (WARN_ON(!mm_pdev)) {
 		ret = -ENODEV;
-		goto err_return;
+		goto err_destroy_device;
 	}
 	for (i = 0; i < MDP_PIPE_MAX; i++) {
 		mdp->mdp_mutex[i] = mtk_mutex_get(&mm_pdev->dev);
 		if (!mdp->mdp_mutex[i]) {
 			ret = -ENODEV;
-			goto err_return;
+			goto err_free_mutex;
 		}
 	}
 
 	ret = mdp_comp_config(mdp);
 	if (ret) {
 		dev_err(dev, "Failed to config mdp components\n");
-		goto err_return;
+		goto err_free_mutex;
 	}
 
 	mdp->job_wq = alloc_workqueue(MDP_MODULE_NAME, WQ_FREEZABLE, 0);
@@ -287,11 +287,12 @@ static int mdp_probe(struct platform_device *pdev)
 	destroy_workqueue(mdp->job_wq);
 err_deinit_comp:
 	mdp_comp_destroy(mdp);
-err_return:
+err_free_mutex:
 	for (i = 0; i < MDP_PIPE_MAX; i++)
-		if (mdp)
-			mtk_mutex_put(mdp->mdp_mutex[i]);
+		mtk_mutex_put(mdp->mdp_mutex[i]);
+err_destroy_device:
 	kfree(mdp);
+err_return:
 	dev_dbg(dev, "Errno %d\n", ret);
 	return ret;
 }
-- 
2.35.1



