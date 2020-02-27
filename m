Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1423C171A46
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbgB0NwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731491AbgB0NwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 349952084E;
        Thu, 27 Feb 2020 13:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811530;
        bh=4PA2FXlDRYSxZN4Qkmz16p9cSWxza+zkjDl4XotCPrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gDO4EhZ5bHnXU1zDMmmfLSop9ZvIUqvDweHh4GOLGf1g4RSFm3AxTo/GPR7HBiFu
         JB1Ng4OIrH8u7VhkZcdWrw2BMrd9hkVOQ4fAqQIAAgoWg/LYwCyW9g3ZJ/4VdrVlh2
         flzUZBQ6UDkZDtVIQW38yHDB+MjNGauglWyoVId4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.9 130/165] x86/mce/amd: Fix kobject lifetime
Date:   Thu, 27 Feb 2020 14:36:44 +0100
Message-Id: <20200227132250.007861889@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 51dede9c05df2b78acd6dcf6a17d21f0877d2d7b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -846,9 +846,12 @@ static const struct sysfs_ops threshold_
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
@@ -1073,8 +1076,12 @@ static int threshold_create_device(unsig
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
@@ -1084,13 +1091,11 @@ static void deallocate_threshold_block(u
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


