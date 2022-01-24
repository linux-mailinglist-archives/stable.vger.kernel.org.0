Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42543498A7C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345152AbiAXTEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:04:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbiAXTCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:02:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0912B81215;
        Mon, 24 Jan 2022 19:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0089BC340E5;
        Mon, 24 Jan 2022 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050923;
        bh=peYOOlMTmm+OyUGHt8OuEe9VzQ3EpRYmy3uRyqu9rOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWpuKXSfr/zvOv7+w+e6zyTRDQPMEVsfzK+RfHLOHiiTHnVxwZlkhd4FjTldcGO5C
         6qxpYXJ+sjJSmln4IP6SSTvDYRTuXRRrPgDZ/QakDvBYxGyR2rjcyrRCk+HGpc6iwe
         UkvF6duSfqcrPoVtkj8wrnEsMBW1N/cCwsL9Zb90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 148/157] drm/ttm/nouveau: dont call tt destroy callback on alloc failure.
Date:   Mon, 24 Jan 2022 19:43:58 +0100
Message-Id: <20220124183937.461801402@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit 5de5b6ecf97a021f29403aa272cb4e03318ef586 upstream.

This is confusing, and from my reading of all the drivers only
nouveau got this right.

Just make the API act under driver control of it's own allocation
failing, and don't call destroy, if the page table fails to
create there is nothing to cleanup here.

(I'm willing to believe I've missed something here, so please
review deeply).

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200728041736.20689-1-airlied@gmail.com
[bwh: Backported to 4.14:
 - Drop change in ttm_sg_tt_init()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    9 +++------
 drivers/gpu/drm/ttm/ttm_tt.c            |    2 --
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -105,12 +105,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_d
 	else
 		nvbe->ttm.ttm.func = &nv50_sgdma_backend;
 
-	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page))
-		/*
-		 * A failing ttm_dma_tt_init() will call ttm_tt_destroy()
-		 * and thus our nouveau_sgdma_destroy() hook, so we don't need
-		 * to free nvbe here.
-		 */
+	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page)) {
+		kfree(nvbe);
 		return NULL;
+	}
 	return &nvbe->ttm.ttm;
 }
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -195,7 +195,6 @@ int ttm_tt_init(struct ttm_tt *ttm, stru
 
 	ttm_tt_alloc_page_directory(ttm);
 	if (!ttm->pages) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}
@@ -228,7 +227,6 @@ int ttm_dma_tt_init(struct ttm_dma_tt *t
 	INIT_LIST_HEAD(&ttm_dma->pages_list);
 	ttm_dma_tt_alloc_page_directory(ttm_dma);
 	if (!ttm->pages) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}


