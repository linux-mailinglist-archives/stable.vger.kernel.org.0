Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAF073DF5
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390482AbfGXTpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390912AbfGXTpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:45:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15CCD217D4;
        Wed, 24 Jul 2019 19:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997504;
        bh=DaApVQO7VGpeXUjJist9KkOPOOIL6bB+stuCL0bLK/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGSZhHF8m1TqG0we+kG5ORC0IgqCPntB/MyTXRK+K8qJXdxGqQrsKDQYldgT1Jli5
         BE4WMNR8rCQAu/PZ6rnsle7S8qftZLdY/f2f3SQCSw2LDOzHIPxiDCKrCKhhS3d49u
         Sy2IH+QFwJkv9p/Pr0ocFX86tL4ql/KHwUpPOC80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 047/371] media: saa7164: fix remove_proc_entry warning
Date:   Wed, 24 Jul 2019 21:16:39 +0200
Message-Id: <20190724191728.235051512@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 50710eeefbc1ed25375942aad0c4d1eb4af0f330 ]

if saa7164_proc_create() fails, saa7164_fini() will trigger a warning,

name 'saa7164'
WARNING: CPU: 1 PID: 6311 at fs/proc/generic.c:672 remove_proc_entry+0x1e8/0x3a0
  ? remove_proc_entry+0x1e8/0x3a0
  ? try_stop_module+0x7b/0x240
  ? proc_readdir+0x70/0x70
  ? rcu_read_lock_sched_held+0xd7/0x100
  saa7164_fini+0x13/0x1f [saa7164]
  __x64_sys_delete_module+0x30c/0x480
  ? __ia32_sys_delete_module+0x480/0x480
  ? __x64_sys_clock_gettime+0x11e/0x1c0
  ? __x64_sys_timer_create+0x1a0/0x1a0
  ? trace_hardirqs_off_caller+0x40/0x180
  ? do_syscall_64+0x18/0x450
  do_syscall_64+0x9f/0x450
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix it by checking the return of proc_create_single() before
calling remove_proc_entry().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: use 0444 instead of S_IRUGO]
[hverkuil-cisco@xs4all.nl: use pr_info instead of KERN_INFO]
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7164/saa7164-core.c | 33 ++++++++++++++++--------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 05f25c9bb308..f5ad3cf207d3 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1122,16 +1122,25 @@ static int saa7164_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static struct proc_dir_entry *saa7164_pe;
+
 static int saa7164_proc_create(void)
 {
-	struct proc_dir_entry *pe;
-
-	pe = proc_create_single("saa7164", S_IRUGO, NULL, saa7164_proc_show);
-	if (!pe)
+	saa7164_pe = proc_create_single("saa7164", 0444, NULL, saa7164_proc_show);
+	if (!saa7164_pe)
 		return -ENOMEM;
 
 	return 0;
 }
+
+static void saa7164_proc_destroy(void)
+{
+	if (saa7164_pe)
+		remove_proc_entry("saa7164", NULL);
+}
+#else
+static int saa7164_proc_create(void) { return 0; }
+static void saa7164_proc_destroy(void) {}
 #endif
 
 static int saa7164_thread_function(void *data)
@@ -1503,19 +1512,21 @@ static struct pci_driver saa7164_pci_driver = {
 
 static int __init saa7164_init(void)
 {
-	printk(KERN_INFO "saa7164 driver loaded\n");
+	int ret = pci_register_driver(&saa7164_pci_driver);
+
+	if (ret)
+		return ret;
 
-#ifdef CONFIG_PROC_FS
 	saa7164_proc_create();
-#endif
-	return pci_register_driver(&saa7164_pci_driver);
+
+	pr_info("saa7164 driver loaded\n");
+
+	return 0;
 }
 
 static void __exit saa7164_fini(void)
 {
-#ifdef CONFIG_PROC_FS
-	remove_proc_entry("saa7164", NULL);
-#endif
+	saa7164_proc_destroy();
 	pci_unregister_driver(&saa7164_pci_driver);
 }
 
-- 
2.20.1



