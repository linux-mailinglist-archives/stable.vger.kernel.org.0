Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CA21C96DB
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 18:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEGQuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 12:50:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:43277 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgEGQuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 12:50:17 -0400
IronPort-SDR: cjuoT0SQTDfVqtbMxVZtA6VW+kuCC5BTXiedrIY5+HBRKrWgjXX2LjCfCU8nXrrzQX1/OtyB1n
 +KgXicC7yeag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 09:50:15 -0700
IronPort-SDR: Ms9q1mkGk1TD+317CGrZFl70J8ycy1T6V+H20BPKVdBhqKbvUSeZXJw6f8cRlz8hi3C9iRTiZ9
 RLGaVuVla6MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="461910078"
Received: from yyu32-desk.sc.intel.com ([143.183.136.146])
  by fmsmga005.fm.intel.com with ESMTP; 07 May 2020 09:50:15 -0700
From:   Yu-cheng Yu <yu-cheng.yu@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Rik van Riel <riel@surriel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Yu-cheng Yu <yu-cheng.yu@intel.com>, sam <sunhaoyl@outlook.com>,
        Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: [PATCH] x86/fpu/xstate: Clear uninitialized xstate areas in core dump
Date:   Thu,  7 May 2020 09:49:04 -0700
Message-Id: <20200507164904.26927-1-yu-cheng.yu@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In a core dump, copy_xstate_to_kernel() copies only enabled user xfeatures
to a kernel buffer without touching areas for disabled xfeatures.  However,
those uninitialized areas may contain random data, which is then written to
the core dump file and can be read by a non-privileged user.

Fix it by clearing uninitialized areas.

Link: https://github.com/google/kmsan/issues/76
Link: https://lore.kernel.org/lkml/20200419100848.63472-1-glider@google.com/
Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Reported-by: sam <sunhaoyl@outlook.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 32b153d38748..0856daa29be7 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -983,6 +983,7 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
 {
 	unsigned int offset, size;
 	struct xstate_header header;
+	int last_off;
 	int i;
 
 	/*
@@ -1006,7 +1007,17 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
 
 	__copy_xstate_to_kernel(kbuf, &header, offset, size, size_total);
 
+	last_off = 0;
+
 	for (i = 0; i < XFEATURE_MAX; i++) {
+		/*
+		 * Clear uninitialized area before XSAVE header.
+		 */
+		if (i == FIRST_EXTENDED_XFEATURE) {
+			memset(kbuf + last_off, 0, XSAVE_HDR_OFFSET - last_off);
+			last_off = XSAVE_HDR_OFFSET + XSAVE_HDR_SIZE;
+		}
+
 		/*
 		 * Copy only in-use xstates:
 		 */
@@ -1020,11 +1031,16 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
 			if (offset + size > size_total)
 				break;
 
+			memset(kbuf + last_off, 0, offset - last_off);
+			last_off = offset + size;
+
 			__copy_xstate_to_kernel(kbuf, src, offset, size, size_total);
 		}
 
 	}
 
+	memset(kbuf + last_off, 0, size_total - last_off);
+
 	if (xfeatures_mxcsr_quirk(header.xfeatures)) {
 		offset = offsetof(struct fxregs_state, mxcsr);
 		size = MXCSR_AND_FLAGS_SIZE;
-- 
2.21.0

