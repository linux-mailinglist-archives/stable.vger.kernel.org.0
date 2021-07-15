Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4243CA970
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242904AbhGOTGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242786AbhGOTFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D972D613D8;
        Thu, 15 Jul 2021 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375722;
        bh=gM0qQjh02t3B7lTxHS0YCfVSk5RMjCGn9lYfp+b94e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVZ3Cb8Va8l6IvYUSnt8dKJR6ZSwYPOOxGHDUR9MfNM1AhLpWFFn2VHbVbRaTvfpE
         UpVbUCYL08X0jyE5v9URTbW1Auj1WfsCf0TwICU54WXcgH1CzVfBFF+KvDz9Q/ZPUG
         Z72hnBOpGCa67SIHlyv+3kRa1Me/xEHvk7yJ8uKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 166/242] drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()
Date:   Thu, 15 Jul 2021 20:38:48 +0200
Message-Id: <20210715182622.537861911@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

commit 9ba85914c36c8fed9bf3e8b69c0782908c1247b7 upstream.

radeon_user_framebuffer_create() misses to call drm_gem_object_put() in
an error path. Add the missed function call to fix it.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1325,6 +1325,7 @@ radeon_user_framebuffer_create(struct dr
 	/* Handle is imported dma-buf, so cannot be migrated to VRAM for scanout */
 	if (obj->import_attach) {
 		DRM_DEBUG_KMS("Cannot create framebuffer from imported dma_buf\n");
+		drm_gem_object_put(obj);
 		return ERR_PTR(-EINVAL);
 	}
 


