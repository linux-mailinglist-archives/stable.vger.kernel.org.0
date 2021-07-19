Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE053CDDF1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344947AbhGSPBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344337AbhGSO7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54F7C61006;
        Mon, 19 Jul 2021 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709192;
        bh=Xam+jMLd0dBFZeEiolK6pGq4DYQJvau7l/rKy3u4CVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7wfgbWt/RHvT7TXwai8sUhzk+dG8/rbE/9qfSVZfbz7zBtJN3vTOlLWz0DwQoj24
         vwEoqgoUYwj9K+j0mwcNXkgl0jAUZBG/YBCbo3/4Dl3rtKnkj1KqV4AQpv7vh3IlJ0
         2J9FnP4ltx66PqwAKSKuXvuIGIGbicp69SdNxaF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 286/421] drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()
Date:   Mon, 19 Jul 2021 16:51:37 +0200
Message-Id: <20210719144956.253110837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -1327,6 +1327,7 @@ radeon_user_framebuffer_create(struct dr
 	/* Handle is imported dma-buf, so cannot be migrated to VRAM for scanout */
 	if (obj->import_attach) {
 		DRM_DEBUG_KMS("Cannot create framebuffer from imported dma_buf\n");
+		drm_gem_object_put(obj);
 		return ERR_PTR(-EINVAL);
 	}
 


