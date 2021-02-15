Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB75C31BD31
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhBOPlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhBOPiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FCD964EEA;
        Mon, 15 Feb 2021 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403239;
        bh=FydyvUabgfSj0tpi0vAQQgW4003YdZy9X1JeOpqxO58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6kXfWqx8zgydPAa919nOAzZkKL4eF0+l3X6QGU4/RXiArPLo8BaPqWEJSzx3Nn3K
         5vPRZf7bGMi9lq/eZjZrGtiNvp+27J/LeoLEJZJLlR+2l8QIsF7AMx2klKx+bSJ1N8
         whlc1CESZnSm8lypSLuDzLuffJ3OMpa00UNlfhno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/104] ubsan: implement __ubsan_handle_alignment_assumption
Date:   Mon, 15 Feb 2021 16:26:57 +0100
Message-Id: <20210215152720.898348168@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 28abcc963149e06d956d95a18a85f4ba26af746f ]

When building ARCH=mips 32r2el_defconfig with CONFIG_UBSAN_ALIGNMENT:

  ld.lld: error: undefined symbol: __ubsan_handle_alignment_assumption
     referenced by slab.h:557 (include/linux/slab.h:557)
                   main.o:(do_initcalls) in archive init/built-in.a
     referenced by slab.h:448 (include/linux/slab.h:448)
                   do_mounts_rd.o:(rd_load_image) in archive init/built-in.a
     referenced by slab.h:448 (include/linux/slab.h:448)
                   do_mounts_rd.o:(identify_ramdisk_image) in archive init/built-in.a
     referenced 1579 more times

Implement this for the kernel based on LLVM's
handleAlignmentAssumptionImpl because the kernel is not linked against
the compiler runtime.

Link: https://github.com/ClangBuiltLinux/linux/issues/1245
Link: https://github.com/llvm/llvm-project/blob/llvmorg-11.0.1/compiler-rt/lib/ubsan/ubsan_handlers.cpp#L151-L190
Link: https://lkml.kernel.org/r/20210127224451.2587372-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/ubsan.c | 31 +++++++++++++++++++++++++++++++
 lib/ubsan.h |  6 ++++++
 2 files changed, 37 insertions(+)

diff --git a/lib/ubsan.c b/lib/ubsan.c
index cb9af3f6b77e3..adf8dcf3c84e6 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -427,3 +427,34 @@ void __ubsan_handle_load_invalid_value(void *_data, void *val)
 	ubsan_epilogue();
 }
 EXPORT_SYMBOL(__ubsan_handle_load_invalid_value);
+
+void __ubsan_handle_alignment_assumption(void *_data, unsigned long ptr,
+					 unsigned long align,
+					 unsigned long offset);
+void __ubsan_handle_alignment_assumption(void *_data, unsigned long ptr,
+					 unsigned long align,
+					 unsigned long offset)
+{
+	struct alignment_assumption_data *data = _data;
+	unsigned long real_ptr;
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, "alignment-assumption");
+
+	if (offset)
+		pr_err("assumption of %lu byte alignment (with offset of %lu byte) for pointer of type %s failed",
+		       align, offset, data->type->type_name);
+	else
+		pr_err("assumption of %lu byte alignment for pointer of type %s failed",
+		       align, data->type->type_name);
+
+	real_ptr = ptr - offset;
+	pr_err("%saddress is %lu aligned, misalignment offset is %lu bytes",
+	       offset ? "offset " : "", BIT(real_ptr ? __ffs(real_ptr) : 0),
+	       real_ptr & (align - 1));
+
+	ubsan_epilogue();
+}
+EXPORT_SYMBOL(__ubsan_handle_alignment_assumption);
diff --git a/lib/ubsan.h b/lib/ubsan.h
index 7b56c09473a98..9a0b71c5ff9fb 100644
--- a/lib/ubsan.h
+++ b/lib/ubsan.h
@@ -78,6 +78,12 @@ struct invalid_value_data {
 	struct type_descriptor *type;
 };
 
+struct alignment_assumption_data {
+	struct source_location location;
+	struct source_location assumption_location;
+	struct type_descriptor *type;
+};
+
 #if defined(CONFIG_ARCH_SUPPORTS_INT128)
 typedef __int128 s_max;
 typedef unsigned __int128 u_max;
-- 
2.27.0



