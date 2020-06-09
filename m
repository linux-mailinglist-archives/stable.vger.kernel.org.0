Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E024C1F4486
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbgFISF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731021AbgFIRvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:51:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEBC420734;
        Tue,  9 Jun 2020 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725100;
        bh=ccjtb1exREAQABGA30nQpiXVzk+9HpQ22UP3vU8g8vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lH5I65G/LBMdBe4pqcRWk1m9d9AE4XnnQpMN6SiOq5fksmEV9j5dVfYC0y6cmRhx4
         HdTB216pUaZTA4cTeAhifOsnGovBTvuPilSmN5dvDj0W0xbIl4vVrKNFNooCqYeE+K
         AqExG8S/gnqwc3yoHN86Rav8+JzMfYchRyRLDvw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4.19 24/25] uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly aligned
Date:   Tue,  9 Jun 2020 19:45:14 +0200
Message-Id: <20200609174051.488794266@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174048.576094775@linuxfoundation.org>
References: <20200609174048.576094775@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 013b2deba9a6b80ca02f4fafd7dedf875e9b4450 upstream.

uprobe_write_opcode() must not cross page boundary; prepare_uprobe()
relies on arch_uprobe_analyze_insn() which should validate "vaddr" but
some architectures (csky, s390, and sparc) don't do this.

We can remove the BUG_ON() check in prepare_uprobe() and validate the
offset early in __uprobe_register(). The new IS_ALIGNED() check matches
the alignment check in arch_prepare_kprobe() on supported architectures,
so I think that all insns must be aligned to UPROBE_SWBP_INSN_SIZE.

Another problem is __update_ref_ctr() which was wrong from the very
beginning, it can read/write outside of kmap'ed page unless "vaddr" is
aligned to sizeof(short), __uprobe_register() should check this too.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/uprobes.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -612,10 +612,6 @@ static int prepare_uprobe(struct uprobe
 	if (ret)
 		goto out;
 
-	/* uprobe_write_opcode() assumes we don't cross page boundary */
-	BUG_ON((uprobe->offset & ~PAGE_MASK) +
-			UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
-
 	smp_wmb(); /* pairs with the smp_rmb() in handle_swbp() */
 	set_bit(UPROBE_COPY_INSN, &uprobe->flags);
 
@@ -911,6 +907,15 @@ static int __uprobe_register(struct inod
 	if (offset > i_size_read(inode))
 		return -EINVAL;
 
+	/*
+	 * This ensures that copy_from_page(), copy_to_page() and
+	 * __update_ref_ctr() can't cross page boundary.
+	 */
+	if (!IS_ALIGNED(offset, UPROBE_SWBP_INSN_SIZE))
+		return -EINVAL;
+	if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
+		return -EINVAL;
+
  retry:
 	uprobe = alloc_uprobe(inode, offset);
 	if (!uprobe)
@@ -1708,6 +1713,9 @@ static int is_trap_at_addr(struct mm_str
 	uprobe_opcode_t opcode;
 	int result;
 
+	if (WARN_ON_ONCE(!IS_ALIGNED(vaddr, UPROBE_SWBP_INSN_SIZE)))
+		return -EINVAL;
+
 	pagefault_disable();
 	result = __get_user(opcode, (uprobe_opcode_t __user *)vaddr);
 	pagefault_enable();


