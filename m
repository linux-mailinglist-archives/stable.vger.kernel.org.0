Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15771D85AE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbgERRwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731043AbgERRwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:52:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6776920674;
        Mon, 18 May 2020 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824368;
        bh=hrN4jo85YX8bUHMiL0SJw51uMtj6bE77uz+J0atkXvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVFy47iunnY9kbIaoz3IAmDO+CQCo8IDznah10rjz0XHK2EQ0c0tM3EFk6MJLo5mK
         u0gjg8MSt9nlUousaDz1wnWJTC+W7Dvh/OSNIadNChUFEQxVnlfGSehWKk/IVVTZp9
         B2vTvQJLVZj78eHxgiD1rfjh/gNHKpL+d2K3zpqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/80] drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()
Date:   Mon, 18 May 2020 19:36:45 +0200
Message-Id: <20200518173455.852883272@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



