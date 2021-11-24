Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1CB45C63B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354182AbhKXOGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356450AbhKXOEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8822761A87;
        Wed, 24 Nov 2021 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759456;
        bh=oS4edWdXp1gdVcDBhBpx1dKDR/tL7ClzvzR0u+Kya0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMQd14bG2eVIE4svlUAdkXqW1l/3KnlWlprmbJFhHOlsruYxjkhRBCNq2ALNgiVBl
         I/HvShZBQNc1QiWr3NLLhJAr+0BvzQldarVZyHsbyYz68sgJ9gjtzq75XkIS/QASs+
         iVb/3EnEvCDeyfYp7uhDVXHafEi7C/PjJDIdJfd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.15 248/279] drm/nouveau: Add a dedicated mutex for the clients list
Date:   Wed, 24 Nov 2021 12:58:55 +0100
Message-Id: <20211124115727.292541387@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Cline <jcline@redhat.com>

commit abae9164a421bc4a41a3769f01ebcd1f9d955e0e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c |   10 ++++++----
 drivers/gpu/drm/nouveau/nouveau_drv.h |    5 +++++
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -562,6 +562,7 @@ nouveau_drm_device_init(struct drm_devic
 		nvkm_dbgopt(nouveau_debug, "DRM");
 
 	INIT_LIST_HEAD(&drm->clients);
+	mutex_init(&drm->clients_lock);
 	spin_lock_init(&drm->tile.lock);
 
 	/* workaround an odd issue on nvc1 by disabling the device's
@@ -659,6 +660,7 @@ nouveau_drm_device_fini(struct drm_devic
 	nouveau_cli_fini(&drm->client);
 	nouveau_cli_fini(&drm->master);
 	nvif_parent_dtor(&drm->parent);
+	mutex_destroy(&drm->clients_lock);
 	kfree(drm);
 }
 
@@ -1090,9 +1092,9 @@ nouveau_drm_open(struct drm_device *dev,
 
 	fpriv->driver_priv = cli;
 
-	mutex_lock(&drm->client.mutex);
+	mutex_lock(&drm->clients_lock);
 	list_add(&cli->head, &drm->clients);
-	mutex_unlock(&drm->client.mutex);
+	mutex_unlock(&drm->clients_lock);
 
 done:
 	if (ret && cli) {
@@ -1118,9 +1120,9 @@ nouveau_drm_postclose(struct drm_device
 		nouveau_abi16_fini(cli->abi16);
 	mutex_unlock(&cli->mutex);
 
-	mutex_lock(&drm->client.mutex);
+	mutex_lock(&drm->clients_lock);
 	list_del(&cli->head);
-	mutex_unlock(&drm->client.mutex);
+	mutex_unlock(&drm->clients_lock);
 
 	nouveau_cli_fini(cli);
 	kfree(cli);
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


