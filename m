Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D54D5AE715
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiIFMAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiIFMAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC0672EF4
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 05:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5B52614D4
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 12:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA5FC433C1;
        Tue,  6 Sep 2022 12:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465628;
        bh=i3WfYTOlS+se0/HqWBk9/V5zp9mngNJ8wqarExTVqc4=;
        h=Subject:To:Cc:From:Date:From;
        b=C9de0HDnjcPRKSywXBKJVbiQlsgtrXhZkOVDGn/cNzdENByOUOCc6mlxMCCe0S4aE
         nV9N1t0rZDSqdwpHnQ3iTptp6Uyt+xWio1rygg28jU1lkNFmIn4QNvuxTzehGDDlt/
         KEru4SXJHs2UNjGU2OQHtMHnG5or6dTnRByOVcpA=
Subject: FAILED: patch "[PATCH] selinux: implement the security_uring_cmd() LSM hook" failed to apply to 5.10-stable tree
To:     paul@paul-moore.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 14:00:11 +0200
Message-ID: <166246561142219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f4d653dcaa4e ("selinux: implement the security_uring_cmd() LSM hook")
740b03414b20 ("selinux: add support for the io_uring access controls")
29cd6591ab6f ("selinux: teach SELinux about anonymous inodes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f4d653dcaa4e4056e1630423e6a8ece4869b544f Mon Sep 17 00:00:00 2001
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 10 Aug 2022 15:55:36 -0400
Subject: [PATCH] selinux: implement the security_uring_cmd() LSM hook

Add a SELinux access control for the iouring IORING_OP_URING_CMD
command.  This includes the addition of a new permission in the
existing "io_uring" object class: "cmd".  The subject of the new
permission check is the domain of the process requesting access, the
object is the open file which points to the device/file that is the
target of the IORING_OP_URING_CMD operation.  A sample policy rule
is shown below:

  allow <domain> <file>:io_uring { cmd };

Cc: stable@vger.kernel.org
Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 79573504783b..03bca97c8b29 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -91,6 +91,7 @@
 #include <uapi/linux/mount.h>
 #include <linux/fsnotify.h>
 #include <linux/fanotify.h>
+#include <linux/io_uring.h>
 
 #include "avc.h"
 #include "objsec.h"
@@ -6987,6 +6988,28 @@ static int selinux_uring_sqpoll(void)
 	return avc_has_perm(&selinux_state, sid, sid,
 			    SECCLASS_IO_URING, IO_URING__SQPOLL, NULL);
 }
+
+/**
+ * selinux_uring_cmd - check if IORING_OP_URING_CMD is allowed
+ * @ioucmd: the io_uring command structure
+ *
+ * Check to see if the current domain is allowed to execute an
+ * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
+ *
+ */
+static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct file *file = ioucmd->file;
+	struct inode *inode = file_inode(file);
+	struct inode_security_struct *isec = selinux_inode(inode);
+	struct common_audit_data ad;
+
+	ad.type = LSM_AUDIT_DATA_FILE;
+	ad.u.file = file;
+
+	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
+			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
+}
 #endif /* CONFIG_IO_URING */
 
 /*
@@ -7231,6 +7254,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 #ifdef CONFIG_IO_URING
 	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
+	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
 #endif
 
 	/*
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index ff757ae5f253..1c2f41ff4e55 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -253,7 +253,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "anon_inode",
 	  { COMMON_FILE_PERMS, NULL } },
 	{ "io_uring",
-	  { "override_creds", "sqpoll", NULL } },
+	  { "override_creds", "sqpoll", "cmd", NULL } },
 	{ NULL }
   };
 

