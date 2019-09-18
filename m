Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45964B5CFD
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbfIRGYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727764AbfIRGYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB5E21920;
        Wed, 18 Sep 2019 06:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787848;
        bh=e8s3F0dF6ae8ciX5KzKVqB5ke4kJHwZvYtR1mi6YQqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHu+yA9+ULS3Gsz8kfKDr3B+fTOlY3xPNX3+Ag5g8V/WYwK7+LA3O0Dq6Vf/tIOwg
         LlmzC12lk3oU22d5luWb90cSD1YE9R8xfDscrdoUnlJvD/w4rf6vKcpe8TK/YaRb7U
         jbmNhj77Q7acns9o8PjPp2gn3DZwWhKeYGRKwQfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <smuchun@gmail.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Prateek Sood <prsood@codeaurora.org>
Subject: [PATCH 4.19 33/50] driver core: Fix use-after-free and double free on glue directory
Date:   Wed, 18 Sep 2019 08:19:16 +0200
Message-Id: <20190918061227.070236885@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <smuchun@gmail.com>

commit ac43432cb1f5c2950408534987e57c2071e24d8f upstream.

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

---
 drivers/base/core.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1648,12 +1648,63 @@ static inline struct kobject *get_glue_d
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


