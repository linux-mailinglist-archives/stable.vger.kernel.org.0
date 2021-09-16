Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84C740E313
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbhIPQpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245668AbhIPQmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C126613AC;
        Thu, 16 Sep 2021 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809471;
        bh=XgeBbQVoqwBMNAmCiTVBeRAxs3WUsP0J1lbITZSpjQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvQXBrKRLbn3/wWPLjyTDn7PsEy6zr/J1U4iAA6tMTQNJzJXZrfbJlezrXmKpXGbM
         BmLn3P5WTV/mdNUT1Qs9M3KlSD6atn235G3/jhC2Q+eFFIaypCalDw6jQFS2OrHHFC
         R9qHMEiAaN9QXN2qKx2TD+ct8DprKPNfoQ75LRTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 166/380] drm: serialize drm_file.master with a new spinlock
Date:   Thu, 16 Sep 2021 17:58:43 +0200
Message-Id: <20210916155809.733990965@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit 0b0860a3cf5eccf183760b1177a1dcdb821b0b66 ]

Currently, drm_file.master pointers should be protected by
drm_device.master_mutex when being dereferenced. This is because
drm_file.master is not invariant for the lifetime of drm_file. If
drm_file is not the creator of master, then drm_file.is_master is
false, and a call to drm_setmaster_ioctl will invoke
drm_new_set_master, which then allocates a new master for drm_file and
puts the old master.

Thus, without holding drm_device.master_mutex, the old value of
drm_file.master could be freed while it is being used by another
concurrent process.

However, it is not always possible to lock drm_device.master_mutex to
dereference drm_file.master. Through the fbdev emulation code, this
might occur in a deep nest of other locks. But drm_device.master_mutex
is also the outermost lock in the nesting hierarchy, so this leads to
potential deadlocks.

To address this, we introduce a new spin lock at the bottom of the
lock hierarchy that only serializes drm_file.master. With this change,
the value of drm_file.master changes only when both
drm_device.master_mutex and drm_file.master_lookup_lock are
held. Hence, any process holding either of those locks can ensure that
the value of drm_file.master will not change concurrently.

Since no lock depends on the new drm_file.master_lookup_lock, when
drm_file.master is dereferenced, but drm_device.master_mutex cannot be
held, we can safely protect the master pointer with
drm_file.master_lookup_lock.

Reported-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210712043508.11584-5-desmondcheongzx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_auth.c | 17 +++++++++++------
 drivers/gpu/drm/drm_file.c |  1 +
 include/drm/drm_file.h     | 12 +++++++++---
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index 232abbba3686..0024ad93d24b 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -135,16 +135,18 @@ static void drm_set_master(struct drm_device *dev, struct drm_file *fpriv,
 static int drm_new_set_master(struct drm_device *dev, struct drm_file *fpriv)
 {
 	struct drm_master *old_master;
+	struct drm_master *new_master;
 
 	lockdep_assert_held_once(&dev->master_mutex);
 
 	WARN_ON(fpriv->is_master);
 	old_master = fpriv->master;
-	fpriv->master = drm_master_create(dev);
-	if (!fpriv->master) {
-		fpriv->master = old_master;
+	new_master = drm_master_create(dev);
+	if (!new_master)
 		return -ENOMEM;
-	}
+	spin_lock(&fpriv->master_lookup_lock);
+	fpriv->master = new_master;
+	spin_unlock(&fpriv->master_lookup_lock);
 
 	fpriv->is_master = 1;
 	fpriv->authenticated = 1;
@@ -302,10 +304,13 @@ int drm_master_open(struct drm_file *file_priv)
 	/* if there is no current master make this fd it, but do not create
 	 * any master object for render clients */
 	mutex_lock(&dev->master_mutex);
-	if (!dev->master)
+	if (!dev->master) {
 		ret = drm_new_set_master(dev, file_priv);
-	else
+	} else {
+		spin_lock(&file_priv->master_lookup_lock);
 		file_priv->master = drm_master_get(dev->master);
+		spin_unlock(&file_priv->master_lookup_lock);
+	}
 	mutex_unlock(&dev->master_mutex);
 
 	return ret;
diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 7efbccffc2ea..c6feeb5651b0 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -176,6 +176,7 @@ struct drm_file *drm_file_alloc(struct drm_minor *minor)
 	init_waitqueue_head(&file->event_wait);
 	file->event_space = 4096; /* set aside 4k for event buffer */
 
+	spin_lock_init(&file->master_lookup_lock);
 	mutex_init(&file->event_read_lock);
 
 	if (drm_core_check_feature(dev, DRIVER_GEM))
diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index b81b3bfb08c8..9b82988e3427 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -226,15 +226,21 @@ struct drm_file {
 	/**
 	 * @master:
 	 *
-	 * Master this node is currently associated with. Only relevant if
-	 * drm_is_primary_client() returns true. Note that this only
-	 * matches &drm_device.master if the master is the currently active one.
+	 * Master this node is currently associated with. Protected by struct
+	 * &drm_device.master_mutex, and serialized by @master_lookup_lock.
+	 *
+	 * Only relevant if drm_is_primary_client() returns true. Note that
+	 * this only matches &drm_device.master if the master is the currently
+	 * active one.
 	 *
 	 * See also @authentication and @is_master and the :ref:`section on
 	 * primary nodes and authentication <drm_primary_node>`.
 	 */
 	struct drm_master *master;
 
+	/** @master_lock: Serializes @master. */
+	spinlock_t master_lookup_lock;
+
 	/** @pid: Process that opened this file. */
 	struct pid *pid;
 
-- 
2.30.2



