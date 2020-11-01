Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2052A2055
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 18:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgKARbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 12:31:08 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33489 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgKARbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 12:31:08 -0500
Received: by mail-qk1-f194.google.com with SMTP id l2so9638392qkf.0;
        Sun, 01 Nov 2020 09:31:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5TxGQj59r4R36o8V2KKsYZ1N9+Qp4l0BQbumIvYBoMc=;
        b=NrvEQ7hDvXcRfHtwpnirRnYvhrIueTCmddMiZRgcmLIy6z+F7iBV4QYCp4Om8GxCGW
         k1Qa4/LBcy26qRiJnRSW2Pr32+pJwbAvgUy6YsxHSPu7d8MRtFADgBaMqtHMhDuevRYJ
         VTXgcqNe/Iew38TMpSot2iCZznVWcIRA1q81RPDfIsMZjSz3aBSldNDqNj6ur42hGnxf
         H34qRyj5M082LNsr7D9U4NTs9MpMbtJb3NeO5aS/lgV/3LvGnVr5OGQsLFBqj/gZQz+P
         ndy6x2oF3NC6E6e95kD01uUeYSSVTfdhXxbribJMDlBkENBhX8dHHj2uRtvIiQn+S/9o
         MD0g==
X-Gm-Message-State: AOAM532XSHc8hannoNWiqb0ajTqK4mCvrqquDUJOs/T8KpPSarmUKw4Y
        90Jt39BauqAFsOTA5jrGPI9I7UaQEoDPpA==
X-Google-Smtp-Source: ABdhPJzQLQ9k/lY1RhAPb/81V0g5gEghldV+tV+7+1mtiyO9ZTBZNL4kvtzpCdSDmnD26O3xxlx+Vg==
X-Received: by 2002:ae9:e509:: with SMTP id w9mr11105749qkf.311.1604251866893;
        Sun, 01 Nov 2020 09:31:06 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id t60sm784981qtd.65.2020.11.01.09.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 09:31:06 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     kernel test robot <lkp@intel.com>, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] compiler.h: Move barrier() back into compiler-*.h
Date:   Sun,  1 Nov 2020 12:31:05 -0500
Message-Id: <20201101173105.1723648-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <202010312104.Dk9VQJYb-lkp@intel.com>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit
  b9de06783f01 ("compiler.h: fix barrier_data() on clang")
moved the definition of barrier() into compiler.h.

This causes build failures at least on alpha, because there are files
that rely on barrier() being defined via the implicit include of
compiler_types.h.

Revert this portion of the commit to fix.

Link: https://lore.kernel.org/linux-mm/202010312104.Dk9VQJYb-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Fixes: b9de06783f01 ("compiler.h: fix barrier_data() on clang")
Cc: <stable@vger.kernel.org>
---
 include/linux/compiler-clang.h | 6 ++++++
 include/linux/compiler-gcc.h   | 5 +++++
 include/linux/compiler.h       | 3 +--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index dd7233c48bf3..230604e7f057 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -60,6 +60,12 @@
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
 
+/* The following are for compatibility with GCC, from compiler-gcc.h,
+ * and may be redefined here because they should not be shared with other
+ * compilers, like ICC.
+ */
+#define barrier() __asm__ __volatile__("" : : : "memory")
+
 #if __has_feature(shadow_call_stack)
 # define __noscs	__attribute__((__no_sanitize__("shadow-call-stack")))
 #endif
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 50912ed00278..a572965c801a 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -15,6 +15,11 @@
 # error Sorry, your version of GCC is too old - please use 4.9 or newer.
 #endif
 
+/* Optimization barrier */
+
+/* The "volatile" is due to gcc bugs */
+#define barrier() __asm__ __volatile__("": : :"memory")
+
 /*
  * This macro obfuscates arithmetic on a variable address so that gcc
  * shouldn't recognize the original var, and make assumptions about it.
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index b8fe0c23cfff..25c803f4222f 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -80,8 +80,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 
 /* Optimization barrier */
 #ifndef barrier
-/* The "volatile" is due to gcc bugs */
-# define barrier() __asm__ __volatile__("": : :"memory")
+# define barrier() __memory_barrier()
 #endif
 
 #ifndef barrier_data
-- 
2.26.2

