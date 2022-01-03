Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D929483389
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiACOiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiACOgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:36:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0A8C08EA6C;
        Mon,  3 Jan 2022 06:33:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D514B80F01;
        Mon,  3 Jan 2022 14:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E26EC36AED;
        Mon,  3 Jan 2022 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220391;
        bh=g1NAKM7k/G7yOn/nZA3a7WgeAuswK0cENcVxGCil6bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddbKL9WHEthJj6K6NlWWaT7muq2HogdDcbfa73tPuwIdrSLmmXy3uCi5lOZzWpo3d
         i1E+dIv2DAvA7psQL/3o1pdoU3y5hhpSqQQI4dXi9e6k4RioMbEMuj6R5mwyrYKbzy
         EliQkt0V7jDPcxsllWZbiVoHVFu4gkSQtnQk9ijo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Stefan Fritsch <sf@sfritsch.de>,
        Dan Moulding <dmoulding@me.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.15 54/73] drm/nouveau: wait for the exclusive fence after the shared ones v2
Date:   Mon,  3 Jan 2022 15:24:15 +0100
Message-Id: <20220103142058.666219405@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 67f74302f45d5d862f22ced3297624e50ac352f0 upstream.

Always waiting for the exclusive fence resulted on some performance
regressions. So try to wait for the shared fences first, then the
exclusive fence should always be signaled already.

v2: fix incorrectly placed "(", add some comment why we do this.

Signed-off-by: Christian König <christian.koenig@amd.com>
Tested-by: Stefan Fritsch <sf@sfritsch.de>
Tested-by: Dan Moulding <dmoulding@me.com>
Acked-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211209102335.18321-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -353,15 +353,22 @@ nouveau_fence_sync(struct nouveau_bo *nv
 
 		if (ret)
 			return ret;
-	}
 
-	fobj = dma_resv_shared_list(resv);
-	fence = dma_resv_excl_fence(resv);
+		fobj = NULL;
+	} else {
+		fobj = dma_resv_shared_list(resv);
+	}
 
-	if (fence) {
+	/* Waiting for the exclusive fence first causes performance regressions
+	 * under some circumstances. So manually wait for the shared ones first.
+	 */
+	for (i = 0; i < (fobj ? fobj->shared_count : 0) && !ret; ++i) {
 		struct nouveau_channel *prev = NULL;
 		bool must_wait = true;
 
+		fence = rcu_dereference_protected(fobj->shared[i],
+						dma_resv_held(resv));
+
 		f = nouveau_local_fence(fence, chan->drm);
 		if (f) {
 			rcu_read_lock();
@@ -373,20 +380,13 @@ nouveau_fence_sync(struct nouveau_bo *nv
 
 		if (must_wait)
 			ret = dma_fence_wait(fence, intr);
-
-		return ret;
 	}
 
-	if (!exclusive || !fobj)
-		return ret;
-
-	for (i = 0; i < fobj->shared_count && !ret; ++i) {
+	fence = dma_resv_excl_fence(resv);
+	if (fence) {
 		struct nouveau_channel *prev = NULL;
 		bool must_wait = true;
 
-		fence = rcu_dereference_protected(fobj->shared[i],
-						dma_resv_held(resv));
-
 		f = nouveau_local_fence(fence, chan->drm);
 		if (f) {
 			rcu_read_lock();
@@ -398,6 +398,8 @@ nouveau_fence_sync(struct nouveau_bo *nv
 
 		if (must_wait)
 			ret = dma_fence_wait(fence, intr);
+
+		return ret;
 	}
 
 	return ret;


