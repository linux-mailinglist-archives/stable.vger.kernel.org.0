Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4FB60170E
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJQTLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJQTLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:11:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C42760EB;
        Mon, 17 Oct 2022 12:11:26 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:11:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666033884;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNbzadM4sp0fE1rZcmiFJ3WAhf8ueTO2rJeOjD3VaL0=;
        b=B6zXLbawfZ53+5RjtVmhT98RNwZUXMwA5Ovn7cIOH+uZM2mEWnrEcDG5/xtk8ZsWBIwrX6
        iqvsRhzuH32o2XMoky55mtjLNQvF0x/3jITMZrTQdYEOkl9UXDr5LUzvpZ12iYTpSHSXGd
        /i38ICZvqqNPU+2bMxbMcHHOd6LBz2kmskcf7ZtanD/jeOg1FqeANzX5xbZh1nkWAaXMQK
        DSS69TglRqDC25h/LtzF3T559cTPMHciyA4ag4XFTb3Naj7WpdMsxwEWOVe8m9uOvH5FjD
        ydlIIh+nWWAoogVAqWyR52RN3uLkPgu7oLXUjmCTVfJQ1oU2COhyDrUYN9oXYA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666033884;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNbzadM4sp0fE1rZcmiFJ3WAhf8ueTO2rJeOjD3VaL0=;
        b=CRKALFj7FJHRdF0e7nRXBHgSPbIFYA3qCkBUJGStcLSXNtTXAgpToHPLj3woy/4lyGQEgg
        OW4bOJO1hlMrKYAA==
From:   "tip-bot2 for Zhang Rui" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/topology: Fix duplicated core ID within a package
Cc:     Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221014090147.1836-5-rui.zhang@intel.com>
References: <20221014090147.1836-5-rui.zhang@intel.com>
MIME-Version: 1.0
Message-ID: <166603388137.401.8014565128947314583.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     71eac7063698b7d7b8fafb1683ac24a034541141
Gitweb:        https://git.kernel.org/tip/71eac7063698b7d7b8fafb1683ac24a034541141
Author:        Zhang Rui <rui.zhang@intel.com>
AuthorDate:    Fri, 14 Oct 2022 17:01:47 +08:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Mon, 17 Oct 2022 11:58:52 -07:00

x86/topology: Fix duplicated core ID within a package

Today, core ID is assumed to be unique within each package.

But an AlderLake-N platform adds a Module level between core and package,
Linux excludes the unknown modules bits from the core ID, resulting in
duplicate core ID's.

To keep core ID unique within a package, Linux must include all APIC-ID
bits for known or unknown levels above the core and below the package
in the core ID.

It is important to understand that core ID's have always come directly
from the APIC-ID encoding, which comes from the BIOS. Thus there is no
guarantee that they start at 0, or that they are contiguous.
As such, naively using them for array indexes can be problematic.

[ dhansen: un-known -> unknown ]

Fixes: 7745f03eb395 ("x86/topology: Add CPUID.1F multi-die/package support")
Suggested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221014090147.1836-5-rui.zhang@intel.com
---
 arch/x86/kernel/cpu/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index f759281..5e868b6 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -141,7 +141,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 		sub_index++;
 	}
 
-	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+	core_select_mask = (~(-1 << pkg_mask_width)) >> ht_mask_width;
 	die_select_mask = (~(-1 << die_plus_mask_width)) >>
 				core_plus_mask_width;
 
