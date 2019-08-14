Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC3D8C733
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbfHNCVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729623AbfHNCTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:19:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C67DB20989;
        Wed, 14 Aug 2019 02:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749143;
        bh=+Oq4uwrBqsBa801wjMlZXmTalJtMNAihIKFHXbq9YLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZkRnbaqn7yelTVV4rscsje72nCMLVHqtt+6D6L4TT+5t0mHTDpUFbV71TQpjt5TJ
         VMbnhmWWwxsJNe8ks3iv//VUu5tQvHYYjUnah9yON1bQAtFTXEJWVBTuz9SF+qz4Ze
         eQ3wdK3Eb/F1TmcAPj9vH3affyHxOhe1VuFp7mn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Muchun Song <smuchun@gmail.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Prateek Sood <prsood@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 18/44] driver core: Fix use-after-free and double free on glue directory
Date:   Tue, 13 Aug 2019 22:18:07 -0400
Message-Id: <20190814021834.16662-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021834.16662-1-sashal@kernel.org>
References: <20190814021834.16662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <smuchun@gmail.com>

[ Upstream commit ac43432cb1f5c2950408534987e57c2071e24d8f ]

There is a race condition between removing glue directory and adding a new
device under the glue dir. It can be reproduced in following test:

CPU1:                                         CPU2:

device_add()
  get_device_parent()
    class_dir_create_and_add()
      kobject_add_internal()
        create_dir()    // create glue_dir

                                              device_add()
                                                get_device_parent()
                                                  kobject_get() // get glue_dir

device_del()
  cleanup_glue_dir()
    kobject_del(glue_dir)

                                                kobject_add()
                                                  kobject_add_internal()
                                                    create_dir() // in glue_dir
                                                      sysfs_create_dir_ns()
                                                        kernfs_create_dir_ns(sd)

      sysfs_remove_dir() // glue_dir->sd=NULL
      sysfs_put()        // free glue_dir->sd

                                                          // sd is freed
                                                          kernfs_new_node(sd)
                                                            kernfs_get(glue_dir)
                                                            kernfs_add_one()
                                                            kernfs_put()

Before CPU1 remove last child device under glue dir, if CPU2 add a new
device under glue dir, the glue_dir kobject reference count will be
increase to 2 via kobject_get() in get_device_parent(). And CPU2 has
been called kernfs_create_dir_ns(), but not call kernfs_new_node().
Meanwhile, CPU1 call sysfs_remove_dir() and sysfs_put(). This result in
glue_dir->sd is freed and it's reference count will be 0. Then CPU2 call
kernfs_get(glue_dir) will trigger a warning in kernfs_get() and increase
it's reference count to 1. Because glue_dir->sd is freed by CPU1, the next
call kernfs_add_one() by CPU2 will fail(This is also use-after-free)
and call kernfs_put() to decrease reference count. Because the reference
count is decremented to 0, it will also call kmem_cache_free() to free
the glue_dir->sd again. This will result in double free.

In order to avoid this happening, we also should make sure that kernfs_node
for glue_dir is released in CPU1 only when refcount for glue_dir kobj is
1 to fix this race.

The following calltrace is captured in kernel 4.14 with the following patch
applied:

commit 726e41097920 ("drivers: core: Remove glue dirs from sysfs earlier")

