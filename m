Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACDE541B77
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378626AbiFGVrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382083AbiFGVqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:46:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B88235B11;
        Tue,  7 Jun 2022 12:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B5A0B8220B;
        Tue,  7 Jun 2022 19:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84F1C385A2;
        Tue,  7 Jun 2022 19:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628866;
        bh=4C1h2APh3CwOXJj7ov7hB5hxZUv1g2wu/xSwijirYak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9k6rp69SAxoOwZfc0HyW4I89gxWfFQmo5PQ9/5UcXGgiwBoFEt8Zj+aTLR5CkfWU
         vHEGto887FzEZRfsJRTOsIcrKnFQI2EBAtBzE3g4fhs+XygLE/WxszcJ9f3MP3BYd2
         /QxHXEVD7UCl5tG50pKNxq/t5mRFKIjnC1Ok7fVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 484/879] drm/msm/a6xx: Fix refcount leak in a6xx_gpu_init
Date:   Tue,  7 Jun 2022 19:00:02 +0200
Message-Id: <20220607165016.922249286@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index ccc4fcf7a630..a8f6d73197b1 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1919,6 +1919,7 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	BUG_ON(!node);
 
 	ret = a6xx_gmu_init(a6xx_gpu, node);
+	of_node_put(node);
 	if (ret) {
 		a6xx_destroy(&(a6xx_gpu->base.base));
 		return ERR_PTR(ret);
-- 
2.35.1



