Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0823F681247
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbjA3OTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237638AbjA3OTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:19:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CA33B667
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2713FB8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C3EC433EF;
        Mon, 30 Jan 2023 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088252;
        bh=CPXmNTkX3Skxp0xUIBmIb/2eXnsoBiIeYHVtcrq6Dz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3ahQGv31iaKVhnNWdzvhZCtkFUxccrDVgpGmF6Vhbh5Eq7Kpg0jx0YnEQFCG17L2
         7zLkiMswpwHV0HmfJVsXAcZmmhY+V8+bmPTfCExwLgLEZITT9y+Kygz2B+/P4C5wed
         W9jkdIFFz7LUQpB0DApb9vFQ/4/8cyM0DvEu1akk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/204] exit: Expose "oops_count" to sysfs
Date:   Mon, 30 Jan 2023 14:51:41 +0100
Message-Id: <20230130134322.509560124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 9db89b41117024f80b38b15954017fb293133364 upstream.

Since Oops count is now tracked and is a fairly interesting signal, add
the entry /sys/kernel/oops_count to expose it to userspace.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jann Horn <jannh@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-3-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/sysfs-kernel-oops_count       |  6 +++++
 kernel/exit.c                                 | 22 +++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-oops_count

diff --git a/Documentation/ABI/testing/sysfs-kernel-oops_count b/Documentation/ABI/testing/sysfs-kernel-oops_count
new file mode 100644
index 000000000000..156cca9dbc96
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-oops_count
@@ -0,0 +1,6 @@
+What:		/sys/kernel/oops_count
+Date:		November 2022
+KernelVersion:	6.2.0
+Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
+Description:
+		Shows how many times the system has Oopsed since last boot.
diff --git a/kernel/exit.c b/kernel/exit.c
index 172d7f835f80..f68a9c6adfc9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -64,6 +64,7 @@
 #include <linux/rcuwait.h>
 #include <linux/compat.h>
 #include <linux/io_uring.h>
+#include <linux/sysfs.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -96,6 +97,25 @@ static __init int kernel_exit_sysctls_init(void)
 late_initcall(kernel_exit_sysctls_init);
 #endif
 
+static atomic_t oops_count = ATOMIC_INIT(0);
+
+#ifdef CONFIG_SYSFS
+static ssize_t oops_count_show(struct kobject *kobj, struct kobj_attribute *attr,
+			       char *page)
+{
+	return sysfs_emit(page, "%d\n", atomic_read(&oops_count));
+}
+
+static struct kobj_attribute oops_count_attr = __ATTR_RO(oops_count);
+
+static __init int kernel_exit_sysfs_init(void)
+{
+	sysfs_add_file_to_group(kernel_kobj, &oops_count_attr.attr, NULL);
+	return 0;
+}
+late_initcall(kernel_exit_sysfs_init);
+#endif
+
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
@@ -906,8 +926,6 @@ EXPORT_SYMBOL_GPL(do_exit);
 
 void __noreturn make_task_dead(int signr)
 {
-	static atomic_t oops_count = ATOMIC_INIT(0);
-
 	/*
 	 * Take the task off the cpu after something catastrophic has
 	 * happened.
-- 
2.39.0



