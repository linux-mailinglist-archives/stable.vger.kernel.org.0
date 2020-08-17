Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FEF247139
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390777AbgHQSX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388237AbgHQQDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:03:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B4B020729;
        Mon, 17 Aug 2020 16:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680200;
        bh=+Y1DzkyI+kZ28L22vtpFDz1VUlAl175pQab8vEfGv3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izx/8saaP8dgQtXerBbzc2JA2c2YcjeSz9vCFOW7fGr7Be0iS2YR2qp8+bX0l6NHf
         RxXe9BL3pc7mOesZa7epzw50jy6XLXGJE+rN7wAdg0QLHYlAAm+KJEUp74Stlwvgcx
         9vS+WeYhKzJJv0E407/3DZQjErEyvUAe31zhLVwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/270] drm/gem: Fix a leak in drm_gem_objects_lookup()
Date:   Mon, 17 Aug 2020 17:14:51 +0200
Message-Id: <20200817143800.244798042@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ec0bb482de0ad5e4aba2a4537ea53eaeb77d11a6 ]

If the "handles" allocation or the copy_from_user() fails then we leak
"objs".  It's supposed to be freed in panfrost_job_cleanup().

Fixes: c117aa4d8701 ("drm: Add a drm_gem_objects_lookup helper")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Emil Velikov <emil.l.velikov@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200320132334.GC95012@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 46ad14470d066..1fdc85a71cec4 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -710,6 +710,8 @@ int drm_gem_objects_lookup(struct drm_file *filp, void __user *bo_handles,
 	if (!objs)
 		return -ENOMEM;
 
+	*objs_out = objs;
+
 	handles = kvmalloc_array(count, sizeof(u32), GFP_KERNEL);
 	if (!handles) {
 		ret = -ENOMEM;
@@ -723,8 +725,6 @@ int drm_gem_objects_lookup(struct drm_file *filp, void __user *bo_handles,
 	}
 
 	ret = objects_lookup(filp, handles, count, objs);
-	*objs_out = objs;
-
 out:
 	kvfree(handles);
 	return ret;
-- 
2.25.1



