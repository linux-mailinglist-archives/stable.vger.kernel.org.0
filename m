Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286D6328E4B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241596AbhCAT13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:27:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241551AbhCATYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:24:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 882ED6509B;
        Mon,  1 Mar 2021 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620001;
        bh=3kdEAUwMrV96dLyB5h7f1gwsz1KI6KtBnglQONXkQq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P53O0/V6d2cWDU6wuyx7LyPgTQ1Nm5Kam+ryrrYWh/M7Hh/E2YDT2TsNPse7wWYNC
         Alf1GE1kCshKlDP5sv+AzI4RfhsdRtc2TIHCODqOHkX7oUQrO13hWB94OJXWQDTW0q
         JJpcGGhDZTT7r/BpvSfItrPyIo4EnxdTXjAFBmGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 628/663] um: mm: check more comprehensively for stub changes
Date:   Mon,  1 Mar 2021 17:14:36 +0100
Message-Id: <20210301161212.922181446@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 47da29763ec9a153b9b685bff9db659e4e09e494 upstream.

If userspace tries to change the stub, we need to kill it,
because otherwise it can escape the virtual machine. In a
few cases the stub checks weren't good, e.g. if userspace
just tries to

	mmap(0x100000 - 0x1000, 0x3000, ...)

it could succeed to get a new private/anonymous mapping
replacing the stubs. Fix this by checking everywhere, and
checking for _overlap_, not just direct changes.

Cc: stable@vger.kernel.org
Fixes: 3963333fe676 ("uml: cover stubs with a VMA")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/kernel/tlb.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -125,6 +125,9 @@ static int add_mmap(unsigned long virt,
 	struct host_vm_op *last;
 	int fd = -1, ret = 0;
 
+	if (virt + len > STUB_START && virt < STUB_END)
+		return -EINVAL;
+
 	if (hvc->userspace)
 		fd = phys_mapping(phys, &offset);
 	else
@@ -162,7 +165,7 @@ static int add_munmap(unsigned long addr
 	struct host_vm_op *last;
 	int ret = 0;
 
-	if ((addr >= STUB_START) && (addr < STUB_END))
+	if (addr + len > STUB_START && addr < STUB_END)
 		return -EINVAL;
 
 	if (hvc->index != 0) {
@@ -192,6 +195,9 @@ static int add_mprotect(unsigned long ad
 	struct host_vm_op *last;
 	int ret = 0;
 
+	if (addr + len > STUB_START && addr < STUB_END)
+		return -EINVAL;
+
 	if (hvc->index != 0) {
 		last = &hvc->ops[hvc->index - 1];
 		if ((last->type == MPROTECT) &&
@@ -472,6 +478,10 @@ void flush_tlb_page(struct vm_area_struc
 	struct mm_id *mm_id;
 
 	address &= PAGE_MASK;
+
+	if (address >= STUB_START && address < STUB_END)
+		goto kill;
+
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
 		goto kill;


