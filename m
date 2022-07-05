Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA949566D3C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbiGEMVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbiGEMSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758C31CB05;
        Tue,  5 Jul 2022 05:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0E4661988;
        Tue,  5 Jul 2022 12:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093F3C341CE;
        Tue,  5 Jul 2022 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023239;
        bh=H3cHElZmakp099udMmM81wk3z1IGrNHj4eQl9BFqUvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHjAuxZl5uthb0rq/qeVU52VJo4jQ3Zw5+6FvZUG9uzi1lAfjoT5VeVMd0gER47Sn
         OztZcRh30qnJUhqd5W4Hqo2Dx5W8p1ZY685nLVAJLC2sl7rNC4SEEe9+7ro8C+jhDM
         yloAdoryAu59T6um7G/wjU/p6O12/+RBXXSBLxiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 88/98] drm/msm/gem: Fix error return on fence id alloc fail
Date:   Tue,  5 Jul 2022 13:58:46 +0200
Message-Id: <20220705115620.068116635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 08de214138cdea438a0dfcb10d355a6650c6017c ]

This was a typo, we didn't actually want to return zero.

Fixes: a61acbbe9cf8 ("drm/msm: Track "seqno" fences by idr")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/491145/
Link: https://lore.kernel.org/r/20220624184528.4036837-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 7fb7ff043bcd..1f74bab9e231 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -889,7 +889,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 	submit->fence_id = idr_alloc_cyclic(&queue->fence_idr,
 			submit->user_fence, 1, INT_MAX, GFP_KERNEL);
 	if (submit->fence_id < 0) {
-		ret = submit->fence_id = 0;
+		ret = submit->fence_id;
 		submit->fence_id = 0;
 		goto out;
 	}
-- 
2.35.1



