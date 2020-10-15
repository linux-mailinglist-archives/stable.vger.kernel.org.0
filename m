Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC9628F96D
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 21:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391552AbgJOTaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 15:30:06 -0400
Received: from linux.microsoft.com ([13.77.154.182]:50322 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391541AbgJOTaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 15:30:05 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id A8C0E20B4907;
        Thu, 15 Oct 2020 12:30:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A8C0E20B4907
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602790205;
        bh=/gnJ4499ziF9+2ZnFoIgTBWHkNq7uHRC35nKAX9DnsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joMGOxXPcwrmQ31Yf/g5x7NoXOxFuujEMBoH9VE/MW/wVQo5wy2oMllO+/DCsFjj8
         KyZPe6FZO2D/rxrEZ/Jb1xGL8a0VRp3RJpbAI2u2tV50qJ0IuzUO13l6SJaCdqyuHl
         9sYdpJsF502CPCrek75Rsm1SU3BjmHuFr3IjBzPE=
From:   Daniel Burgener <dburgener@linux.microsoft.com>
To:     stable@vger.kernel.org
Cc:     stephen.smalley.work@gmail.com, paul@paul-moore.com,
        selinux@vger.kernel.org, jmorris@namei.org, sashal@kernel.org
Subject: [PATCH v5.4 1/3] selinux: Create function for selinuxfs directory cleanup
Date:   Thu, 15 Oct 2020 15:29:54 -0400
Message-Id: <20201015192956.1797021-2-dburgener@linux.microsoft.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Separating the cleanup from the creation will simplify two things in
future patches in this series.  First, the creation can be made generic,
to create directories not tied to the selinux_fs_info structure.  Second,
we will ultimately want to reorder creation and deletion so that the
deletions aren't performed until the new directory structures have already
been moved into place.

Signed-off-by: Daniel Burgener <dburgener@linux.microsoft.com>
---
 security/selinux/selinuxfs.c | 39 +++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index e9eaff90cbcc..092c7295f78d 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -348,6 +348,9 @@ static int sel_make_policycap(struct selinux_fs_info *fsi);
 static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
 			unsigned long *ino);
 
+/* declaration for sel_remove_old_policy_nodes */
+static void sel_remove_entries(struct dentry *de);
+
 static ssize_t sel_read_mls(struct file *filp, char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -502,10 +505,32 @@ static const struct file_operations sel_policy_ops = {
 	.llseek		= generic_file_llseek,
 };
 
+static void sel_remove_old_policy_nodes(struct selinux_fs_info *fsi)
+{
+	u32 i;
+
+	/* bool_dir cleanup */
+	for (i = 0; i < fsi->bool_num; i++)
+		kfree(fsi->bool_pending_names[i]);
+	kfree(fsi->bool_pending_names);
+	kfree(fsi->bool_pending_values);
+	fsi->bool_num = 0;
+	fsi->bool_pending_names = NULL;
+	fsi->bool_pending_values = NULL;
+
+	sel_remove_entries(fsi->bool_dir);
+
+	/* class_dir cleanup */
+	sel_remove_entries(fsi->class_dir);
+
+}
+
 static int sel_make_policy_nodes(struct selinux_fs_info *fsi)
 {
 	int ret;
 
+	sel_remove_old_policy_nodes(fsi);
+
 	ret = sel_make_bools(fsi);
 	if (ret) {
 		pr_err("SELinux: failed to load policy booleans\n");
@@ -1336,17 +1361,6 @@ static int sel_make_bools(struct selinux_fs_info *fsi)
 	int *values = NULL;
 	u32 sid;
 
-	/* remove any existing files */
-	for (i = 0; i < fsi->bool_num; i++)
-		kfree(fsi->bool_pending_names[i]);
-	kfree(fsi->bool_pending_names);
-	kfree(fsi->bool_pending_values);
-	fsi->bool_num = 0;
-	fsi->bool_pending_names = NULL;
-	fsi->bool_pending_values = NULL;
-
-	sel_remove_entries(dir);
-
 	ret = -ENOMEM;
 	page = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!page)
@@ -1798,9 +1812,6 @@ static int sel_make_classes(struct selinux_fs_info *fsi)
 	int rc, nclasses, i;
 	char **classes;
 
-	/* delete any existing entries */
-	sel_remove_entries(fsi->class_dir);
-
 	rc = security_get_classes(fsi->state, &classes, &nclasses);
 	if (rc)
 		return rc;
-- 
2.25.4

