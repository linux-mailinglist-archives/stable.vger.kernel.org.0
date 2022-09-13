Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754DB5B704B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiIMOYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiIMOYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFDC61B07;
        Tue, 13 Sep 2022 07:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F4D6149A;
        Tue, 13 Sep 2022 14:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BFBC433C1;
        Tue, 13 Sep 2022 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078557;
        bh=Pz2rluRqj1HiTRIs4B7o1dyuQnjEC7qQ85azr/jT+7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJj5gQlzKz/1QYHKMeGkEtlO/ol20Vts9KAXeL81k62Uu0BSEJ9ND0/Yoo+QMcyS7
         s8McNRJU4fUxsGOPLN50inQoGmpv2Hdiq+gHiCtEzBoTE9sIQe4XUOELoxagTJNs/J
         pfVi07LA5PaRoY/07IpgqwN5Hq1z1xCx7d53ZzF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.19 160/192] selinux: implement the security_uring_cmd() LSM hook
Date:   Tue, 13 Sep 2022 16:04:26 +0200
Message-Id: <20220913140418.001867651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Paul Moore <paul@paul-moore.com>

commit f4d653dcaa4e4056e1630423e6a8ece4869b544f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c            |   24 ++++++++++++++++++++++++
 security/selinux/include/classmap.h |    2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -91,6 +91,7 @@
 #include <uapi/linux/mount.h>
 #include <linux/fsnotify.h>
 #include <linux/fanotify.h>
+#include <linux/io_uring.h>
 
 #include "avc.h"
 #include "objsec.h"
@@ -6990,6 +6991,28 @@ static int selinux_uring_sqpoll(void)
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
@@ -7234,6 +7257,7 @@ static struct security_hook_list selinux
 #ifdef CONFIG_IO_URING
 	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
+	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
 #endif
 
 	/*
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -253,7 +253,7 @@ const struct security_class_mapping secc
 	{ "anon_inode",
 	  { COMMON_FILE_PERMS, NULL } },
 	{ "io_uring",
-	  { "override_creds", "sqpoll", NULL } },
+	  { "override_creds", "sqpoll", "cmd", NULL } },
 	{ NULL }
   };
 


