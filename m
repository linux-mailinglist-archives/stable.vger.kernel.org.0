Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B69615610
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 00:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiKAXZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 19:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKAXZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 19:25:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EE11759A;
        Tue,  1 Nov 2022 16:25:39 -0700 (PDT)
Date:   Tue, 01 Nov 2022 23:25:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667345137;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=I0y+lhuQmGVn5FfJdmSsSqet8+hYCRLEMYJ6mzf+imk=;
        b=ocwjHhsqkDMORDxhZRk7e2/M12hs2heP6mVSKrctyjQxsZ1zxm21zL+afOe24/4cLKb7BL
        JwRT764ss3GCaMTCYFE1YU0sSrDbI9Ff4QfWQIrOX23D8NTvQB58JLnuW8NhvShqvT0BTK
        934cLxLRlV/Fe5mDA7gnbcDwYHDWq0N5tHWFy2x+3Srn2Z+2JagyQl6BGNo1LzbaTvxIgb
        CRbqmUpMZlhYmGu7N0yNFX6yRiaI22X7pJHD7QYQFPnFKiWoxZHM0lKHnjkd7rE4G9K3Rs
        RfVOb5Q2rmU+ePhgONojqaDkOnHjn9ehtWe8I1VV/KBfSTspyaenlbfnhX0S1A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667345137;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=I0y+lhuQmGVn5FfJdmSsSqet8+hYCRLEMYJ6mzf+imk=;
        b=sAlyXw8KeGH4/B1syi7NnNrh0XgPqkOKhhSBREeBagzDNSK1e7AcOAyPnHVzMAihNz6AYU
        ylP+qPO9LTUvUtCQ==
From:   "tip-bot2 for Dave Hansen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/tdx: Prepare for using "INFO" call for a second purpose
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <166734513630.7716.12952231613533508782.tip-bot2@tip-bot2>
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

Commit-ID:     a6dd6f39008bb3ef7c73ef0a2acc2a4209555bd8
Gitweb:        https://git.kernel.org/tip/a6dd6f39008bb3ef7c73ef0a2acc2a4209555bd8
Author:        Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate:    Fri, 28 Oct 2022 17:12:19 +03:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Tue, 01 Nov 2022 10:07:15 -07:00

x86/tdx: Prepare for using "INFO" call for a second purpose

The TDG.VP.INFO TDCALL provides the guest with various details about
the TDX system that the guest needs to run.  Only one field is currently
used: 'gpa_width' which tells the guest which PTE bits mark pages shared
or private.

A second field is now needed: the guest "TD attributes" to tell if
virtualization exceptions are configured in a way that can harm the guest.

Make the naming and calling convention more generic and discrete from the
mask-centric one.

Thanks to Sathya for the inspiration here, but there's no code, comments
or changelogs left from where he started.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/coco/tdx/tdx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 928dcf7..3fee969 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -98,7 +98,7 @@ static inline void tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
 }
 
-static u64 get_cc_mask(void)
+static void tdx_parse_tdinfo(u64 *cc_mask)
 {
 	struct tdx_module_output out;
 	unsigned int gpa_width;
@@ -121,7 +121,7 @@ static u64 get_cc_mask(void)
 	 * The highest bit of a guest physical address is the "sharing" bit.
 	 * Set it for shared pages and clear it for private pages.
 	 */
-	return BIT_ULL(gpa_width - 1);
+	*cc_mask = BIT_ULL(gpa_width - 1);
 }
 
 /*
@@ -758,7 +758,7 @@ void __init tdx_early_init(void)
 	setup_force_cpu_cap(X86_FEATURE_TDX_GUEST);
 
 	cc_set_vendor(CC_VENDOR_INTEL);
-	cc_mask = get_cc_mask();
+	tdx_parse_tdinfo(&cc_mask);
 	cc_set_mask(cc_mask);
 
 	/*
