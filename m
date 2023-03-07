Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE876AF0AE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjCGSd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjCGSdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:33:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7288B5A93
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:25:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E30B61531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E473C433D2;
        Tue,  7 Mar 2023 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213542;
        bh=DZS9Xw/Ci6jObGSKyCb4y1ddRABFw96DVtdUmxcAVT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxVzhYUF+2dFgKtvhqVZ3j6ysfbUROusoybCE29XAZaW7pQ3T8laBdmR3SpKdWhQO
         4epC3SSWpklNBXb7/IoSptCLejbPNjx7VuGqZ5w6fZJLT5T0RzBhkXyC2M8FD2To+e
         xaVSdakR/j8zRiErT+lxGDkIxz1cD8+9V0gWF2Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qiheng Lin <linqiheng@huawei.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 510/885] media: platform: mtk-mdp3: Fix return value check in mdp_probe()
Date:   Tue,  7 Mar 2023 17:57:24 +0100
Message-Id: <20230307170024.631997488@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiheng Lin <linqiheng@huawei.com>

[ Upstream commit 1963689bed4d500236938d90c91cdd5e63c1eb28 ]

In case of error, the function mtk_mutex_get()
returns ERR_PTR() and never returns NULL. The NULL test in the
return value check should be replaced with IS_ERR().
And also fix the err_free_mutex case.

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
index 2d1f6ae9f0802..97edcd9d1c817 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -207,8 +207,8 @@ static int mdp_probe(struct platform_device *pdev)
 	}
 	for (i = 0; i < MDP_PIPE_MAX; i++) {
 		mdp->mdp_mutex[i] = mtk_mutex_get(&mm_pdev->dev);
-		if (!mdp->mdp_mutex[i]) {
-			ret = -ENODEV;
+		if (IS_ERR(mdp->mdp_mutex[i])) {
+			ret = PTR_ERR(mdp->mdp_mutex[i]);
 			goto err_free_mutex;
 		}
 	}
@@ -289,7 +289,8 @@ static int mdp_probe(struct platform_device *pdev)
 	mdp_comp_destroy(mdp);
 err_free_mutex:
 	for (i = 0; i < MDP_PIPE_MAX; i++)
-		mtk_mutex_put(mdp->mdp_mutex[i]);
+		if (!IS_ERR_OR_NULL(mdp->mdp_mutex[i]))
+			mtk_mutex_put(mdp->mdp_mutex[i]);
 err_destroy_device:
 	kfree(mdp);
 err_return:
-- 
2.39.2



