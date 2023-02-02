Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963BA687524
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjBBF21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjBBF2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:28:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D590D1632E;
        Wed,  1 Feb 2023 21:28:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E933615EF;
        Thu,  2 Feb 2023 05:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46826C4339E;
        Thu,  2 Feb 2023 05:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675315686;
        bh=mLCdAaBunvOHoCrOt7GOusY5wCBMyBacAnEmb2lGEsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPtzLG7wxU9csHV6Ur1qYJ8uKhl4YWaozd9ri0rjNiNdl6oiEmYywKs5o7MqtW19/
         vlPyIYTKkTJeYnA41oXKOuQOTDMFNvREctoXfue7j3Be5gDUvnjxq7mB8gMQre875y
         0BzUTTvT9JwZXjXAsqehGeBpCNhbc5vEZ7FhnB8jICn4OQV1CWhQDSdk3O3UxpeeRu
         buHudUiJl76Ll6hCAj6hDCuAjoRec0mVgJqNF4LkWrkQfrbNOPbn1Ty01Ql2vQEPbK
         9SycmdIkeRdBADvJ5v5uuSqwem7+Xitk9oDej9Yvmx1lUCMy3CwWczjkp14ggSnYNM
         O1eVmw3ZX2vhA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 4.19 10/16] exit: Expose "oops_count" to sysfs
Date:   Wed,  1 Feb 2023 21:25:58 -0800
Message-Id: <20230202052604.179184-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202052604.179184-1-ebiggers@kernel.org>
References: <20230202052604.179184-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
---
 .../ABI/testing/sysfs-kernel-oops_count       |  6 +++++
 kernel/exit.c                                 | 22 +++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-oops_count

diff --git a/Documentation/ABI/testing/sysfs-kernel-oops_count b/Documentation/ABI/testing/sysfs-kernel-oops_count
new file mode 100644
index 0000000000000..156cca9dbc960
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
index fa3004ff33362..5cd8a34257650 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -62,6 +62,7 @@
 #include <linux/random.h>
 #include <linux/rcuwait.h>
 #include <linux/compat.h>
+#include <linux/sysfs.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -95,6 +96,25 @@ static __init int kernel_exit_sysctls_init(void)
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
@@ -951,8 +971,6 @@ EXPORT_SYMBOL_GPL(do_exit);
 
 void __noreturn make_task_dead(int signr)
 {
-	static atomic_t oops_count = ATOMIC_INIT(0);
-
 	/*
 	 * Take the task off the cpu after something catastrophic has
 	 * happened.
-- 
2.39.1

