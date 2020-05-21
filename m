Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E2F1DC931
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 11:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgEUJBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 05:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbgEUJBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 05:01:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC0320721;
        Thu, 21 May 2020 09:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590051700;
        bh=w3fxajhFTGvFDzTWBK4lEmPVYCc520Ea48JTTVi5wf4=;
        h=Subject:To:From:Date:From;
        b=ivy4mouSX+XhTAy3O6fIAAtyOq8NyRQMjCh7Kd3QJx5LgaxJ1yd6lMSGyz2p30kMF
         63ypPVXp9FTPrpvRt4l9vNNwFhYEvRhrNO+kqbveMe+jFHVKulSY5ehb1xpmnFV6/y
         Ooxe6E5v+gMw7cGfBDJPjBWTh+f/wC5pDJkhwhzc=
Subject: patch "kobject: Make sure the parent does not get released before its" added to driver-core-linus
To:     heikki.krogerus@linux.intel.com, brendanhiggins@google.com,
        gregkh@linuxfoundation.org, naresh.kamboju@linaro.org,
        rafael.j.wysocki@intel.com, rafael@kernel.org,
        rdunlap@infradead.org, rong.a.chen@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 May 2020 11:01:37 +0200
Message-ID: <159005169722757@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    kobject: Make sure the parent does not get released before its

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4ef12f7198023c09ad6d25b652bd8748c965c7fa Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Wed, 13 May 2020 18:18:40 +0300
Subject: kobject: Make sure the parent does not get released before its
 children

In the function kobject_cleanup(), kobject_del(kobj) is
called before the kobj->release(). That makes it possible to
release the parent of the kobject before the kobject itself.

To fix that, adding function __kboject_del() that does
everything that kobject_del() does except release the parent
reference. kobject_cleanup() then calls __kobject_del()
instead of kobject_del(), and separately decrements the
reference count of the parent kobject after kobj->release()
has been called.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: 7589238a8cf3 ("Revert "software node: Simplify software_node_release() function"")
Suggested-by: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20200513151840.36400-1-heikki.krogerus@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/kobject.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 83198cb37d8d..2bd631460e18 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -599,14 +599,7 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
 }
 EXPORT_SYMBOL_GPL(kobject_move);
 
-/**
- * kobject_del() - Unlink kobject from hierarchy.
- * @kobj: object.
- *
- * This is the function that should be called to delete an object
- * successfully added via kobject_add().
- */
-void kobject_del(struct kobject *kobj)
+static void __kobject_del(struct kobject *kobj)
 {
 	struct kernfs_node *sd;
 	const struct kobj_type *ktype;
@@ -625,9 +618,23 @@ void kobject_del(struct kobject *kobj)
 
 	kobj->state_in_sysfs = 0;
 	kobj_kset_leave(kobj);
-	kobject_put(kobj->parent);
 	kobj->parent = NULL;
 }
+
+/**
+ * kobject_del() - Unlink kobject from hierarchy.
+ * @kobj: object.
+ *
+ * This is the function that should be called to delete an object
+ * successfully added via kobject_add().
+ */
+void kobject_del(struct kobject *kobj)
+{
+	struct kobject *parent = kobj->parent;
+
+	__kobject_del(kobj);
+	kobject_put(parent);
+}
 EXPORT_SYMBOL(kobject_del);
 
 /**
@@ -663,6 +670,7 @@ EXPORT_SYMBOL(kobject_get_unless_zero);
  */
 static void kobject_cleanup(struct kobject *kobj)
 {
+	struct kobject *parent = kobj->parent;
 	struct kobj_type *t = get_ktype(kobj);
 	const char *name = kobj->name;
 
@@ -684,7 +692,7 @@ static void kobject_cleanup(struct kobject *kobj)
 	if (kobj->state_in_sysfs) {
 		pr_debug("kobject: '%s' (%p): auto cleanup kobject_del\n",
 			 kobject_name(kobj), kobj);
-		kobject_del(kobj);
+		__kobject_del(kobj);
 	}
 
 	if (t && t->release) {
@@ -698,6 +706,8 @@ static void kobject_cleanup(struct kobject *kobj)
 		pr_debug("kobject: '%s': free name\n", name);
 		kfree_const(name);
 	}
+
+	kobject_put(parent);
 }
 
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-- 
2.26.2


