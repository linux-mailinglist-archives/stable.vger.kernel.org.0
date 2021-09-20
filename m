Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E937F4124DA
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381570AbhITSil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379743AbhITSg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A84F863317;
        Mon, 20 Sep 2021 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158968;
        bh=r8FTPvJxXE+wC6Tv736YV3bi0zSs/+qRb6U3teRNAdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOjyNkmzgxqn6j4PcmtNGxiAZI2OA8p5z6shTUhtOLkENN8BSSuQbhJy5oIQToj16
         4pyd3jv2vXDGjCw2IhvNIHYj7c6v8O0BsbDIOMA1EWGmh53x+Zf/ReILhZNAiMnEsT
         UYxaTqxgRlSQRw02za/y+0sxVBEZDuExydPs+T9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 016/168] drm/amdgpu: fix use after free during BO move
Date:   Mon, 20 Sep 2021 18:42:34 +0200
Message-Id: <20210920163922.180392385@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit c92db8d64f9e0313e7ecdc9500db93a5040c9370 upstream.

The memory backing old_mem is already freed at that point, move the
check a bit more up.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: bfa3357ef9ab ("drm/ttm: allocate resource object instead of embedding it v2")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1699
Acked-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -513,6 +513,15 @@ static int amdgpu_bo_move(struct ttm_buf
 		goto out;
 	}
 
+	if (bo->type == ttm_bo_type_device &&
+	    new_mem->mem_type == TTM_PL_VRAM &&
+	    old_mem->mem_type != TTM_PL_VRAM) {
+		/* amdgpu_bo_fault_reserve_notify will re-set this if the CPU
+		 * accesses the BO after it's moved.
+		 */
+		abo->flags &= ~AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
+	}
+
 	if (adev->mman.buffer_funcs_enabled) {
 		if (((old_mem->mem_type == TTM_PL_SYSTEM &&
 		      new_mem->mem_type == TTM_PL_VRAM) ||
@@ -543,15 +552,6 @@ static int amdgpu_bo_move(struct ttm_buf
 			return r;
 	}
 
-	if (bo->type == ttm_bo_type_device &&
-	    new_mem->mem_type == TTM_PL_VRAM &&
-	    old_mem->mem_type != TTM_PL_VRAM) {
-		/* amdgpu_bo_fault_reserve_notify will re-set this if the CPU
-		 * accesses the BO after it's moved.
-		 */
-		abo->flags &= ~AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
-	}
-
 out:
 	/* update statistics */
 	atomic64_add(bo->base.size, &adev->num_bytes_moved);


