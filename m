Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD5C171B3B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732769AbgB0OAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732702AbgB0OA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:00:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CCF520578;
        Thu, 27 Feb 2020 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812029;
        bh=1GuQ5GGLe50dB+4PbVvgIhOVG2Qc5PRkJxTtW2x6mt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfJglhbaCIab0Xq7QWfQQLOrOeIZXG5QxIP0nBcI1bY9+mirXcdiH1ucDhkqa+s77
         rRI0iRUadiyAKr0Hf6qW8qTytFgM4v1nJZvPRe2Elrwe4nE5YwAnSwD/HEYYCkd2ap
         9Js/0BacPPRwUsnANneXjIbFaxCnnkO3a+z+kC+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 192/237] x86/mce/amd: Fix kobject lifetime
Date:   Thu, 27 Feb 2020 14:36:46 +0100
Message-Id: <20200227132310.443287004@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
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
@@ -1116,9 +1116,12 @@ static const struct sysfs_ops threshold_
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
@@ -1320,8 +1323,12 @@ static int threshold_create_bank(unsigne
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
@@ -1331,13 +1338,11 @@ static void deallocate_threshold_block(u
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


