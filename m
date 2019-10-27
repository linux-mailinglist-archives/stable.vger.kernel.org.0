Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CCBE68C5
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbfJ0VcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730682AbfJ0VPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:15:44 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC91214AF;
        Sun, 27 Oct 2019 21:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210943;
        bh=vQADRlEHKZojB9aIFHoplWCEzeRkENFkqS77WUullxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkhS3pNX7wyqizcQYgNeYAnaS2uu1SjEmn2fDPbcPax/2oVNDm7j0xJfsuxmHu9Yu
         jyG16MEW9C7/B+xvGUOG5/QNdZCbMAJ7zq7IWMDePAk6XvOmLRdQVXbV4kpUM8D58h
         tXHgIV+5yArJA6hKH/8UKN6jMIPg9G1kafZ6d8MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 69/93] mm/memory-failure: poison read receives SIGKILL instead of SIGBUS if mmaped more than once
Date:   Sun, 27 Oct 2019 22:01:21 +0100
Message-Id: <20191027203308.498399326@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Chu <jane.chu@oracle.com>

commit 3d7fed4ad8ccb691d217efbb0f934e6a4df5ef91 upstream.

Mmap /dev/dax more than once, then read the poison location using
address from one of the mappings.  The other mappings due to not having
the page mapped in will cause SIGKILLs delivered to the process.
SIGKILL succeeds over SIGBUS, so user process loses the opportunity to
handle the UE.

Although one may add MAP_POPULATE to mmap(2) to work around the issue,
MAP_POPULATE makes mapping 128GB of pmem several magnitudes slower, so
isn't always an option.

Details -

  ndctl inject-error --block=10 --count=1 namespace6.0

  ./read_poison -x dax6.0 -o 5120 -m 2
  mmaped address 0x7f5bb6600000
  mmaped address 0x7f3cf3600000
  doing local read at address 0x7f3cf3601400
  Killed

Console messages in instrumented kernel -

  mce: Uncorrected hardware memory error in user-access at edbe201400
  Memory failure: tk->addr = 7f5bb6601000
  Memory failure: address edbe201: call dev_pagemap_mapping_shift
  dev_pagemap_mapping_shift: page edbe201: no PUD
  Memory failure: tk->size_shift == 0
  Memory failure: Unable to find user space address edbe201 in read_poison
  Memory failure: tk->addr = 7f3cf3601000
  Memory failure: address edbe201: call dev_pagemap_mapping_shift
  Memory failure: tk->size_shift = 21
  Memory failure: 0xedbe201: forcibly killing read_poison:22434 because of failure to unmap corrupted page
    => to deliver SIGKILL
  Memory failure: 0xedbe201: Killing read_poison:22434 due to hardware memory corruption
    => to deliver SIGBUS

Link: http://lkml.kernel.org/r/1565112345-28754-3-git-send-email-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory-failure.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -202,7 +202,6 @@ struct to_kill {
 	struct task_struct *tsk;
 	unsigned long addr;
 	short size_shift;
-	char addr_valid;
 };
 
 /*
@@ -327,22 +326,27 @@ static void add_to_kill(struct task_stru
 		}
 	}
 	tk->addr = page_address_in_vma(p, vma);
-	tk->addr_valid = 1;
 	if (is_zone_device_page(p))
 		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
 	else
 		tk->size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
 
 	/*
-	 * In theory we don't have to kill when the page was
-	 * munmaped. But it could be also a mremap. Since that's
-	 * likely very rare kill anyways just out of paranoia, but use
-	 * a SIGKILL because the error is not contained anymore.
+	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
+	 * "tk->size_shift" is always non-zero for !is_zone_device_page(),
+	 * so "tk->size_shift == 0" effectively checks no mapping on
+	 * ZONE_DEVICE. Indeed, when a devdax page is mmapped N times
+	 * to a process' address space, it's possible not all N VMAs
+	 * contain mappings for the page, but at least one VMA does.
+	 * Only deliver SIGBUS with payload derived from the VMA that
+	 * has a mapping for the page.
 	 */
-	if (tk->addr == -EFAULT || tk->size_shift == 0) {
+	if (tk->addr == -EFAULT) {
 		pr_info("Memory failure: Unable to find user space address %lx in %s\n",
 			page_to_pfn(p), tsk->comm);
-		tk->addr_valid = 0;
+	} else if (tk->size_shift == 0) {
+		kfree(tk);
+		return;
 	}
 	get_task_struct(tsk);
 	tk->tsk = tsk;
@@ -369,7 +373,7 @@ static void kill_procs(struct list_head
 			 * make sure the process doesn't catch the
 			 * signal and then access the memory. Just kill it.
 			 */
-			if (fail || tk->addr_valid == 0) {
+			if (fail || tk->addr == -EFAULT) {
 				pr_err("Memory failure: %#lx: forcibly killing %s:%d because of failure to unmap corrupted page\n",
 				       pfn, tk->tsk->comm, tk->tsk->pid);
 				do_send_sig_info(SIGKILL, SEND_SIG_PRIV,


