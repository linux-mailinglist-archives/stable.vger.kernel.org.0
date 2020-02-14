Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D62615D3CC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 09:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgBNI2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 03:28:16 -0500
Received: from mail.skyhub.de ([5.9.137.197]:58704 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgBNI2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 03:28:16 -0500
Received: from zn.tnic (p200300EC2F0D5A00F0C2F03C7F1C4548.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5a00:f0c2:f03c:7f1c:4548])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C77D31EC0CED;
        Fri, 14 Feb 2020 09:28:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1581668894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=MNckfJpwVyGfFYyqhihTbOIjDv4FZFHc+akefT9PVNg=;
        b=rQKoRIcuFNvqymE3FxVdj2FuNqWZPJvqFhMxDMtyCkcJk5o6LtdCqtqqA1XyXuckSO8Wu2
        9LANngFOnaqFNLa5kYKyBKuvt7ynjvYPdkH6sxoDhsQfeDKHSURCI9t2eAyePaklF0mGV3
        0rj3rIZnfIjaIZagPl8Pny+CWWVESGw=
From:   Borislav Petkov <bp@alien8.de>
To:     X86 ML <x86@kernel.org>
Cc:     Yazen Ghannam <Yazen.Ghannam@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: [PATCH] x86/mce/amd: Fix kobject lifetime
Date:   Fri, 14 Feb 2020 09:28:01 +0100
Message-Id: <20200214082801.13836-1-bp@alien8.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

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
---
 arch/x86/kernel/cpu/mce/amd.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index e7313e5c497c..52de616a8065 100644
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
-- 
2.21.0

