Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8239246A08
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgHQP3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:29:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730082AbgHQP3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD8A823A9B;
        Mon, 17 Aug 2020 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678153;
        bh=w5U96Fw6mjrn3JpYW7hRBEbu4JgEbS0Dkmw6fue0zYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yCYbC+J9WK3kOhzfac+bmy+2wNi0RZr0HdpyJJY5A17FXp2jHlcHt0+aiIRNLfFi
         XcbUNMPMtMldOjUkjGv9V2YAIinR2J9XAjBfbUy0m1BFR+d+l+QrZ9VvcDXWib439n
         ue88nbXR+E2JXxcs0FPo6jIqOn3dGAUmS/jZ54RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel test robot <rong.a.chen@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 219/464] kobject: Avoid premature parent object freeing in kobject_cleanup()
Date:   Mon, 17 Aug 2020 17:12:52 +0200
Message-Id: <20200817143844.294781668@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 079ad2fb4bf9eba8a0aaab014b49705cd7f07c66 ]

If kobject_del() is invoked by kobject_cleanup() to delete the
target kobject, it may cause its parent kobject to be freed
before invoking the target kobject's ->release() method, which
effectively means freeing the parent before dealing with the
child entirely.

That is confusing at best and it may also lead to functional
issues if the callers of kobject_cleanup() are not careful enough
about the order in which these calls are made, so avoid the
problem by making kobject_cleanup() drop the last reference to
the target kobject's parent at the end, after invoking the target
kobject's ->release() method.

[ rjw: Rewrite the subject and changelog, make kobject_cleanup()
  drop the parent reference only when __kobject_del() has been
  called. ]

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: 7589238a8cf3 ("Revert "software node: Simplify software_node_release() function"")
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/1908555.IiAGLGrh1Z@kreacher
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 1e4b7382a88ed..3afb939f2a1cc 100644
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
@@ -632,9 +625,23 @@ void kobject_del(struct kobject *kobj)
 
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
@@ -670,6 +677,7 @@ EXPORT_SYMBOL(kobject_get_unless_zero);
  */
 static void kobject_cleanup(struct kobject *kobj)
 {
+	struct kobject *parent = kobj->parent;
 	struct kobj_type *t = get_ktype(kobj);
 	const char *name = kobj->name;
 
@@ -684,7 +692,10 @@ static void kobject_cleanup(struct kobject *kobj)
 	if (kobj->state_in_sysfs) {
 		pr_debug("kobject: '%s' (%p): auto cleanup kobject_del\n",
 			 kobject_name(kobj), kobj);
-		kobject_del(kobj);
+		__kobject_del(kobj);
+	} else {
+		/* avoid dropping the parent reference unnecessarily */
+		parent = NULL;
 	}
 
 	if (t && t->release) {
@@ -698,6 +709,8 @@ static void kobject_cleanup(struct kobject *kobj)
 		pr_debug("kobject: '%s': free name\n", name);
 		kfree_const(name);
 	}
+
+	kobject_put(parent);
 }
 
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-- 
2.25.1



