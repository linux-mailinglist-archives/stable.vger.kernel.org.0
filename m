Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8991139FA9F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 17:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhFHP25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhFHP25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 11:28:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8E6C061574;
        Tue,  8 Jun 2021 08:27:03 -0700 (PDT)
Date:   Tue, 08 Jun 2021 15:26:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623166020;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WD6WzbVvKHAouB0+n4t355RPUO7++TOwM69JL7NosEM=;
        b=n59MJXQyc+HMUmDhCmB8JlDa+8QluRo7+SEYh/DOZv/AB0V8fsBU68CG9UKV3xOQWbEDKe
        ZpOcRrjOeTYla5P+79pwVBp/DB9NtMehr7FrFYmMljSh+xrJr3SrVhTgl7vYg/lHdVwi9o
        2opdo1bGkf3j4jxtseD8VdfCKhdkyOLPblEw6HACr0vV5LHt7KxtYjQJZrGq6VjlUgKnZP
        2mQ7n/0aD+3+KpPdWppt7Z97aE+hxlymjDLA2+OZlU28aQRM6FNqxtSISc6+oruzHtXd+F
        FTxFOeiHNz0LVrDkSbmccntnNhymtZcG9I1seiZYZ6GnpUUOsv2sq3MGIh9Jmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623166020;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WD6WzbVvKHAouB0+n4t355RPUO7++TOwM69JL7NosEM=;
        b=H/n0abvCYuMyfVy6WhhJMdu0F5D5EN98XuASvrQ8VhpmnHW0LM6prtXmGBqIzwkT7U3A4/
        9pjmsVdAMDy2lpAA==
From:   "tip-bot2 for Tom Lendacky" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/ioremap: Map EFI-reserved memory as encrypted for SEV
Cc:     Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210608095439.12668-2-joro@8bytes.org>
References: <20210608095439.12668-2-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <162316601954.29796.2695101519177924974.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     8d651ee9c71bb12fc0c8eb2786b66cbe5aa3e43b
Gitweb:        https://git.kernel.org/tip/8d651ee9c71bb12fc0c8eb2786b66cbe5aa3e43b
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Tue, 08 Jun 2021 11:54:33 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 08 Jun 2021 16:26:55 +02:00

x86/ioremap: Map EFI-reserved memory as encrypted for SEV

Some drivers require memory that is marked as EFI boot services
data. In order for this memory to not be re-used by the kernel
after ExitBootServices(), efi_mem_reserve() is used to preserve it
by inserting a new EFI memory descriptor and marking it with the
EFI_MEMORY_RUNTIME attribute.

Under SEV, memory marked with the EFI_MEMORY_RUNTIME attribute needs to
be mapped encrypted by Linux, otherwise the kernel might crash at boot
like below:

  EFI Variables Facility v0.08 2004-May-17
  general protection fault, probably for non-canonical address 0x3597688770a868b2: 0000 [#1] SMP NOPTI
  CPU: 13 PID: 1 Comm: swapper/0 Not tainted 5.12.4-2-default #1 openSUSE Tumbleweed
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:efi_mokvar_entry_next
  [...]
  Call Trace:
   efi_mokvar_sysfs_init
   ? efi_mokvar_table_init
   do_one_initcall
   ? __kmalloc
   kernel_init_freeable
   ? rest_init
   kernel_init
   ret_from_fork

Expand the __ioremap_check_other() function to additionally check for
this other type of boot data reserved at runtime and indicate that it
should be mapped encrypted for an SEV guest.

 [ bp: Massage commit message. ]

Fixes: 58c909022a5a ("efi: Support for MOK variable config table")
Reported-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
Cc: <stable@vger.kernel.org> # 5.10+
Link: https://lkml.kernel.org/r/20210608095439.12668-2-joro@8bytes.org
---
 arch/x86/mm/ioremap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12c686c..60ade7d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -118,7 +118,9 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA)
+	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA ||
+	    (efi_mem_type(addr) == EFI_BOOT_SERVICES_DATA &&
+	     efi_mem_attributes(addr) & EFI_MEMORY_RUNTIME))
 		desc->flags |= IORES_MAP_ENCRYPTED;
 }
 
