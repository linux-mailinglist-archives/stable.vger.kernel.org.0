Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121E815F0A1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388067AbgBNRzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:55:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388295AbgBNP5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44B62222C4;
        Fri, 14 Feb 2020 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695854;
        bh=+Wg4Gw4fZ5TTS9SszO08Pg0ea8fhiVFTvIFd07PEKJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/W+fFUJNQWRi3b9ZkS6MCGNTvEt3IfIZumj82J+6TnoDpeiLW5Ajg49xtA2NCmhy
         2zHd3j2NpqYbEEkyhD8k9wRpf9a8DSfI0PgI0h6hUBm7nSGv9gGMAf0y/r8J1pC/MB
         MPFql1HHp9SmD4Qjs1tkjU9lN43B+8PvKGNKC4eg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 403/542] x86/apic/uv: Avoid unused variable warning
Date:   Fri, 14 Feb 2020 10:46:35 -0500
Message-Id: <20200214154854.6746-403-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d0b7788804482b2689946cd8d910ac3e03126c8d ]

When CONFIG_PROC_FS is disabled, the compiler warns about an unused
variable:

arch/x86/kernel/apic/x2apic_uv_x.c: In function 'uv_setup_proc_files':
arch/x86/kernel/apic/x2apic_uv_x.c:1546:8: error: unused variable 'name' [-Werror=unused-variable]
  char *name = hubless ? "hubless" : "hubbed";

Simplify the code so this variable is no longer needed.

Fixes: 8785968bce1c ("x86/platform/uv: Add UV Hubbed/Hubless Proc FS Files")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20191212140419.315264-1-arnd@arndb.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c | 43 +++++-------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index d5b51a740524d..ad53b2abc859f 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -1493,65 +1493,34 @@ static void check_efi_reboot(void)
 }
 
 /* Setup user proc fs files */
-static int proc_hubbed_show(struct seq_file *file, void *data)
+static int __maybe_unused proc_hubbed_show(struct seq_file *file, void *data)
 {
 	seq_printf(file, "0x%x\n", uv_hubbed_system);
 	return 0;
 }
 
-static int proc_hubless_show(struct seq_file *file, void *data)
+static int __maybe_unused proc_hubless_show(struct seq_file *file, void *data)
 {
 	seq_printf(file, "0x%x\n", uv_hubless_system);
 	return 0;
 }
 
-static int proc_oemid_show(struct seq_file *file, void *data)
+static int __maybe_unused proc_oemid_show(struct seq_file *file, void *data)
 {
 	seq_printf(file, "%s/%s\n", oem_id, oem_table_id);
 	return 0;
 }
 
-static int proc_hubbed_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_hubbed_show, (void *)NULL);
-}
-
-static int proc_hubless_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_hubless_show, (void *)NULL);
-}
-
-static int proc_oemid_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_oemid_show, (void *)NULL);
-}
-
-/* (struct is "non-const" as open function is set at runtime) */
-static struct file_operations proc_version_fops = {
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations proc_oemid_fops = {
-	.open		= proc_oemid_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static __init void uv_setup_proc_files(int hubless)
 {
 	struct proc_dir_entry *pde;
-	char *name = hubless ? "hubless" : "hubbed";
 
 	pde = proc_mkdir(UV_PROC_NODE, NULL);
-	proc_create("oemid", 0, pde, &proc_oemid_fops);
-	proc_create(name, 0, pde, &proc_version_fops);
+	proc_create_single("oemid", 0, pde, proc_oemid_show);
 	if (hubless)
-		proc_version_fops.open = proc_hubless_open;
+		proc_create_single("hubless", 0, pde, proc_hubless_show);
 	else
-		proc_version_fops.open = proc_hubbed_open;
+		proc_create_single("hubbed", 0, pde, proc_hubbed_show);
 }
 
 /* Initialize UV hubless systems */
-- 
2.20.1

