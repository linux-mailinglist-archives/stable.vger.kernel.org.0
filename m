Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424704F3206
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348999AbiDEKt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344454AbiDEJmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:42:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C4FBD8B2;
        Tue,  5 Apr 2022 02:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67B206165C;
        Tue,  5 Apr 2022 09:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDE9C385A0;
        Tue,  5 Apr 2022 09:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150860;
        bh=ADAnpuWgvatAfPDBvpAVYJ5LgziMw3umFs1wbdX/OoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnh1MI8FFwnENUC8SkzYSRCsLOMdC/SnmFzhDA5O/X/jri9H8euGckX6xhdnUYAbF
         Irm+AtigRs5W95sKkQAXQ7zxCRrBymt7OkIUVJqyX3877JDXlyvoPpUh75D7JJUUQV
         H/QpDz43jYMOtWMtguu/utDZiX4emcuNYrg/resQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.das@linux.intel.com>
Subject: [PATCH 5.15 175/913] drm/syncobj: flatten dma_fence_chains on transfer
Date:   Tue,  5 Apr 2022 09:20:37 +0200
Message-Id: <20220405070345.098131815@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 721255b52700b320c4ae2e23d57f7d9ad1db50b9 upstream.

It is illegal to add a dma_fence_chain as timeline point. Flatten out
the fences into a dma_fence_array instead.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Nirmoy Das <nirmoy.das@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220209182600.434803-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_syncobj.c |   61 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -853,12 +853,57 @@ drm_syncobj_fd_to_handle_ioctl(struct dr
 					&args->handle);
 }
 
+
+/*
+ * Try to flatten a dma_fence_chain into a dma_fence_array so that it can be
+ * added as timeline fence to a chain again.
+ */
+static int drm_syncobj_flatten_chain(struct dma_fence **f)
+{
+	struct dma_fence_chain *chain = to_dma_fence_chain(*f);
+	struct dma_fence *tmp, **fences;
+	struct dma_fence_array *array;
+	unsigned int count;
+
+	if (!chain)
+		return 0;
+
+	count = 0;
+	dma_fence_chain_for_each(tmp, &chain->base)
+		++count;
+
+	fences = kmalloc_array(count, sizeof(*fences), GFP_KERNEL);
+	if (!fences)
+		return -ENOMEM;
+
+	count = 0;
+	dma_fence_chain_for_each(tmp, &chain->base)
+		fences[count++] = dma_fence_get(tmp);
+
+	array = dma_fence_array_create(count, fences,
+				       dma_fence_context_alloc(1),
+				       1, false);
+	if (!array)
+		goto free_fences;
+
+	dma_fence_put(*f);
+	*f = &array->base;
+	return 0;
+
+free_fences:
+	while (count--)
+		dma_fence_put(fences[count]);
+
+	kfree(fences);
+	return -ENOMEM;
+}
+
 static int drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
 					    struct drm_syncobj_transfer *args)
 {
 	struct drm_syncobj *timeline_syncobj = NULL;
-	struct dma_fence *fence;
 	struct dma_fence_chain *chain;
+	struct dma_fence *fence;
 	int ret;
 
 	timeline_syncobj = drm_syncobj_find(file_private, args->dst_handle);
@@ -869,16 +914,22 @@ static int drm_syncobj_transfer_to_timel
 				     args->src_point, args->flags,
 				     &fence);
 	if (ret)
-		goto err;
+		goto err_put_timeline;
+
+	ret = drm_syncobj_flatten_chain(&fence);
+	if (ret)
+		goto err_free_fence;
+
 	chain = dma_fence_chain_alloc();
 	if (!chain) {
 		ret = -ENOMEM;
-		goto err1;
+		goto err_free_fence;
 	}
+
 	drm_syncobj_add_point(timeline_syncobj, chain, fence, args->dst_point);
-err1:
+err_free_fence:
 	dma_fence_put(fence);
-err:
+err_put_timeline:
 	drm_syncobj_put(timeline_syncobj);
 
 	return ret;


