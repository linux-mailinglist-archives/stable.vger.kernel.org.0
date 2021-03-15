Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F22A33B7C5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhCOOBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231673AbhCON7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01FF164F07;
        Mon, 15 Mar 2021 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816763;
        bh=+6XnFK6k1kgA4CbStrWf4Fa4e0eBbvtL+qYw5ciU/Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NagDYlMUm4j0050NBeN0eXe+fQxQOKeDqyp1mScfC10pFCAEUpRA6GRT5OJdLx3oj
         QBDou6/VKVqkCWPIdB3SFjtFz+YPQRQ1raEH0DXVK1e5qxD6w1fw11fMreaPAVOV5Y
         kLNmsBqcYi7eb4ee5NNuavFC0bB7EgcsueduzEjw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.11 110/306] drm/shmem-helpers: vunmap: Dont put pages for dma-buf
Date:   Mon, 15 Mar 2021 14:52:53 +0100
Message-Id: <20210315135511.364599516@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Noralf Trønnes <noralf@tronnes.org>

commit 64e194e278673bceb68fb2dde7dbc3d812bfceb3 upstream.

dma-buf importing was reworked in commit 7d2cd72a9aa3
("drm/shmem-helpers: Simplify dma-buf importing"). Before that commit
drm_gem_shmem_prime_import_sg_table() did set ->pages_use_count=1 and
drm_gem_shmem_vunmap_locked() could call drm_gem_shmem_put_pages()
unconditionally. Now without the use count set, put pages is called also
on dma-bufs. Fix this by only putting pages if it's not imported.

Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Fixes: 7d2cd72a9aa3 ("drm/shmem-helpers: Simplify dma-buf importing")
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210219122203.51130-1-noralf@tronnes.org
(cherry picked from commit cdea72518a2b38207146e92e1c9e2fac15975679)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -357,13 +357,14 @@ static void drm_gem_shmem_vunmap_locked(
 	if (--shmem->vmap_use_count > 0)
 		return;
 
-	if (obj->import_attach)
+	if (obj->import_attach) {
 		dma_buf_vunmap(obj->import_attach->dmabuf, map);
-	else
+	} else {
 		vunmap(shmem->vaddr);
+		drm_gem_shmem_put_pages(shmem);
+	}
 
 	shmem->vaddr = NULL;
-	drm_gem_shmem_put_pages(shmem);
 }
 
 /*


