Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18955483595
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiACR26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:28:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59316 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiACR25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:28:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B5C86119A;
        Mon,  3 Jan 2022 17:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A285C36AED;
        Mon,  3 Jan 2022 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230936;
        bh=o5kFP8oQmTF+hd+jHzzz40Ex04sUdxCwM94ZL0yWrWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuAplQGKG8tfugNv8dx6iWBh3+9KaqvMjr4uJWFckrUtSpF4o6kXLS4YYwoiJLRBm
         bLFPaL2uAuES8Uizdg5AVqz6G07cYul2jgowmYN3ZHtV+gNwKnx2XEo6T7rmRx6mFO
         0HlVgcSGnUqBb6Rc7IqQuAvMsJLVvqwMVGcXElBbCc8JTzihZnU+HaUT228RizQeGb
         4UoXOt+39SglQ9DUtd6kmSQLxo2gqhX5y8saI4z29KvYDlIIq6x2nekb9CPMxQp7Dn
         BsCZsi0OPJCMiIAZgJciAX0K11It52GSaYa367qtMMPUEUE1BqvWZKvgHme6lBVuoa
         UjAapbVNgIN8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= 
        <ckoenig.leichtzumerken@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, shashank.sharma@amd.com,
        Ramesh.Errabolu@amd.com, tzimmermann@suse.de, nirmoy.das@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 02/16] drm/amdgpu: fix dropped backing store handling in amdgpu_dma_buf_move_notify
Date:   Mon,  3 Jan 2022 12:28:35 -0500
Message-Id: <20220103172849.1612731-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103172849.1612731-1-sashal@kernel.org>
References: <20220103172849.1612731-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

