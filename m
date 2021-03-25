Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF550348CAC
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 10:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCYJWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 05:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229782AbhCYJVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 05:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C3BE619A9;
        Thu, 25 Mar 2021 09:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616664109;
        bh=D0imKy8XIPJ0xOR+IuSOqZUSpBAqAcSM1RlnjHkHR0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIo99rJ9GVV3uWV7CwzOozmWo/ruSsoMqZSCjueHvufR4BRNKwk8QPRG3bxQArm72
         KL6qdgR6/CTIQibQD5SwpSSzVumUwNqe/vsmaZOAOBErFkq0MRIap32QDX5qfaRC+S
         6/YNnF+YR1nu5hIHfa5MuaBsWNIppTZjKZG2aJKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.11.10
Date:   Thu, 25 Mar 2021 10:21:38 +0100
Message-Id: <161666403226195@kroah.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <16166640322331@kroah.com>
References: <16166640322331@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 23403c8e0838..824d15c14be0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 11
-SUBLEVEL = 9
+SUBLEVEL = 10
 EXTRAVERSION =
 NAME = 💕 Valentine's Day Edition 💕
 
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index a76eb2c14e8c..22073e77fdf9 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -514,7 +514,7 @@ static void ttm_bo_release(struct kref *kref)
 		 * shrinkers, now that they are queued for
 		 * destruction.
 		 */
-		if (WARN_ON(bo->pin_count)) {
+		if (bo->pin_count) {
 			bo->pin_count = 0;
 			ttm_bo_del_from_lru(bo);
 			ttm_bo_add_mem_to_lru(bo, &bo->mem);
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index b5bef3199196..2564e66e67d7 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -600,7 +600,6 @@ static inline bool ttm_bo_uses_embedded_gem_object(struct ttm_buffer_object *bo)
 static inline void ttm_bo_pin(struct ttm_buffer_object *bo)
 {
 	dma_resv_assert_held(bo->base.resv);
-	WARN_ON_ONCE(!kref_read(&bo->kref));
 	++bo->pin_count;
 }
 
@@ -613,11 +612,8 @@ static inline void ttm_bo_pin(struct ttm_buffer_object *bo)
 static inline void ttm_bo_unpin(struct ttm_buffer_object *bo)
 {
 	dma_resv_assert_held(bo->base.resv);
-	WARN_ON_ONCE(!kref_read(&bo->kref));
-	if (bo->pin_count)
-		--bo->pin_count;
-	else
-		WARN_ON_ONCE(true);
+	WARN_ON_ONCE(!bo->pin_count);
+	--bo->pin_count;
 }
 
 int ttm_mem_evict_first(struct ttm_bo_device *bdev,
