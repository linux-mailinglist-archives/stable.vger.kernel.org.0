Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603CB498B7A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346506AbiAXTOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:14:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37860 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344749AbiAXTMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:12:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DBE260B86;
        Mon, 24 Jan 2022 19:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20256C340E5;
        Mon, 24 Jan 2022 19:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051520;
        bh=tKj4Kkf+G5JYmjrwLFve0RgOclpjWKePgs1gs4EF3Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfMi8kDwQ9nO1aP8dPAPofOEZLrHpCt9F1QL0d/r3GkURQo5kFnTqS+kaX3a46VDw
         AuAJUvGqKAlk3jdknvYoX2esB7FbMwQlLOIVhAIfwJ5tVOdPz+fcZwAC6od1RnBcyr
         ZbNmtLfj0DKXNxrJ3ADnW5xpuEiTCSKaB+gaSInc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.14 181/186] drm/ttm/nouveau: dont call tt destroy callback on alloc failure.
Date:   Mon, 24 Jan 2022 19:44:16 +0100
Message-Id: <20220124183942.928229926@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
@@ -106,12 +106,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_d
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
@@ -199,7 +199,6 @@ int ttm_tt_init(struct ttm_tt *ttm, stru
 
 	ttm_tt_alloc_page_directory(ttm);
 	if (!ttm->pages) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}
@@ -232,7 +231,6 @@ int ttm_dma_tt_init(struct ttm_dma_tt *t
 	INIT_LIST_HEAD(&ttm_dma->pages_list);
 	ttm_dma_tt_alloc_page_directory(ttm_dma);
 	if (!ttm->pages) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}


