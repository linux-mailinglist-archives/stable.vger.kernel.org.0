Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B675923686
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388978AbfETMZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388944AbfETMZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5C9E20675;
        Mon, 20 May 2019 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355104;
        bh=ZkGxzEZLWwXrpJJkC8GbzMTCaMlIEBREVKnobzH24Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJb9uMNbIB046kV77s2WPWn9gUvLLkK6E1ED42G7Zb0v6TrZh/l7nKXK3rvMRCMKd
         usvxv9HfW4RKkCuLq2/CeI9agI90if/Eoxm5xitsn+vUzXmhy2t9qsgHWc/f0xDPM4
         WfYnqPAPxxvfFOwJL8M2HTxdo8xxwXghPPod878Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Guenter Roeck <groeck@chromium.org>
Subject: [PATCH 4.19 099/105] pstore: Centralize init/exit routines
Date:   Mon, 20 May 2019 14:14:45 +0200
Message-Id: <20190520115254.063413847@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit cb095afd44768bf495894b9ad063bd078e4bb201 upstream.

In preparation for having additional actions during init/exit, this moves
the init/exit into platform.c, centralizing the logic to make call outs
to the fs init/exit.

Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/inode.c    |   11 ++---------
 fs/pstore/internal.h |    5 +++--
 fs/pstore/platform.c |   23 +++++++++++++++++++++++
 3 files changed, 28 insertions(+), 11 deletions(-)

--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -482,12 +482,10 @@ static struct file_system_type pstore_fs
 	.kill_sb	= pstore_kill_sb,
 };
 
-static int __init init_pstore_fs(void)
+int __init pstore_init_fs(void)
 {
 	int err;
 
-	pstore_choose_compression();
-
 	/* Create a convenient mount point for people to access pstore */
 	err = sysfs_create_mount_point(fs_kobj, "pstore");
 	if (err)
@@ -500,14 +498,9 @@ static int __init init_pstore_fs(void)
 out:
 	return err;
 }
-module_init(init_pstore_fs)
 
-static void __exit exit_pstore_fs(void)
+void __exit pstore_exit_fs(void)
 {
 	unregister_filesystem(&pstore_fs_type);
 	sysfs_remove_mount_point(fs_kobj, "pstore");
 }
-module_exit(exit_pstore_fs)
-
-MODULE_AUTHOR("Tony Luck <tony.luck@intel.com>");
-MODULE_LICENSE("GPL");
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -37,7 +37,8 @@ extern bool	pstore_is_mounted(void);
 extern void	pstore_record_init(struct pstore_record *record,
 				   struct pstore_info *psi);
 
-/* Called during module_init() */
-extern void __init pstore_choose_compression(void);
+/* Called during pstore init/exit. */
+int __init	pstore_init_fs(void);
+void __exit	pstore_exit_fs(void);
 
 #endif
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -780,8 +780,31 @@ void __init pstore_choose_compression(vo
 	}
 }
 
+static int __init pstore_init(void)
+{
+	int ret;
+
+	pstore_choose_compression();
+
+	ret = pstore_init_fs();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+module_init(pstore_init)
+
+static void __exit pstore_exit(void)
+{
+	pstore_exit_fs();
+}
+module_exit(pstore_exit)
+
 module_param(compress, charp, 0444);
 MODULE_PARM_DESC(compress, "Pstore compression to use");
 
 module_param(backend, charp, 0444);
 MODULE_PARM_DESC(backend, "Pstore backend to use");
+
+MODULE_AUTHOR("Tony Luck <tony.luck@intel.com>");
+MODULE_LICENSE("GPL");


