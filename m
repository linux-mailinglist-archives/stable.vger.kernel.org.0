Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD2345A1F0
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhKWLyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:54:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235530AbhKWLyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:54:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01DDD60FED;
        Tue, 23 Nov 2021 11:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637668283;
        bh=pzBE1IpUHlKMUusYVkK0XBk0Cu4aSU+mh//+xUfVFAA=;
        h=Subject:To:Cc:From:Date:From;
        b=AfWOkc6iCgklYwZavPDQDXy1tR5rB21VloJ3MVcpt+qm7gKhU6O+LTOu5DKEVsUom
         R2DpoN9KMuve6LLralvu669OV4PuujM414z+qtwEQh8ZA4AuqNyRoS3r2yj+5un92T
         eWQAcpIrW0fP97jiVB6nRjaGEwQKDIAroUR0oeeI=
Subject: FAILED: patch "[PATCH] drm/nouveau: Add a dedicated mutex for the clients list" failed to apply to 5.4-stable tree
To:     jcline@redhat.com, bskeggs@redhat.com, kherbst@redhat.com,
        lyude@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:51:20 +0100
Message-ID: <163766828021947@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From abae9164a421bc4a41a3769f01ebcd1f9d955e0e Mon Sep 17 00:00:00 2001
From: Jeremy Cline <jcline@redhat.com>
Date: Wed, 25 Nov 2020 15:26:47 -0500
Subject: [PATCH] drm/nouveau: Add a dedicated mutex for the clients list

Rather than protecting the nouveau_drm clients list with the lock within
the "client" nouveau_cli, add a dedicated lock to serialize access to
the list. This is both clearer and necessary to avoid lockdep being
upset with us when we need to iterate through all the clients in the
list and potentially lock their mutex, which is the same class as the
lock protecting the entire list.

Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Jeremy Cline <jcline@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Tested-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201125202648.5220-3-jcline@redhat.com
Link: https://gitlab.freedesktop.org/drm/nouveau/-/merge_requests/14

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 96490cc855cc..4c69ac2a8295 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -562,6 +562,7 @@ nouveau_drm_device_init(struct drm_device *dev)
 		nvkm_dbgopt(nouveau_debug, "DRM");
 
 	INIT_LIST_HEAD(&drm->clients);
+	mutex_init(&drm->clients_lock);
 	spin_lock_init(&drm->tile.lock);
 
 	/* workaround an odd issue on nvc1 by disabling the device's
@@ -659,6 +660,7 @@ nouveau_drm_device_fini(struct drm_device *dev)
 	nouveau_cli_fini(&drm->client);
 	nouveau_cli_fini(&drm->master);
 	nvif_parent_dtor(&drm->parent);
+	mutex_destroy(&drm->clients_lock);
 	kfree(drm);
 }
 
@@ -1090,9 +1092,9 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 
 	fpriv->driver_priv = cli;
 
-	mutex_lock(&drm->client.mutex);
+	mutex_lock(&drm->clients_lock);
 	list_add(&cli->head, &drm->clients);
-	mutex_unlock(&drm->client.mutex);
+	mutex_unlock(&drm->clients_lock);
 
 done:
 	if (ret && cli) {
@@ -1118,9 +1120,9 @@ nouveau_drm_postclose(struct drm_device *dev, struct drm_file *fpriv)
 		nouveau_abi16_fini(cli->abi16);
 	mutex_unlock(&cli->mutex);
 
-	mutex_lock(&drm->client.mutex);
+	mutex_lock(&drm->clients_lock);
 	list_del(&cli->head);
-	mutex_unlock(&drm->client.mutex);
+	mutex_unlock(&drm->clients_lock);
 
 	nouveau_cli_fini(cli);
 	kfree(cli);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index ba65f136cf48..b2a970aa9bf4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -139,6 +139,11 @@ struct nouveau_drm {
 
 	struct list_head clients;
 
+	/**
+	 * @clients_lock: Protects access to the @clients list of &struct nouveau_cli.
+	 */
+	struct mutex clients_lock;
+
 	u8 old_pm_cap;
 
 	struct {

