Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5132C4CF88
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 15:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbfFTNtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 09:49:46 -0400
Received: from terminus.zytor.com ([198.137.202.136]:46183 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfFTNtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 09:49:46 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x5KDnBvt999931
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 20 Jun 2019 06:49:11 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5KDnBvt999931
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019061801; t=1561038552;
        bh=L/YLmINRGFDxpeVgo5xandILmjVul8XL//NAEX5mLhk=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=VjcV/Jn26E/l/bQU1DufH63+IY82PnPDuH9+uUK4uuIz76UT0ogGIoldwwrSXCu2X
         dRNCmY5CWTPse3yPHrUbFdfFPSrJ4ZiMNkPHdsvwq+GzEcJEkg2HU3pg3TIrqa0pMQ
         xrdYNqsYaV+DWPD2JRepaCCvyNE3su6lr5+T2iwclZXSrQreOvmc4hps4DMNgNvN82
         mZkEMUdv/PqMaKfkz0Z0stlt9ACLppyMNcvIi1+n8774XxWDAu/+0kcSitGQdFGoIw
         KunSoM/6FpkotSRNkBcy0v6ksHhreIHi8E79yaN8p3A5W1LFjlKQGK2sigPebITjKN
         cyqrX+dlcOvUw==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x5KDnABl999926;
        Thu, 20 Jun 2019 06:49:10 -0700
Date:   Thu, 20 Jun 2019 06:49:10 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Reinette Chatre <tipbot@zytor.com>
Message-ID: <tip-32f010deab575199df4ebe7b6aec20c17bb7eccd@git.kernel.org>
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        fenghua.yu@intel.com, tony.luck@intel.com, tglx@linutronix.de,
        bp@suse.de, stable@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
        reinette.chatre@intel.com
Reply-To: hpa@zytor.com, x86@kernel.org, reinette.chatre@intel.com,
          mingo@kernel.org, mingo@redhat.com, fenghua.yu@intel.com,
          bp@suse.de, tglx@linutronix.de, tony.luck@intel.com,
          stable@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com>
References: <58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/resctrl: Prevent possible overrun during
 bitmap operations
Git-Commit-ID: 32f010deab575199df4ebe7b6aec20c17bb7eccd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  32f010deab575199df4ebe7b6aec20c17bb7eccd
Gitweb:     https://git.kernel.org/tip/32f010deab575199df4ebe7b6aec20c17bb7eccd
Author:     Reinette Chatre <reinette.chatre@intel.com>
AuthorDate: Wed, 19 Jun 2019 13:27:16 -0700
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 20 Jun 2019 15:39:19 +0200

x86/resctrl: Prevent possible overrun during bitmap operations

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
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 35 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 869cbef5da81..f9d8ed6ab03b 100644
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
 
 /*
