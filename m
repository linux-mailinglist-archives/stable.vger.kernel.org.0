Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB6246B08
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgHQPre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730812AbgHQPrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:47:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7322D20855;
        Mon, 17 Aug 2020 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679228;
        bh=Spr9HGWFgTiZN+TRdPU6IyN2JbV7fTSzBYUGFI3Bz3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIJ02E0FwLQfqa+3Z9VMRReB1bktAxyo3mDCxwCpfLaWmMvXBziAu0Z7tp1ZxF7Vi
         2b+8iu9QLyePEyhGIbXfr2x1z+hAkHVqNMjoD0yenfykcMvfPKKXCBVag9XrhTNdvN
         Jwv+8sZn3GFVJ0Tql88KS9t9eq50ztu/EBlWH8HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 122/393] drm/gem: Fix a leak in drm_gem_objects_lookup()
Date:   Mon, 17 Aug 2020 17:12:52 +0200
Message-Id: <20200817143825.527406976@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
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
index 3087aa710e8da..d847540e4f8c3 100644
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



