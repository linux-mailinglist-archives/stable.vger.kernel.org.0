Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D6F11DF0
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfEBPbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728922AbfEBPbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06565216FD;
        Thu,  2 May 2019 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811063;
        bh=mR+u4Caz6YnEub7R/AE3gj73TlqcHvIq8vNBjHJ9mjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x01/xsX/+OG9JY7UQMHWFGNlG7s13uxUe73Uw6nkm4tuQIcEa9uNcDRcy40oRqa5O
         5T9WsdciRuZkrt4CHaqTQ3kc+rRWrX6vdaW8Zyd7gIJPFQRYO2Jeooh0boTTAFlpm0
         nj2oFnIPagWzpQZ6SGgIdUYzvD0myIlac43uo0lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>, Dave Airlie <airlied@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 059/101] drm: Fix drm_release() and device unplug
Date:   Thu,  2 May 2019 17:21:01 +0200
Message-Id: <20190502143343.626814362@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3f04e0a6cfebf48152ac64502346cdc258811f79 ]

If userspace has open fd(s) when drm_dev_unplug() is run, it will result
in drm_dev_unregister() being called twice. First in drm_dev_unplug() and
then later in drm_release() through the call to drm_put_dev().

Since userspace already holds a ref on drm_device through the drm_minor,
it's not necessary to add extra ref counting based on no open file
handles. Instead just drm_dev_put() unconditionally in drm_dev_unplug().

We now have this:
- Userpace holds a ref on drm_device as long as there's open fd(s)
- The driver holds a ref on drm_device as long as it's bound to the
  struct device

When both sides are done with drm_device, it is released.

Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Sean Paul <sean@poorly.run>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190208140103.28919-2-noralf@tronnes.org
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/gpu/drm/drm_drv.c  | 6 +-----
 drivers/gpu/drm/drm_file.c | 6 ++----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 12e5e2be7890..7a59b8b3ed5a 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -381,11 +381,7 @@ void drm_dev_unplug(struct drm_device *dev)
 	synchronize_srcu(&drm_unplug_srcu);
 
 	drm_dev_unregister(dev);
-
-	mutex_lock(&drm_global_mutex);
-	if (dev->open_count == 0)
-		drm_dev_put(dev);
-	mutex_unlock(&drm_global_mutex);
+	drm_dev_put(dev);
 }
 EXPORT_SYMBOL(drm_dev_unplug);
 
diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 46f48f245eb5..3f20f598cd7c 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -479,11 +479,9 @@ int drm_release(struct inode *inode, struct file *filp)
 
 	drm_file_free(file_priv);
 
-	if (!--dev->open_count) {
+	if (!--dev->open_count)
 		drm_lastclose(dev);
-		if (drm_dev_is_unplugged(dev))
-			drm_put_dev(dev);
-	}
+
 	mutex_unlock(&drm_global_mutex);
 
 	drm_minor_release(minor);
-- 
2.19.1



