Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A124702B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390124AbgHQSE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388504AbgHQQJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:09:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0902620760;
        Mon, 17 Aug 2020 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680560;
        bh=0twkCdG4JqCbSm6fsCcGK0oLqz8tjy0hd07lO6A9CZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCB9Dwe+j/YiTnd13xh1JJLwDDOAaleCERS+dD3Gi8Ni+oODx4ZoymWhHfuW+Aazm
         s1Cd/EI777wQqFacNVdvYRRnS8F/mjKhEd4JaOhQ4ZjPvXodNUD1IuXVgiQJJkKRJu
         om9Cb1hnrJ5PfU6v6llYb68asQ7ek1tIA0tYSPyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.4 236/270] drm/ttm/nouveau: dont call tt destroy callback on alloc failure.
Date:   Mon, 17 Aug 2020 17:17:17 +0200
Message-Id: <20200817143807.551078136@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    9 +++------
 drivers/gpu/drm/ttm/ttm_tt.c            |    3 ---
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -96,12 +96,9 @@ nouveau_sgdma_create_ttm(struct ttm_buff
 	else
 		nvbe->ttm.ttm.func = &nv50_sgdma_backend;
 
-	if (ttm_dma_tt_init(&nvbe->ttm, bo, page_flags))
-		/*
-		 * A failing ttm_dma_tt_init() will call ttm_tt_destroy()
-		 * and thus our nouveau_sgdma_destroy() hook, so we don't need
-		 * to free nvbe here.
-		 */
+	if (ttm_dma_tt_init(&nvbe->ttm, bo, page_flags)) {
+		kfree(nvbe);
 		return NULL;
+	}
 	return &nvbe->ttm.ttm;
 }
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -241,7 +241,6 @@ int ttm_tt_init(struct ttm_tt *ttm, stru
 	ttm_tt_init_fields(ttm, bo, page_flags);
 
 	if (ttm_tt_alloc_page_directory(ttm)) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}
@@ -265,7 +264,6 @@ int ttm_dma_tt_init(struct ttm_dma_tt *t
 
 	INIT_LIST_HEAD(&ttm_dma->pages_list);
 	if (ttm_dma_tt_alloc_page_directory(ttm_dma)) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}
@@ -287,7 +285,6 @@ int ttm_sg_tt_init(struct ttm_dma_tt *tt
 	else
 		ret = ttm_dma_tt_alloc_page_directory(ttm_dma);
 	if (ret) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}


