Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E0A6322B9
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiKUMpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiKUMpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:45:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B571BC0515;
        Mon, 21 Nov 2022 04:45:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C00B761187;
        Mon, 21 Nov 2022 12:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B48C433D6;
        Mon, 21 Nov 2022 12:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669034702;
        bh=LWs0kQI7gkyb/prvAT4GoTrHnhbOAdEHsKKMMa3czjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn26CBIbrjr7EBXKi+4E6cTph7weN8YJFKZ+Vo14P96JFK45t6Jyxt9ED1OhyZJdg
         esb0XMQLK5Tvu7qI3r8/2Q4Mb0HY2FQp9msqXxhfKZN7OQGLxbYeTINKhAjLQnrQOF
         oypOohpZkXdDCMZllPSupupXCq9oSU9huyS9vcNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 04/34] x86/cpufeature: Fix various quality problems in the <asm/cpu_device_hd.h> header
Date:   Mon, 21 Nov 2022 13:43:26 +0100
Message-Id: <20221121124151.029399009@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Thomas noticed that the new arch/x86/include/asm/cpu_device_id.h header is
a train-wreck that didn't incorporate review feedback like not using __u8
in kernel-only headers.

While at it also fix all the *other* problems this header has:

 - Use canonical names for the header guards. It's inexplicable why a non-standard
   guard was used.

 - Don't define the header guard to 1. Plus annotate the closing #endif as done
   absolutely every other header. Again, an inexplicable source of noise.

 - Move the kernel API calls provided by this header next to each other, there's
   absolutely no reason to have them spread apart in the header.

 - Align the INTEL_CPU_DESC() macro initializations vertically, this is easier to
   read and it's also the canonical style.

 - Actually name the macro arguments properly: instead of 'mod, step, rev',
   spell out 'model, stepping, revision' - it's not like we have a lack of
   characters in this header.

 - Actually make arguments macro-safe - again it's inexplicable why it wasn't
   done properly to begin with.

Quite amazing how many problems a 41 lines header can contain.

This kind of code quality is unacceptable, and it slipped through the
review net of 2 developers and 2 maintainers, including myself, until
Thomas noticed it. :-/

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu_device_id.h |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _CPU_DEVICE_ID
-#define _CPU_DEVICE_ID 1
+#ifndef _ASM_X86_CPU_DEVICE_ID
+#define _ASM_X86_CPU_DEVICE_ID
 
 /*
  * Declare drivers belonging to specific x86 CPUs
@@ -9,8 +9,6 @@
 
 #include <linux/mod_devicetable.h>
 
-extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
-
 /*
  * Match specific microcode revisions.
  *
@@ -22,21 +20,22 @@ extern const struct x86_cpu_id *x86_matc
  */
 
 struct x86_cpu_desc {
-	__u8	x86_family;
-	__u8	x86_vendor;
-	__u8	x86_model;
-	__u8	x86_stepping;
-	__u32	x86_microcode_rev;
+	u8	x86_family;
+	u8	x86_vendor;
+	u8	x86_model;
+	u8	x86_stepping;
+	u32	x86_microcode_rev;
 };
 
-#define INTEL_CPU_DESC(mod, step, rev) {			\
-	.x86_family = 6,					\
-	.x86_vendor = X86_VENDOR_INTEL,				\
-	.x86_model = mod,					\
-	.x86_stepping = step,					\
-	.x86_microcode_rev = rev,				\
+#define INTEL_CPU_DESC(model, stepping, revision) {		\
+	.x86_family		= 6,				\
+	.x86_vendor		= X86_VENDOR_INTEL,		\
+	.x86_model		= (model),			\
+	.x86_stepping		= (stepping),			\
+	.x86_microcode_rev	= (revision),			\
 }
 
+extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
 
-#endif
+#endif /* _ASM_X86_CPU_DEVICE_ID */


