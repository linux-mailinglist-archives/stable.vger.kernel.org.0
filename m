Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA0A38EFE0
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhEXQAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235840AbhEXP7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECF7F61452;
        Mon, 24 May 2021 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871107;
        bh=X1nSI36gVj+lwwu87lKIKivvc1Xlem4MisVkfCpIYWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGIiuxXVmyRp8DMxzvpMcqwjNrjGi9JJkg2F/L5u66NepZKoX4V8XtABbSJ3Rm3eV
         /w1cOcka7Jl9RTQDfHtZ+I+T+uAmTgi6CDmIikwVef2kdwsEWCPDjLEC2X8mA2SMsV
         NgU0XBxEoOwOSj95mrXKQcmEdNBpVvHHsc7p9fjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Yi Li <liyi@loongson.cn>, Huacai Chen <chenhuacai@loongson.cn>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 077/127] drm/amdgpu: Fix GPU TLB update error when PAGE_SIZE > AMDGPU_PAGE_SIZE
Date:   Mon, 24 May 2021 17:26:34 +0200
Message-Id: <20210524152337.456766387@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Li <liyi@loongson.cn>

commit d53751568359e5b3ffb859b13cbd79dc77a571f1 upstream.

When PAGE_SIZE is larger than AMDGPU_PAGE_SIZE, the number of GPU TLB
entries which need to update in amdgpu_map_buffer() should be multiplied
by AMDGPU_GPU_PAGES_IN_CPU_PAGE (PAGE_SIZE / AMDGPU_PAGE_SIZE).

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Yi Li <liyi@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -267,7 +267,7 @@ static int amdgpu_ttm_map_buffer(struct
 	*addr += offset & ~PAGE_MASK;
 
 	num_dw = ALIGN(adev->mman.buffer_funcs->copy_num_dw, 8);
-	num_bytes = num_pages * 8;
+	num_bytes = num_pages * 8 * AMDGPU_GPU_PAGES_IN_CPU_PAGE;
 
 	r = amdgpu_job_alloc_with_ib(adev, num_dw * 4 + num_bytes,
 				     AMDGPU_IB_POOL_DELAYED, &job);


