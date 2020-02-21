Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF39E1671AD
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgBUH4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbgBUH4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:56:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D020020658;
        Fri, 21 Feb 2020 07:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271776;
        bh=+Wg4Gw4fZ5TTS9SszO08Pg0ea8fhiVFTvIFd07PEKJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnHtnV/n+FGdOtkzqbKahhrPST57UfCNgXo+XXECILq/SxZbA/hWJE8WpaDPAkI96
         O089uAlAT5BTthmpj+mKVNoYEtP5P4fk/0wuhVGLxebR/g+GwYYKEIOFK6uc0+QY68
         fS52Y/pt95Ew3+VKV09HA3Da1UGDyUyTGWdxX0nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 294/399] x86/apic/uv: Avoid unused variable warning
Date:   Fri, 21 Feb 2020 08:40:19 +0100
Message-Id: <20200221072430.340899179@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



