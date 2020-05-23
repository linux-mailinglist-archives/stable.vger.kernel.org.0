Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF461DF7F1
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 17:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbgEWPNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 11:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387867AbgEWPNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 11:13:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A71FB2071C;
        Sat, 23 May 2020 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590246787;
        bh=AzSatURo6hgJG9hfj5elmyoScqdGFmOA/nnPjlEkePk=;
        h=Subject:To:From:Date:From;
        b=NVSYhukFVUmhErpg/YtnsCC4tfZMUAkU+Ndg11Wfuyi7NncxrodA7fnBtX/GEoO4I
         U7Vmlj05pDc8peUis7KURVfDbn/px6K/mJPU39B62By3axAWklPw02D1/sjogYeyk1
         3KD6uUfCNZ4tSlpUof2mt0ESZ6eBQXcX07/Iz224=
Subject: patch "Revert "kobject: Make sure the parent does not get released before" added to driver-core-linus
To:     gregkh@linuxfoundation.org, brendanhiggins@google.com,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        naresh.kamboju@linaro.org, rafael@kernel.org,
        rdunlap@infradead.org, rong.a.chen@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 May 2020 17:13:04 +0200
Message-ID: <159024678421391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "kobject: Make sure the parent does not get released before

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e6764aa0e5530066dd969eccea2a1a7d177859a8 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 23 May 2020 17:11:11 +0200
Subject: Revert "kobject: Make sure the parent does not get released before
 its children"

This reverts commit 4ef12f7198023c09ad6d25b652bd8748c965c7fa.

Guenter reports:

	All my arm64be (arm64 big endian) boot tests crash with this
	patch applied. Reverting it fixes the problem. Crash log and
	bisect results (from pending-fixes branch) below.

And also:
	arm64 images don't crash but report lots of "poison overwritten"
	backtraces like the one below. On arm, I see "refcount_t:
	underflow", also attached.  I didn't bisect those, but given the
	context I would suspect the same culprit.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200513151840.36400-1-heikki.krogerus@linux.intel.com
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: kernel test robot <rong.a.chen@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/kobject.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 2bd631460e18..83198cb37d8d 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -599,7 +599,14 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
 }
 EXPORT_SYMBOL_GPL(kobject_move);
 
-static void __kobject_del(struct kobject *kobj)
+/**
+ * kobject_del() - Unlink kobject from hierarchy.
+ * @kobj: object.
+ *
+ * This is the function that should be called to delete an object
+ * successfully added via kobject_add().
+ */
+void kobject_del(struct kobject *kobj)
 {
 	struct kernfs_node *sd;
 	const struct kobj_type *ktype;
@@ -618,23 +625,9 @@ static void __kobject_del(struct kobject *kobj)
 
 	kobj->state_in_sysfs = 0;
 	kobj_kset_leave(kobj);
+	kobject_put(kobj->parent);
 	kobj->parent = NULL;
 }
-
-/**
- * kobject_del() - Unlink kobject from hierarchy.
- * @kobj: object.
- *
- * This is the function that should be called to delete an object
- * successfully added via kobject_add().
- */
-void kobject_del(struct kobject *kobj)
-{
-	struct kobject *parent = kobj->parent;
-
-	__kobject_del(kobj);
-	kobject_put(parent);
-}
 EXPORT_SYMBOL(kobject_del);
 
 /**
@@ -670,7 +663,6 @@ EXPORT_SYMBOL(kobject_get_unless_zero);
  */
 static void kobject_cleanup(struct kobject *kobj)
 {
-	struct kobject *parent = kobj->parent;
 	struct kobj_type *t = get_ktype(kobj);
 	const char *name = kobj->name;
 
@@ -692,7 +684,7 @@ static void kobject_cleanup(struct kobject *kobj)
 	if (kobj->state_in_sysfs) {
 		pr_debug("kobject: '%s' (%p): auto cleanup kobject_del\n",
 			 kobject_name(kobj), kobj);
-		__kobject_del(kobj);
+		kobject_del(kobj);
 	}
 
 	if (t && t->release) {
@@ -706,8 +698,6 @@ static void kobject_cleanup(struct kobject *kobj)
 		pr_debug("kobject: '%s': free name\n", name);
 		kfree_const(name);
 	}
-
-	kobject_put(parent);
 }
 
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-- 
2.26.2


