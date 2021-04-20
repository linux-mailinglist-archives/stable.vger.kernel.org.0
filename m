Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B620365EE6
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 20:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhDTSBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 14:01:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54324 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDTSBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 14:01:16 -0400
Date:   Tue, 20 Apr 2021 18:00:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618941643;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lB8Nr79VQcJ0XrHrhfDkVzK+uESNxrArLq8LgVXCQZA=;
        b=RQcZ0rm//xb+p/bl3ShgqGDi3NZOkeOHrzPie4dW/92IewBMuU1/QT04BoT+0NPPx71KoO
        0VHMTq4Vq3VfnyV/tSEfu2meMhSO1nVghr1TvU3wLNoKc2fER2m3pFkGgSSXrYn/FJJeK6
        iKSJxvcKyMQA2lXjgboLPEVdg+d35aWjkUnTfsFvfIHSaV5Np0a2+s68/pRNLcLjGAmjZG
        l9S2zIoUINT58uUwvPyg0BCu/aOEm4c8JMg9JjcwL0KTkaqemELvxAKAIVjlQ5bMAM0Jj5
        8VJNsixlTKjNzvzG3Yq7so+97FsqXjZOjen8neq8Oa6lT2zgnUKLAiXlbMg7sw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618941643;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lB8Nr79VQcJ0XrHrhfDkVzK+uESNxrArLq8LgVXCQZA=;
        b=PtRb2w84N4arpBl578nhmM7gr3ka08KQpgrmm3kJEAcrzv57DP82SmaGAgKWHKpOr/sD2u
        486kia52A4X2HfBw==
From:   "tip-bot2 for Mike Galbraith" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/crash: Fix crash_setup_memmap_entries()
 out-of-bounds access
Cc:     Mike Galbraith <efault@gmx.de>, Borislav Petkov <bp@suse.de>,
        Dave Young <dyoung@redhat.com>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <725fa3dc1da2737f0f6188a1a9701bead257ea9d.camel@gmx.de>
References: <725fa3dc1da2737f0f6188a1a9701bead257ea9d.camel@gmx.de>
MIME-Version: 1.0
Message-ID: <161894164234.29796.8745971840518585404.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     5849cdf8c120e3979c57d34be55b92d90a77a47e
Gitweb:        https://git.kernel.org/tip/5849cdf8c120e3979c57d34be55b92d90a77a47e
Author:        Mike Galbraith <efault@gmx.de>
AuthorDate:    Fri, 16 Apr 2021 14:02:07 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 20 Apr 2021 17:32:46 +02:00

x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

Commit in Fixes: added support for kexec-ing a kernel on panic using a
new system call. As part of it, it does prepare a memory map for the new
kernel.

However, while doing so, it wrongly accesses memory it has not
allocated: it accesses the first element of the cmem->ranges[] array in
memmap_exclude_ranges() but it has not allocated the memory for it in
crash_setup_memmap_entries(). As KASAN reports:

  BUG: KASAN: vmalloc-out-of-bounds in crash_setup_memmap_entries+0x17e/0x3a0
  Write of size 8 at addr ffffc90000426008 by task kexec/1187

  (gdb) list *crash_setup_memmap_entries+0x17e
  0xffffffff8107cafe is in crash_setup_memmap_entries (arch/x86/kernel/crash.c:322).
  317                                      unsigned long long mend)
  318     {
  319             unsigned long start, end;
  320
  321             cmem->ranges[0].start = mstart;
  322             cmem->ranges[0].end = mend;
  323             cmem->nr_ranges = 1;
  324
  325             /* Exclude elf header region */
  326             start = image->arch.elf_load_addr;
  (gdb)

Make sure the ranges array becomes a single element allocated.

 [ bp: Write a proper commit message. ]

Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/725fa3dc1da2737f0f6188a1a9701bead257ea9d.camel@gmx.de
---
 arch/x86/kernel/crash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a8f3af2..b1deacb 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -337,7 +337,7 @@ int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
 	struct crash_memmap_data cmd;
 	struct crash_mem *cmem;
 
-	cmem = vzalloc(sizeof(struct crash_mem));
+	cmem = vzalloc(struct_size(cmem, ranges, 1));
 	if (!cmem)
 		return -ENOMEM;
 
