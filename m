Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47DA5CA58
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfGBIDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbfGBIDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C033E216C8;
        Tue,  2 Jul 2019 08:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054595;
        bh=4gKGw1J2PXubqLIA0ppPWMBfclGqzmPg3zzOTk6+L2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+w4PhFeazL2uZJn1QwzDjLFsE3ib5YBchM24Y6OkWPNeEpK+zWPGhr2q5naQccrk
         NSIJFT/JDUk1GMfam/xrPzTDuYgWqpB3CJNGojh93rJW0EIw3i2TXyVDyWQoZdOM4x
         sOeM4mKCAqJiIk5uOM0UsMvGwCCnjfimYDysfnic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, x86-ml <x86@kernel.org>
Subject: [PATCH 5.1 23/55] x86/resctrl: Prevent possible overrun during bitmap operations
Date:   Tue,  2 Jul 2019 10:01:31 +0200
Message-Id: <20190702080125.255952865@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit 32f010deab575199df4ebe7b6aec20c17bb7eccd upstream.

While the DOC at the beginning of lib/bitmap.c explicitly states that
"The number of valid bits in a given bitmap does _not_ need to be an
exact multiple of BITS_PER_LONG.", some of the bitmap operations do
indeed access BITS_PER_LONG portions of the provided bitmap no matter
the size of the provided bitmap.

For example, if find_first_bit() is provided with an 8 bit bitmap the
operation will access BITS_PER_LONG bits from the provided bitmap. While
the operation ensures that these extra bits do not affect the result,
the memory is still accessed.

The capacity bitmasks (CBMs) are typically stored in u32 since they
can never exceed 32 bits. A few instances exist where a bitmap_*
operation is performed on a CBM by simply pointing the bitmap operation
to the stored u32 value.

The consequence of this pattern is that some bitmap_* operations will
access out-of-bounds memory when interacting with the provided CBM.

This same issue has previously been addressed with commit 49e00eee0061
("x86/intel_rdt: Fix out-of-bounds memory access in CBM tests")
but at that time not all instances of the issue were fixed.

Fix this by using an unsigned long to store the capacity bitmask data
that is passed to bitmap functions.

Fixes: e651901187ab ("x86/intel_rdt: Introduce "bit_usage" to display cache allocations details")
Fixes: f4e80d67a527 ("x86/intel_rdt: Resctrl files reflect pseudo-locked information")
Fixes: 95f0b77efa57 ("x86/intel_rdt: Initialize new resource group with sane defaults")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |   35 +++++++++++++++------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -804,8 +804,12 @@ static int rdt_bit_usage_show(struct ker
 			      struct seq_file *seq, void *v)
 {
 	struct rdt_resource *r = of->kn->parent->priv;
-	u32 sw_shareable = 0, hw_shareable = 0;
-	u32 exclusive = 0, pseudo_locked = 0;
+	/*
+	 * Use unsigned long even though only 32 bits are used to ensure
+	 * test_bit() is used safely.
+	 */
+	unsigned long sw_shareable = 0, hw_shareable = 0;
+	unsigned long exclusive = 0, pseudo_locked = 0;
 	struct rdt_domain *dom;
 	int i, hwb, swb, excl, psl;
 	enum rdtgrp_mode mode;
@@ -850,10 +854,10 @@ static int rdt_bit_usage_show(struct ker
 		}
 		for (i = r->cache.cbm_len - 1; i >= 0; i--) {
 			pseudo_locked = dom->plr ? dom->plr->cbm : 0;
-			hwb = test_bit(i, (unsigned long *)&hw_shareable);
-			swb = test_bit(i, (unsigned long *)&sw_shareable);
-			excl = test_bit(i, (unsigned long *)&exclusive);
-			psl = test_bit(i, (unsigned long *)&pseudo_locked);
+			hwb = test_bit(i, &hw_shareable);
+			swb = test_bit(i, &sw_shareable);
+			excl = test_bit(i, &exclusive);
+			psl = test_bit(i, &pseudo_locked);
 			if (hwb && swb)
 				seq_putc(seq, 'X');
 			else if (hwb && !swb)
@@ -2494,26 +2498,19 @@ out_destroy:
  */
 static void cbm_ensure_valid(u32 *_val, struct rdt_resource *r)
 {
-	/*
-	 * Convert the u32 _val to an unsigned long required by all the bit
-	 * operations within this function. No more than 32 bits of this
-	 * converted value can be accessed because all bit operations are
-	 * additionally provided with cbm_len that is initialized during
-	 * hardware enumeration using five bits from the EAX register and
-	 * thus never can exceed 32 bits.
-	 */
-	unsigned long *val = (unsigned long *)_val;
+	unsigned long val = *_val;
 	unsigned int cbm_len = r->cache.cbm_len;
 	unsigned long first_bit, zero_bit;
 
-	if (*val == 0)
+	if (val == 0)
 		return;
 
-	first_bit = find_first_bit(val, cbm_len);
-	zero_bit = find_next_zero_bit(val, cbm_len, first_bit);
+	first_bit = find_first_bit(&val, cbm_len);
+	zero_bit = find_next_zero_bit(&val, cbm_len, first_bit);
 
 	/* Clear any remaining bits to ensure contiguous region */
-	bitmap_clear(val, zero_bit, cbm_len - zero_bit);
+	bitmap_clear(&val, zero_bit, cbm_len - zero_bit);
+	*_val = (u32)val;
 }
 
 /**