--------------------------------------------------------------------------
[    3.633703] WARNING: CPU: 4 PID: 513 at .../fs/kernfs/dir.c:494
                Here is WARN_ON(!atomic_read(&kn->count) in kernfs_get().
....
[    3.633986] Call trace:
[    3.633991]  kernfs_create_dir_ns+0xa8/0xb0
[    3.633994]  sysfs_create_dir_ns+0x54/0xe8
[    3.634001]  kobject_add_internal+0x22c/0x3f0
[    3.634005]  kobject_add+0xe4/0x118
[    3.634011]  device_add+0x200/0x870
[    3.634017]  _request_firmware+0x958/0xc38
[    3.634020]  request_firmware_into_buf+0x4c/0x70
....
[    3.634064] kernel BUG at .../mm/slub.c:294!
                Here is BUG_ON(object == fp) in set_freepointer().
....
[    3.634346] Call trace:
[    3.634351]  kmem_cache_free+0x504/0x6b8
[    3.634355]  kernfs_put+0x14c/0x1d8
[    3.634359]  kernfs_create_dir_ns+0x88/0xb0
[    3.634362]  sysfs_create_dir_ns+0x54/0xe8
[    3.634366]  kobject_add_internal+0x22c/0x3f0
[    3.634370]  kobject_add+0xe4/0x118
[    3.634374]  device_add+0x200/0x870
[    3.634378]  _request_firmware+0x958/0xc38
[    3.634381]  request_firmware_into_buf+0x4c/0x70
--------------------------------------------------------------------------

Fixes: 726e41097920 ("drivers: core: Remove glue dirs from sysfs earlier")
Signed-off-by: Muchun Song <smuchun@gmail.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Prateek Sood <prsood@codeaurora.org>
Link: https://lore.kernel.org/r/20190727032122.24639-1-smuchun@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 53 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 1c67bf24bc23c..2ec9af90cd28e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1572,12 +1572,63 @@ static inline struct kobject *get_glue_dir(struct device *dev)
  */
 static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
+	unsigned int ref;
+
 	/* see if we live in a "glue" directory */
 	if (!live_in_glue_dir(glue_dir, dev))
 		return;
 
 	mutex_lock(&gdp_mutex);
-	if (!kobject_has_children(glue_dir))
+	/**
+	 * There is a race condition between removing glue directory
+	 * and adding a new device under the glue directory.
+	 *
+	 * CPU1:                                         CPU2:
+	 *
+	 * device_add()
+	 *   get_device_parent()
+	 *     class_dir_create_and_add()
+	 *       kobject_add_internal()
+	 *         create_dir()    // create glue_dir
+	 *
+	 *                                               device_add()
+	 *                                                 get_device_parent()
+	 *                                                   kobject_get() // get glue_dir
+	 *
+	 * device_del()
+	 *   cleanup_glue_dir()
+	 *     kobject_del(glue_dir)
+	 *
+	 *                                               kobject_add()
+	 *                                                 kobject_add_internal()
+	 *                                                   create_dir() // in glue_dir
+	 *                                                     sysfs_create_dir_ns()
+	 *                                                       kernfs_create_dir_ns(sd)
+	 *
+	 *       sysfs_remove_dir() // glue_dir->sd=NULL
+	 *       sysfs_put()        // free glue_dir->sd
+	 *
+	 *                                                         // sd is freed
+	 *                                                         kernfs_new_node(sd)
+	 *                                                           kernfs_get(glue_dir)
+	 *                                                           kernfs_add_one()
+	 *                                                           kernfs_put()
+	 *
+	 * Before CPU1 remove last child device under glue dir, if CPU2 add
+	 * a new device under glue dir, the glue_dir kobject reference count
+	 * will be increase to 2 in kobject_get(k). And CPU2 has been called
+	 * kernfs_create_dir_ns(). Meanwhile, CPU1 call sysfs_remove_dir()
+	 * and sysfs_put(). This result in glue_dir->sd is freed.
+	 *
+	 * Then the CPU2 will see a stale "empty" but still potentially used
+	 * glue dir around in kernfs_new_node().
+	 *
+	 * In order to avoid this happening, we also should make sure that
+	 * kernfs_node for glue_dir is released in CPU1 only when refcount
+	 * for glue_dir kobj is 1.
+	 */
+	ref = kref_read(&glue_dir->kref);
+	if (!kobject_has_children(glue_dir) && !--ref)
 		kobject_del(glue_dir);
 	kobject_put(glue_dir);
 	mutex_unlock(&gdp_mutex);
-- 
2.20.1

