Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773F5540BAE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351572AbiFGSaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350929AbiFGS2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:28:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6916172C25;
        Tue,  7 Jun 2022 10:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39259B8236C;
        Tue,  7 Jun 2022 17:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD98C3411C;
        Tue,  7 Jun 2022 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624495;
        bh=fYGuqZCcArABE1nPcf5DlAXAP5PelOBFk1BRqZduQ4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEKxFHED+YiClkMO9DoM5TcIT44zruEk0HfcDx6BGEg/kNvECRg/ub7U8ajnSJcAV
         1UK4Lt57uzLG6r7EKg5LD7cK1/S67C6+w0q24FFu8sOuqvPfsapPnYJkPyGDdV9VH+
         m5fTLWmPvtH9WY9S4mxOLD8NTBuEdj+1L/jlyFcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/667] drm/msm/a6xx: Fix refcount leak in a6xx_gpu_init
Date:   Tue,  7 Jun 2022 19:00:11 +0200
Message-Id: <20220607164945.136625459@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c56de483093d7ad0782327f95dda7da97bc4c315 ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.

a6xx_gmu_init() passes the node to of_find_device_by_node()
and of_dma_configure(), of_find_device_by_node() will takes its
reference, of_dma_configure() doesn't need the node after usage.

Add missing of_node_put() to avoid refcount leak.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Link: https://lore.kernel.org/r/20220512121955.56937-1-linmq006@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 9b41e2f82fc2..c0dec5b919d4 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1872,6 +1872,7 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	BUG_ON(!node);
 
 	ret = a6xx_gmu_init(a6xx_gpu, node);
+	of_node_put(node);
 	if (ret) {
 		a6xx_destroy(&(a6xx_gpu->base.base));
 		return ERR_PTR(ret);
-- 
2.35.1



