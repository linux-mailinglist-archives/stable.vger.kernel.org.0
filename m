Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30ABF70F
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfD3LzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731027AbfD3Ltk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F46020449;
        Tue, 30 Apr 2019 11:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624978;
        bh=mtP6FXwC+gbYIeehYgsHw94R8YvjVniVqPG3sgvr41s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrNhbeu119OMEKharebKJe4l+0DlPoZGXIy1Y8dDV9uTs7sUPYYUWpdtbTpJPboeo
         VonxRbGA/FjluuwYuP/OZyjEEtc+QB+gnUtelkWqW229R/EoW+wLeTA4fduGKPhzkL
         2JF43FGx8/f704X4q1BCkmE+8xOk2PGJUyZQfXyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Karol Herbst <kherbst@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.0 43/89] drm/ttm: fix re-init of global structures
Date:   Tue, 30 Apr 2019 13:38:34 +0200
Message-Id: <20190430113611.784740880@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit bd4264112f93045704731850c5e4d85db981cd85 upstream.

When a driver unloads without unloading TTM we don't correctly
clear the global structures leading to errors on re-init.

Next step should probably be to remove the global structures and
kobjs all together, but this is tricky since we need to maintain
backward compatibility.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Tested-by: Karol Herbst <kherbst@redhat.com>
CC: stable@vger.kernel.org # 5.0.x
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo.c     |   10 +++++-----
 drivers/gpu/drm/ttm/ttm_memory.c |    5 +++--
 include/drm/ttm/ttm_bo_driver.h  |    1 -
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -49,9 +49,8 @@ static void ttm_bo_global_kobj_release(s
  * ttm_global_mutex - protecting the global BO state
  */
 DEFINE_MUTEX(ttm_global_mutex);
-struct ttm_bo_global ttm_bo_glob = {
-	.use_count = 0
-};
+unsigned ttm_bo_glob_use_count;
+struct ttm_bo_global ttm_bo_glob;
 
 static struct attribute ttm_bo_count = {
 	.name = "bo_count",
@@ -1535,12 +1534,13 @@ static void ttm_bo_global_release(void)
 	struct ttm_bo_global *glob = &ttm_bo_glob;
 
 	mutex_lock(&ttm_global_mutex);
-	if (--glob->use_count > 0)
+	if (--ttm_bo_glob_use_count > 0)
 		goto out;
 
 	kobject_del(&glob->kobj);
 	kobject_put(&glob->kobj);
 	ttm_mem_global_release(&ttm_mem_glob);
+	memset(glob, 0, sizeof(*glob));
 out:
 	mutex_unlock(&ttm_global_mutex);
 }
@@ -1552,7 +1552,7 @@ static int ttm_bo_global_init(void)
 	unsigned i;
 
 	mutex_lock(&ttm_global_mutex);
-	if (++glob->use_count > 1)
+	if (++ttm_bo_glob_use_count > 1)
 		goto out;
 
 	ret = ttm_mem_global_init(&ttm_mem_glob);
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -461,8 +461,8 @@ out_no_zone:
 
 void ttm_mem_global_release(struct ttm_mem_global *glob)
 {
-	unsigned int i;
 	struct ttm_mem_zone *zone;
+	unsigned int i;
 
 	/* let the page allocator first stop the shrink work. */
 	ttm_page_alloc_fini();
@@ -475,9 +475,10 @@ void ttm_mem_global_release(struct ttm_m
 		zone = glob->zones[i];
 		kobject_del(&zone->kobj);
 		kobject_put(&zone->kobj);
-			}
+	}
 	kobject_del(&glob->kobj);
 	kobject_put(&glob->kobj);
+	memset(glob, 0, sizeof(*glob));
 }
 
 static void ttm_check_swapping(struct ttm_mem_global *glob)
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -411,7 +411,6 @@ extern struct ttm_bo_global {
 	/**
 	 * Protected by ttm_global_mutex.
 	 */
-	unsigned int use_count;
 	struct list_head device_list;
 
 	/**


