Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D87290697
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408419AbgJPNsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:48:51 -0400
Received: from linux.microsoft.com ([13.77.154.182]:53638 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408409AbgJPNsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:48:51 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1E0B720B4907;
        Fri, 16 Oct 2020 06:48:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1E0B720B4907
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602856130;
        bh=r+BR3vI76WcZDNjqS+OVDMPcwfxUrXkhD0IUUjWisCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHlIoR8nsvhZ3dPADbvY+V6RKx3/bfJjBc3NGjs16h+WFYMXMASfKy/ftv1/tmvDr
         onqmYWScqNj9SdYh5pCUJRpl2SjxaCfUQ3xE9uEEp5WCXXHi6xlXbILl5OsPc4exW5
         4ouzHos4F2jENc8ghPCZejhfH3gHAea0CRKoA6EI=
From:   Daniel Burgener <dburgener@linux.microsoft.com>
To:     stable@vger.kernel.org
Cc:     stephen.smalley.work@gmail.com, paul@paul-moore.com,
        selinux@vger.kernel.org, jmorris@namei.org, sashal@kernel.org
Subject: [PATCH v5.4 v2 1/4] selinux: Create function for selinuxfs directory cleanup
Date:   Fri, 16 Oct 2020 09:48:32 -0400
Message-Id: <20201016134835.1886478-2-dburgener@linux.microsoft.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201016134835.1886478-1-dburgener@linux.microsoft.com>
References: <20201016134835.1886478-1-dburgener@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit aeecf4a3fb11954cb10b8bc57e1661a6e4e9f3a9

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

