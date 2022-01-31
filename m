Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE8A4A4438
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359555AbiAaL1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:27:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42774 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359557AbiAaLZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BF59B82A6E;
        Mon, 31 Jan 2022 11:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939EDC340E8;
        Mon, 31 Jan 2022 11:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628316;
        bh=PkJT3SYvfU8qtA6Tszre4miU+PS5+gAEXM9RioVyluA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC7Dz0uD06yHZFTt9gYOV2R8DVw7LVNUnFCRmzLu8p0HdvcGfLOROis0bNZhZphJq
         NuQjhBkTh7iedz9sSp2vTgYgd/Struf5AUAHHNrbgdNH+hOs06+e3mqSRF1ZSk0ex6
         fm0vNuCvqgUx+4Mk8LCEz42yI2SxEEVEpPJOeRYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        kernel test robot <lkp@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 193/200] psi: fix "defined but not used" warnings when CONFIG_PROC_FS=n
Date:   Mon, 31 Jan 2022 11:57:36 +0100
Message-Id: <20220131105240.029813235@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

commit 44585f7bc0cb01095bc2ad4258049c02bbad21ef upstream.

When CONFIG_PROC_FS is disabled psi code generates the following
warnings:

  kernel/sched/psi.c:1364:30: warning: 'psi_cpu_proc_ops' defined but not used [-Wunused-const-variable=]
      1364 | static const struct proc_ops psi_cpu_proc_ops = {
           |                              ^~~~~~~~~~~~~~~~
  kernel/sched/psi.c:1355:30: warning: 'psi_memory_proc_ops' defined but not used [-Wunused-const-variable=]
      1355 | static const struct proc_ops psi_memory_proc_ops = {
           |                              ^~~~~~~~~~~~~~~~~~~
  kernel/sched/psi.c:1346:30: warning: 'psi_io_proc_ops' defined but not used [-Wunused-const-variable=]
      1346 | static const struct proc_ops psi_io_proc_ops = {
           |                              ^~~~~~~~~~~~~~~

Make definitions of these structures and related functions conditional
on CONFIG_PROC_FS config.

Link: https://lkml.kernel.org/r/20220119223940.787748-3-surenb@google.com
Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/psi.c |   79 +++++++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 38 deletions(-)

--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1082,44 +1082,6 @@ int psi_show(struct seq_file *m, struct
 	return 0;
 }
 
-static int psi_io_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_IO);
-}
-
-static int psi_memory_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_MEM);
-}
-
-static int psi_cpu_show(struct seq_file *m, void *v)
-{
-	return psi_show(m, &psi_system, PSI_CPU);
-}
-
-static int psi_open(struct file *file, int (*psi_show)(struct seq_file *, void *))
-{
-	if (file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
-
-	return single_open(file, psi_show, NULL);
-}
-
-static int psi_io_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_io_show);
-}
-
-static int psi_memory_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_memory_show);
-}
-
-static int psi_cpu_open(struct inode *inode, struct file *file)
-{
-	return psi_open(file, psi_cpu_show);
-}
-
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res)
 {
@@ -1278,6 +1240,45 @@ __poll_t psi_trigger_poll(void **trigger
 	return ret;
 }
 
+#ifdef CONFIG_PROC_FS
+static int psi_io_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_IO);
+}
+
+static int psi_memory_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_MEM);
+}
+
+static int psi_cpu_show(struct seq_file *m, void *v)
+{
+	return psi_show(m, &psi_system, PSI_CPU);
+}
+
+static int psi_open(struct file *file, int (*psi_show)(struct seq_file *, void *))
+{
+	if (file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE))
+		return -EPERM;
+
+	return single_open(file, psi_show, NULL);
+}
+
+static int psi_io_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_io_show);
+}
+
+static int psi_memory_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_memory_show);
+}
+
+static int psi_cpu_open(struct inode *inode, struct file *file)
+{
+	return psi_open(file, psi_cpu_show);
+}
+
 static ssize_t psi_write(struct file *file, const char __user *user_buf,
 			 size_t nbytes, enum psi_res res)
 {
@@ -1392,3 +1393,5 @@ static int __init psi_proc_init(void)
 	return 0;
 }
 module_init(psi_proc_init);
+
+#endif /* CONFIG_PROC_FS */


