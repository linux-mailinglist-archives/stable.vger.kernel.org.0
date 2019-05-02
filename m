Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D622C11D18
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfEBP2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbfEBP2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:28:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4936020B7C;
        Thu,  2 May 2019 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810921;
        bh=PoPu/I84kFCzCWxj8UouCBzrxnj1cCJbzkgCqkMbJBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEy6oo8Gra7qvffo7x4UPegKVfiemGDOBhTOjitD3gkwnrLab7ldckvPriyRD8A/W
         vEYDtQBntIqF+L/CXTEI61ay0v9ZUUsItCsIw2EQtlkSeBSGtEugcx1FZPSRfXpkkq
         sfxRdsV++/1WWmFMnDB2D1RDB+of92+KMbiP9apA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>, Dave Airlie <airlied@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 49/72] drm: Fix drm_release() and device unplug
Date:   Thu,  2 May 2019 17:21:11 +0200
Message-Id: <20190502143337.314286147@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
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
index ea4941da9b27..0201ccb22f4c 100644
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
index ffa8dc35515f..e4ccb52c67ea 100644
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



