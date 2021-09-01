Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6313FDC21
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344666AbhIAMq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345669AbhIAMoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F36EB610E5;
        Wed,  1 Sep 2021 12:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499944;
        bh=2+owa3xvviWgBFdf1buQiFV/ZaTCSRUbBMwh1p4ZiLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEwRBdpuMwtNBCufmXk0lWEG8lNGmQhTaM8WjB3EAwBkm3mDGJphnmqNDU3L+SQ9M
         kRoMnJlyq7zgfADB6rlqnHrkWMdxk2CAoSw8QWLMbMenaMlvDKENJbJxPCsvraGleC
         ldQVuhrBzv+3wKhlzlc6xUzFC9Qe34xCDCFtqmzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shashank Sharma <Shashank.sharma@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.13 026/113] drm/amdgpu: use the preferred pin domain after the check
Date:   Wed,  1 Sep 2021 14:27:41 +0200
Message-Id: <20210901122302.874591692@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 2a7b9a8437130fd328001f4edfac8eec98dfe298 upstream.

For some reason we run into an use case where a BO is already pinned
into GTT, but should be pinned into VRAM|GTT again.

Handle that case gracefully as well.

Reviewed-by: Shashank Sharma <Shashank.sharma@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -937,11 +937,6 @@ int amdgpu_bo_pin_restricted(struct amdg
 			return -EINVAL;
 	}
 
-	/* This assumes only APU display buffers are pinned with (VRAM|GTT).
-	 * See function amdgpu_display_supported_domains()
-	 */
-	domain = amdgpu_bo_get_preferred_pin_domain(adev, domain);
-
 	if (bo->tbo.pin_count) {
 		uint32_t mem_type = bo->tbo.mem.mem_type;
 		uint32_t mem_flags = bo->tbo.mem.placement;
@@ -966,6 +961,11 @@ int amdgpu_bo_pin_restricted(struct amdg
 		return 0;
 	}
 
+	/* This assumes only APU display buffers are pinned with (VRAM|GTT).
+	 * See function amdgpu_display_supported_domains()
+	 */
+	domain = amdgpu_bo_get_preferred_pin_domain(adev, domain);
+
 	if (bo->tbo.base.import_attach)
 		dma_buf_pin(bo->tbo.base.import_attach);
 


