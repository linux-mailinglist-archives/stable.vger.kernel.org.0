Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA90F4891D5
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbiAJHgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34106 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbiAJHdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3320CB81217;
        Mon, 10 Jan 2022 07:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5FEC36AED;
        Mon, 10 Jan 2022 07:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800029;
        bh=o5kFP8oQmTF+hd+jHzzz40Ex04sUdxCwM94ZL0yWrWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2MtzxQo5IewBVuBZhVHZQTWJhN9HGLt38Rh7trxgkJOPLyeZX46AJDvdYLTE8Kjd
         vRSWkMSFDRo7HWSnvH/R69keXoFEQ4zUGnz55rulqfvNBaLJpqI2jsgGhX8G0SH5ay
         cQyMBfAOKWEchFYbHaqKNxUE7ATMRNdcNhRm5ydw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 54/72] drm/amdgpu: fix dropped backing store handling in amdgpu_dma_buf_move_notify
Date:   Mon, 10 Jan 2022 08:23:31 +0100
Message-Id: <20220110071823.381194092@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <ckoenig.leichtzumerken@gmail.com>

[ Upstream commit fc74881c28d314b10efac016ef49df4ff40b8b97 ]

bo->tbo.resource can now be NULL.

Signed-off-by: Christian König <christian.koenig@amd.com>
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1811
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211210083927.1754-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index ae6ab93c868b8..7444484a12bf8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -384,7 +384,7 @@ amdgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
 	struct amdgpu_vm_bo_base *bo_base;
 	int r;
 
-	if (bo->tbo.resource->mem_type == TTM_PL_SYSTEM)
+	if (!bo->tbo.resource || bo->tbo.resource->mem_type == TTM_PL_SYSTEM)
 		return;
 
 	r = ttm_bo_validate(&bo->tbo, &placement, &ctx);
-- 
2.34.1



