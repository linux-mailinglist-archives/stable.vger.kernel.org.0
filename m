Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324C43CA7C8
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241636AbhGOS4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241769AbhGOSzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D222613D0;
        Thu, 15 Jul 2021 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375181;
        bh=gNsi4EIxhYmRpvHNddMeznVhuB3sZHL0WArFcs/Ycwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFwG8utkogu6eshh+jb/UDmkuA80WcCxACNNgmONdC12A+IvSB7WCa3jq6kjvt+um
         3V0xRyvVd+hdqg6uk86FJJhzxYIIYYFbzR9VNXAUN/hq6Caesv1zkHgQaktSeE+C1i
         ubg34OYUQaV3hjHaKQecJdVTtUxoq6VG62qT/l2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 151/215] drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()
Date:   Thu, 15 Jul 2021 20:38:43 +0200
Message-Id: <20210715182626.291774548@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
@@ -1334,6 +1334,7 @@ radeon_user_framebuffer_create(struct dr
 	/* Handle is imported dma-buf, so cannot be migrated to VRAM for scanout */
 	if (obj->import_attach) {
 		DRM_DEBUG_KMS("Cannot create framebuffer from imported dma_buf\n");
+		drm_gem_object_put(obj);
 		return ERR_PTR(-EINVAL);
 	}
 


