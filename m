Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D41371B58
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhECQpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232756AbhECQmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:42:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 426A2613C6;
        Mon,  3 May 2021 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059895;
        bh=+HgmHTOTaMq1E0gDxXCL9uXYquSbuU8ATcw7dyeRPWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/Th7vVD2W6755jh2wLGo0262c7smoK6YAfSwaRUf4EYAF7fiy2T1t5qwHD4F4RtI
         PlVny9bigcHQOFEhddWOiSZGz331e6SmZebFL0OkiSlUTCk4koB7qfg3cKTXCfwUoG
         JQP0Bp7xJq7v6QHE6zbj5/Khb5zSwBothDklI6w4Tk5moWufayVrnKbLvadRil54cU
         Yt+dITOPqeX62aqlRyNElP6qTLCpWLzBDfYmbg1cCIBLgPwOkX3ugRxPZMfxoDal/o
         1THRA6ynHYmiUdzV+YLYN63PI2xglYWAoLZllhHBW+t+zFbgJO4P/lglgl1eA2pUJs
         iKDV5W+vmhJ2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 049/115] drm/amdgpu: Fix memory leak
Date:   Mon,  3 May 2021 12:35:53 -0400
Message-Id: <20210503163700.2852194-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit 79fcd446e7e182c52c2c808c76f8de3eb6714349 ]

drm_gem_object_put() should be paired with drm_gem_object_lookup().

All gem objs are saved in fb->base.obj[]. Need put the old first before
assign a new obj.

Trigger VRAM leak by running command below
$ service gdm restart

Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 48cb33e5b382..f5fa1befa7e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -910,8 +910,9 @@ int amdgpu_display_framebuffer_init(struct drm_device *dev,
 	}
 
 	for (i = 1; i < rfb->base.format->num_planes; ++i) {
+		drm_gem_object_get(rfb->base.obj[0]);
+		drm_gem_object_put(rfb->base.obj[i]);
 		rfb->base.obj[i] = rfb->base.obj[0];
-		drm_gem_object_get(rfb->base.obj[i]);
 	}
 
 	return 0;
@@ -960,6 +961,7 @@ amdgpu_display_user_framebuffer_create(struct drm_device *dev,
 		return ERR_PTR(ret);
 	}
 
+	drm_gem_object_put(obj);
 	return &amdgpu_fb->base;
 }
 
-- 
2.30.2

