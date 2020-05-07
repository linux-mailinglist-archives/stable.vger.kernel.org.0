Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF701C8F3B
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgEGOaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgEGOaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:30:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E563E20B1F;
        Thu,  7 May 2020 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861814;
        bh=hrN4jo85YX8bUHMiL0SJw51uMtj6bE77uz+J0atkXvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSOfqGhRHhJKfKxPcihtvELrR/dcchiOCd5EYoeozLFnxVsAVz+liOydgvnkgLOhD
         0G0MDKtDR9AVegGNIcQEXTwmn/SREX3DUFRcEfIdHRhaJ5U1jcc+9PjQxiE/O9+i7x
         Cut09Jwi/BtiF+g6mpaGjI9LFWUa21V/26SHcOJI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 09/11] drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()
Date:   Thu,  7 May 2020 10:30:01 -0400
Message-Id: <20200507143003.27047-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507143003.27047-1-sashal@kernel.org>
References: <20200507143003.27047-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 5b5703dbafae74adfbe298a56a81694172caf5e6 ]

v2: removed TODO reminder

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: http://patchwork.freedesktop.org/patch/msgid/a4e0ae09-a73c-1c62-04ef-3f990d41bea9@virtuozzo.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_image.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/qxl/qxl_image.c b/drivers/gpu/drm/qxl/qxl_image.c
index 7fbcc35e8ad35..c89c10055641e 100644
--- a/drivers/gpu/drm/qxl/qxl_image.c
+++ b/drivers/gpu/drm/qxl/qxl_image.c
@@ -210,7 +210,8 @@ qxl_image_init_helper(struct qxl_device *qdev,
 		break;
 	default:
 		DRM_ERROR("unsupported image bit depth\n");
-		return -EINVAL; /* TODO: cleanup */
+		qxl_bo_kunmap_atomic_page(qdev, image_bo, ptr);
+		return -EINVAL;
 	}
 	image->u.bitmap.flags = QXL_BITMAP_TOP_DOWN;
 	image->u.bitmap.x = width;
-- 
2.20.1

