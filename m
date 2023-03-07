Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD76AEF36
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjCGSVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjCGSVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:21:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948C1B32A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:15:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29F6161523
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ED2C433EF;
        Tue,  7 Mar 2023 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212921;
        bh=qgjW1//CgREvjO0RBbh3usvXHix0WlXrBWdxsWuz4Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6RGcoKE42hunzXA4ATwElmqyhpKmHSTF8VzD2eHQj8Sp1beGg97QMsiLDTtU8tpl
         moYE4RqgP0J2EW959JzC72UYcJJx7E9+XBQLvbji6+emCHapd7/BLO9Et0ulUfYZVR
         CJZcmOJ7wRJu+Ysnej1lW38CxHLtvLdVaDiCokVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 310/885] drm/msm: use strscpy instead of strncpy
Date:   Tue,  7 Mar 2023 17:54:04 +0100
Message-Id: <20230307170015.589954463@linuxfoundation.org>
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
index a47e5837c528f..56641408ea742 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -22,7 +22,7 @@ msm_fence_context_alloc(struct drm_device *dev, volatile uint32_t *fenceptr,
 		return ERR_PTR(-ENOMEM);
 
 	fctx->dev = dev;
-	strncpy(fctx->name, name, sizeof(fctx->name));
+	strscpy(fctx->name, name, sizeof(fctx->name));
 	fctx->context = dma_fence_context_alloc(1);
 	fctx->index = index++;
 	fctx->fenceptr = fenceptr;
-- 
2.39.2



