Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7877D3A0337
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhFHTN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236608AbhFHTLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C02E6194D;
        Tue,  8 Jun 2021 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178165;
        bh=3W2Tzm+mG+BA2BmAu51mShZvg8h/D8aUTpgZoZzMNdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfzL7fLGiMpivVRIxoXzCrcbMhGufMGnvdhXJJD2wAVydgDwr/B+Sg4+hpjvumm3e
         l9L2socn6hZqOTqLm9aEXtD2ED2N7EYG1DAsC6dEttG9Ktxu3pe+HUr0X0obPS/cde
         rf+Nr0WPyKZXR7ub2hbLyzf31/SF3CEXdsalpBkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 084/161] amdgpu: fix GEM obj leak in amdgpu_display_user_framebuffer_create
Date:   Tue,  8 Jun 2021 20:26:54 +0200
Message-Id: <20210608175948.278276680@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit e0c16eb4b3610298a74ae5504c7f6939b12be991 ]

This error code-path is missing a drm_gem_object_put call. Other
error code-paths are fine.

Signed-off-by: Simon Ser <contact@emersion.fr>
Fixes: 1769152ac64b ("drm/amdgpu: Fail fb creation from imported dma-bufs. (v2)")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index a2ac44cc2a6d..e80cc2928b58 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -944,6 +944,7 @@ amdgpu_display_user_framebuffer_create(struct drm_device *dev,
 	domains = amdgpu_display_supported_domains(drm_to_adev(dev), bo->flags);
 	if (obj->import_attach && !(domains & AMDGPU_GEM_DOMAIN_GTT)) {
 		drm_dbg_kms(dev, "Cannot create framebuffer from imported dma_buf\n");
+		drm_gem_object_put(obj);
 		return ERR_PTR(-EINVAL);
 	}
 
-- 
2.30.2



