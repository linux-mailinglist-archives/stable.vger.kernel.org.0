Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FA64C267
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 22:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfFSU26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 16:28:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:43836 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfFSU25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 16:28:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 13:28:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="358307881"
Received: from rchatre-s.jf.intel.com ([10.54.70.76])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jun 2019 13:28:56 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com
Cc:     mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/resctrl: Prevent possible overrun during bitmap operations
Date:   Wed, 19 Jun 2019 13:27:16 -0700
Message-Id: <58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While the DOC at the beginning of lib/bitmap.c explicitly states that
"The number of valid bits in a given bitmap does _not_ need to be an
exact multiple of BITS_PER_LONG.", some of the bitmap operations do
indeed access BITS_PER_LONG portions of the provided bitmap no matter
the size of the provided bitmap. For example, if find_first_bit()
is provided with an 8 bit bitmap the operation will access
BITS_PER_LONG bits from the provided bitmap. While the operation
ensures that these extra bits do not affect the result, the memory
is still accessed.

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

Cc: <stable@vger.kernel.org>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 35 ++++++++++++--------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 333c177a2471..b63e50b1a096 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -804,8 +804,12 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
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
@@ -850,10 +854,10 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
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
@@ -2494,26 +2498,19 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
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
 
 /*
-- 
2.17.2

