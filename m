Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5609F6B481E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCJO7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjCJO6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:58:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23F06C6BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:53:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B70446196E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7EBC433D2;
        Fri, 10 Mar 2023 14:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459965;
        bh=U4lQkayqNFi2LP5VIpImFVejCjPmdhAP4wDlQtn8OdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kc80xBI561tUZYT5WZ0rY6A4/lrAMk8/DmgClndPLyUJq+QndVNW+pL2rB1eLAXrr
         JAkCpN7p/HlAiE2deIzul1fLoqUCUEVJL09Xm/wfqPFht+iUGBeCoRsi5Stvx99QZa
         JD4Fjhd0ME/KOUz8uepFibAMhNT2gbJsXGLn03O0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/529] drm/msm: use strscpy instead of strncpy
Date:   Fri, 10 Mar 2023 14:35:20 +0100
Message-Id: <20230310133813.133713033@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d7fd8634f48d76aa799ed57beb7d87dab91bde80 ]

Using strncpy can result in non-NULL-terminated destination string. Use
strscpy instead. This fixes following warning:

drivers/gpu/drm/msm/msm_fence.c: In function ‘msm_fence_context_alloc’:
drivers/gpu/drm/msm/msm_fence.c:25:9: warning: ‘strncpy’ specified bound 32 equals destination size [-Wstringop-truncation]
   25 |         strncpy(fctx->name, name, sizeof(fctx->name));
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: f97decac5f4c ("drm/msm: Support multiple ringbuffers")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/518787/
Link: https://lore.kernel.org/r/20230118020152.1689213-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_fence.c b/drivers/gpu/drm/msm/msm_fence.c
index cd59a59180385..50a25c119f4d9 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -20,7 +20,7 @@ msm_fence_context_alloc(struct drm_device *dev, const char *name)
 		return ERR_PTR(-ENOMEM);
 
 	fctx->dev = dev;
-	strncpy(fctx->name, name, sizeof(fctx->name));
+	strscpy(fctx->name, name, sizeof(fctx->name));
 	fctx->context = dma_fence_context_alloc(1);
 	init_waitqueue_head(&fctx->event);
 	spin_lock_init(&fctx->spinlock);
-- 
2.39.2



