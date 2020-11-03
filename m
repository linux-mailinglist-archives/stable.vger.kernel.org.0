Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AB12A534A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733133AbgKCU7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733131AbgKCU7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7698C22226;
        Tue,  3 Nov 2020 20:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437176;
        bh=VW88ndNLQDY3Jw6GS6rXn7R8A0D0yNip1vbmQ5W7x4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gymT07bBKNEG62ZpK0pk/YdQl0tmtHa2Ra9fm5xSAKVlh9ERRAVeB3lDALdZ2uso8
         l2SdvahtN+YWIqjqTW8ubQf5uGpqa5eoQ4ui8CLEnrNXLiknVzMutYl0E4Ww8wyh/v
         2+IpURxy0qvFLNScr7bn6W2ChdXOK+Ahlu89tuzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Madhav Chauhan <madhav.chauhan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 179/214] drm/amdgpu: dont map BO in reserved region
Date:   Tue,  3 Nov 2020 21:37:07 +0100
Message-Id: <20201103203307.499486671@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhav Chauhan <madhav.chauhan@amd.com>

commit c4aa8dff6091cc9536aeb255e544b0b4ba29faf4 upstream.

2MB area is reserved at top inside VM.

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Madhav Chauhan <madhav.chauhan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -561,6 +561,7 @@ int amdgpu_gem_va_ioctl(struct drm_devic
 	struct ww_acquire_ctx ticket;
 	struct list_head list, duplicates;
 	uint64_t va_flags;
+	uint64_t vm_size;
 	int r = 0;
 
 	if (args->va_address < AMDGPU_VA_RESERVED_SIZE) {
@@ -581,6 +582,15 @@ int amdgpu_gem_va_ioctl(struct drm_devic
 
 	args->va_address &= AMDGPU_GMC_HOLE_MASK;
 
+	vm_size = adev->vm_manager.max_pfn * AMDGPU_GPU_PAGE_SIZE;
+	vm_size -= AMDGPU_VA_RESERVED_SIZE;
+	if (args->va_address + args->map_size > vm_size) {
+		dev_dbg(&dev->pdev->dev,
+			"va_address 0x%llx is in top reserved area 0x%llx\n",
+			args->va_address + args->map_size, vm_size);
+		return -EINVAL;
+	}
+
 	if ((args->flags & ~valid_flags) && (args->flags & ~prt_flags)) {
 		dev_dbg(&dev->pdev->dev, "invalid flags combination 0x%08X\n",
 			args->flags);


