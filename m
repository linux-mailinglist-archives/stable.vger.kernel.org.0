Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFCF378860
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhEJLVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237056AbhEJLLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E5B61582;
        Mon, 10 May 2021 11:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644802;
        bh=jJoZfNgcmrjq0dzD8/7bLHCGeb9OPT43dG8fjCAdG9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=161JdtvBm4lLS9uxXDznxNqoW8s7drCbkXEC6wOl3B3SjqGr0tMx4AF1KMwGJDtpu
         L/Kf07BTSVeLHVdO8vhs/LMIGZ1GnIKc8iQQ9fn6YxrijGbW6DVyaDxUq7jFL0z9RA
         O38ZSvmgTRoBe0Bq9RvLoYG5Z7EEdYW3KTcI7DEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 195/384] drm/amdgpu: Fix memory leak
Date:   Mon, 10 May 2021 12:19:44 +0200
Message-Id: <20210510102021.305484238@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f753e04fee99..cbe050436c7b 100644
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



