Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95893AAAD
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfFIQrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbfFIQrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF1C92081C;
        Sun,  9 Jun 2019 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098821;
        bh=dXAI8+J7R8bpRX9mH8IiBBnSgPD7BhNOjOyyBKlp42c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYdoVknNyxlXgAmlxJc6b7ybWzmc2EgFtIC8Tb10gYYy4cUl80W4k4HJlh9CaPRyl
         nRuIpukCSA0cQ1CsUBaQQYqpINaAleschz9TL45bvW3qzl/8iMW+Ja90zUSDsiBL75
         MwoldrJ5Wdb2ALlm+vTiliAHKvOpb6Ga4dNk5Sso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 40/70] x86/insn-eval: Fix use-after-free access to LDT entry
Date:   Sun,  9 Jun 2019 18:41:51 +0200
Message-Id: <20190609164130.597045549@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit de9f869616dd95e95c00bdd6b0fcd3421e8a4323 upstream.

get_desc() computes a pointer into the LDT while holding a lock that
protects the LDT from being freed, but then drops the lock and returns the
(now potentially dangling) pointer to its caller.

Fix it by giving the caller a copy of the LDT entry instead.

Fixes: 670f928ba09b ("x86/insn-eval: Add utility function to get segment descriptor")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/lib/insn-eval.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -557,7 +557,8 @@ static int get_reg_offset_16(struct insn
 }
 
 /**
- * get_desc() - Obtain pointer to a segment descriptor
+ * get_desc() - Obtain contents of a segment descriptor
+ * @out:	Segment descriptor contents on success
  * @sel:	Segment selector
  *
  * Given a segment selector, obtain a pointer to the segment descriptor.
@@ -565,18 +566,18 @@ static int get_reg_offset_16(struct insn
  *
  * Returns:
  *
- * Pointer to segment descriptor on success.
+ * True on success, false on failure.
  *
  * NULL on error.
  */
-static struct desc_struct *get_desc(unsigned short sel)
+static bool get_desc(struct desc_struct *out, unsigned short sel)
 {
 	struct desc_ptr gdt_desc = {0, 0};
 	unsigned long desc_base;
 
 #ifdef CONFIG_MODIFY_LDT_SYSCALL
 	if ((sel & SEGMENT_TI_MASK) == SEGMENT_LDT) {
-		struct desc_struct *desc = NULL;
+		bool success = false;
 		struct ldt_struct *ldt;
 
 		/* Bits [15:3] contain the index of the desired entry. */
@@ -584,12 +585,14 @@ static struct desc_struct *get_desc(unsi
 
 		mutex_lock(&current->active_mm->context.lock);
 		ldt = current->active_mm->context.ldt;
-		if (ldt && sel < ldt->nr_entries)
-			desc = &ldt->entries[sel];
+		if (ldt && sel < ldt->nr_entries) {
+			*out = ldt->entries[sel];
+			success = true;
+		}
 
 		mutex_unlock(&current->active_mm->context.lock);
 
-		return desc;
+		return success;
 	}
 #endif
 	native_store_gdt(&gdt_desc);
@@ -604,9 +607,10 @@ static struct desc_struct *get_desc(unsi
 	desc_base = sel & ~(SEGMENT_RPL_MASK | SEGMENT_TI_MASK);
 
 	if (desc_base > gdt_desc.size)
-		return NULL;
+		return false;
 
-	return (struct desc_struct *)(gdt_desc.address + desc_base);
+	*out = *(struct desc_struct *)(gdt_desc.address + desc_base);
+	return true;
 }
 
 /**
@@ -628,7 +632,7 @@ static struct desc_struct *get_desc(unsi
  */
 unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx)
 {
-	struct desc_struct *desc;
+	struct desc_struct desc;
 	short sel;
 
 	sel = get_segment_selector(regs, seg_reg_idx);
@@ -666,11 +670,10 @@ unsigned long insn_get_seg_base(struct p
 	if (!sel)
 		return -1L;
 
-	desc = get_desc(sel);
-	if (!desc)
+	if (!get_desc(&desc, sel))
 		return -1L;
 
-	return get_desc_base(desc);
+	return get_desc_base(&desc);
 }
 
 /**
@@ -692,7 +695,7 @@ unsigned long insn_get_seg_base(struct p
  */
 static unsigned long get_seg_limit(struct pt_regs *regs, int seg_reg_idx)
 {
-	struct desc_struct *desc;
+	struct desc_struct desc;
 	unsigned long limit;
 	short sel;
 
@@ -706,8 +709,7 @@ static unsigned long get_seg_limit(struc
 	if (!sel)
 		return 0;
 
-	desc = get_desc(sel);
-	if (!desc)
+	if (!get_desc(&desc, sel))
 		return 0;
 
 	/*
@@ -716,8 +718,8 @@ static unsigned long get_seg_limit(struc
 	 * not tested when checking the segment limits. In practice,
 	 * this means that the segment ends in (limit << 12) + 0xfff.
 	 */
-	limit = get_desc_limit(desc);
-	if (desc->g)
+	limit = get_desc_limit(&desc);
+	if (desc.g)
 		limit = (limit << 12) + 0xfff;
 
 	return limit;
@@ -741,7 +743,7 @@ static unsigned long get_seg_limit(struc
  */
 int insn_get_code_seg_params(struct pt_regs *regs)
 {
-	struct desc_struct *desc;
+	struct desc_struct desc;
 	short sel;
 
 	if (v8086_mode(regs))
@@ -752,8 +754,7 @@ int insn_get_code_seg_params(struct pt_r
 	if (sel < 0)
 		return sel;
 
-	desc = get_desc(sel);
-	if (!desc)
+	if (!get_desc(&desc, sel))
 		return -EINVAL;
 
 	/*
@@ -761,10 +762,10 @@ int insn_get_code_seg_params(struct pt_r
 	 * determines whether a segment contains data or code. If this is a data
 	 * segment, return error.
 	 */
-	if (!(desc->type & BIT(3)))
+	if (!(desc.type & BIT(3)))
 		return -EINVAL;
 
-	switch ((desc->l << 1) | desc->d) {
+	switch ((desc.l << 1) | desc.d) {
 	case 0: /*
 		 * Legacy mode. CS.L=0, CS.D=0. Address and operand size are
 		 * both 16-bit.


