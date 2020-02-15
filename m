Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A9215FE9C
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 14:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgBONfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 08:35:06 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57224 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgBONfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Feb 2020 08:35:06 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1j2xb2-00084w-MP; Sat, 15 Feb 2020 14:35:00 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 091391C205F;
        Sat, 15 Feb 2020 14:35:00 +0100 (CET)
Date:   Sat, 15 Feb 2020 13:34:59 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/urgent] x86/mce/amd: Fix kobject lifetime
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200214082801.13836-1-bp@alien8.de>
References: <20200214082801.13836-1-bp@alien8.de>
MIME-Version: 1.0
Message-ID: <158177369962.13786.16098407006257585201.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the ras/urgent branch of tip:

Commit-ID:     51dede9c05df2b78acd6dcf6a17d21f0877d2d7b
Gitweb:        https://git.kernel.org/tip/51dede9c05df2b78acd6dcf6a17d21f0877d2d7b
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 13 Feb 2020 19:01:34 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 14 Feb 2020 09:28:31 +01:00

x86/mce/amd: Fix kobject lifetime

Accessing the MCA thresholding controls in sysfs concurrently with CPU
hotplug can lead to a couple of KASAN-reported issues:

  BUG: KASAN: use-after-free in sysfs_file_ops+0x155/0x180
  Read of size 8 at addr ffff888367578940 by task grep/4019

and

  BUG: KASAN: use-after-free in show_error_count+0x15c/0x180
  Read of size 2 at addr ffff888368a05514 by task grep/4454

for example. Both result from the fact that the threshold block
creation/teardown code frees the descriptor memory itself instead of
defining proper ->release function and leaving it to the driver core to
take care of that, after all sysfs accesses have completed.

Do that and get rid of the custom freeing code, fixing the above UAFs in
the process.

  [ bp: write commit message. ]

Fixes: 95268664390b ("[PATCH] x86_64: mce_amd support for family 0x10 processors")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200214082801.13836-1-bp@alien8.de
---
 arch/x86/kernel/cpu/mce/amd.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index e7313e5..52de616 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1163,9 +1163,12 @@ static const struct sysfs_ops threshold_ops = {
 	.store			= store,
 };
 
+static void threshold_block_release(struct kobject *kobj);
+
 static struct kobj_type threshold_ktype = {
 	.sysfs_ops		= &threshold_ops,
 	.default_attrs		= default_attrs,
+	.release		= threshold_block_release,
 };
 
 static const char *get_name(unsigned int bank, struct threshold_block *b)
@@ -1367,8 +1370,12 @@ static int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	return err;
 }
 
-static void deallocate_threshold_block(unsigned int cpu,
-						 unsigned int bank)
+static void threshold_block_release(struct kobject *kobj)
+{
+	kfree(to_block(kobj));
+}
+
+static void deallocate_threshold_block(unsigned int cpu, unsigned int bank)
 {
 	struct threshold_block *pos = NULL;
 	struct threshold_block *tmp = NULL;
@@ -1378,13 +1385,11 @@ static void deallocate_threshold_block(unsigned int cpu,
 		return;
 
 	list_for_each_entry_safe(pos, tmp, &head->blocks->miscj, miscj) {
-		kobject_put(&pos->kobj);
 		list_del(&pos->miscj);
-		kfree(pos);
+		kobject_put(&pos->kobj);
 	}
 
-	kfree(per_cpu(threshold_banks, cpu)[bank]->blocks);
-	per_cpu(threshold_banks, cpu)[bank]->blocks = NULL;
+	kobject_put(&head->blocks->kobj);
 }
 
 static void __threshold_remove_blocks(struct threshold_bank *b)
