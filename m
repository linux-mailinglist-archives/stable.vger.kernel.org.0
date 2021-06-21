Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B010B3AF086
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhFUQuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhFUQrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B66AC61418;
        Mon, 21 Jun 2021 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293217;
        bh=Kx5gsh0tLRYTOoK4Dnww7+GDnHFfBKKOzu5ZzMlGyaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmdFjhXzo4gm3PEtW6kek8xuZyIxImHSzaitcg06Ki3M/+vqFm+zj5dEqOCEZTxF6
         4xEwM0Yj01tTgyr8r2JDScMViydhGvqt5kFGXwAjAVzRA7xyE0Z1xz8YoZfgbY396d
         59rGx3GAh1RcFqQ0EBLsNm83RuU4ukDCl90IHHAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.12 142/178] x86/ioremap: Map EFI-reserved memory as encrypted for SEV
Date:   Mon, 21 Jun 2021 18:15:56 +0200
Message-Id: <20210621154927.604089185@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 8d651ee9c71bb12fc0c8eb2786b66cbe5aa3e43b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/ioremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -118,7 +118,9 @@ static void __ioremap_check_other(resour
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA)
+	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA ||
+	    (efi_mem_type(addr) == EFI_BOOT_SERVICES_DATA &&
+	     efi_mem_attributes(addr) & EFI_MEMORY_RUNTIME))
 		desc->flags |= IORES_MAP_ENCRYPTED;
 }
 


