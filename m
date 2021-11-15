Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79F4513AD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348606AbhKOTyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233464AbhKOTWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24925635EF;
        Mon, 15 Nov 2021 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002009;
        bh=VtYf4l5+U5cuDlxkGU8QcXdHIFxr3Cd/T9k8AacZ7so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRVl6BiM46sKCbYEgpACgg+dEs5ry9lvl3J4YzMQpT2iE/dr/GAZ1sK/OMoW6DZF8
         aGhELgttvrFdMzmXGm1lh2mBaOKvy8ZTwsgpxU0AIMfncUWnaw9i8FbyaYFN4CdPfX
         l2bfNGjh98ZZkicN+FqzAqZFtaxxErug5cKnybd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 404/917] x86/insn: Use get_unaligned() instead of memcpy()
Date:   Mon, 15 Nov 2021 17:58:19 +0100
Message-Id: <20211115165442.487074059@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit f96b4675839b66168f5a07bf964dde6c2f1c4885 ]

Use get_unaligned() instead of memcpy() to access potentially unaligned
memory, which, when accessed through a pointer, leads to undefined
behavior. get_unaligned() describes much better what is happening there
anyway even if memcpy() does the job.

In addition, since perf tool builds with -Werror, it would fire with:

  util/intel-pt-decoder/../../../arch/x86/lib/insn.c: In function '__insn_get_emulate_prefix':
  tools/include/../include/asm-generic/unaligned.h:10:15: error: packed attribute is unnecessary [-Werror=packed]
     10 |  const struct { type x; } __packed *__pptr = (typeof(__pptr))(ptr); \

because -Werror=packed would complain if the packed attribute would have
no effect on the layout of the structure.

In this case, that is intentional so disable the warning only for that
compilation unit.

That part is Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

No functional changes.

Fixes: 5ba1071f7554 ("x86/insn, tools/x86: Fix undefined behavior due to potential unaligned accesses")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lkml.kernel.org/r/YVSsIkj9Z29TyUjE@zn.tnic
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/insn.c                    |  5 +++--
 tools/arch/x86/lib/insn.c              |  5 +++--
 tools/include/asm-generic/unaligned.h  | 23 +++++++++++++++++++++++
 tools/perf/util/intel-pt-decoder/Build |  2 ++
 4 files changed, 31 insertions(+), 4 deletions(-)
 create mode 100644 tools/include/asm-generic/unaligned.h

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index c565def611e24..55e371cc69fd5 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -13,6 +13,7 @@
 #endif
 #include <asm/inat.h> /*__ignore_sync_check__ */
 #include <asm/insn.h> /* __ignore_sync_check__ */
+#include <asm/unaligned.h> /* __ignore_sync_check__ */
 
 #include <linux/errno.h>
 #include <linux/kconfig.h>
@@ -37,10 +38,10 @@
 	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
-	({ t r; memcpy(&r, insn->next_byte, sizeof(t)); insn->next_byte += sizeof(t); leXX_to_cpu(t, r); })
+	({ t r = get_unaligned((t *)(insn)->next_byte); (insn)->next_byte += sizeof(t); leXX_to_cpu(t, r); })
 
 #define __peek_nbyte_next(t, insn, n)	\
-	({ t r; memcpy(&r, (insn)->next_byte + n, sizeof(t)); leXX_to_cpu(t, r); })
+	({ t r = get_unaligned((t *)(insn)->next_byte + n); leXX_to_cpu(t, r); })
 
 #define get_next(t, insn)	\
 	({ if (unlikely(!validate_next(t, insn, 0))) goto err_out; __get_next(t, insn); })
diff --git a/tools/arch/x86/lib/insn.c b/tools/arch/x86/lib/insn.c
index 797699462cd8e..8fd63a067308a 100644
--- a/tools/arch/x86/lib/insn.c
+++ b/tools/arch/x86/lib/insn.c
@@ -13,6 +13,7 @@
 #endif
 #include "../include/asm/inat.h" /* __ignore_sync_check__ */
 #include "../include/asm/insn.h" /* __ignore_sync_check__ */
+#include "../include/asm-generic/unaligned.h" /* __ignore_sync_check__ */
 
 #include <linux/errno.h>
 #include <linux/kconfig.h>
@@ -37,10 +38,10 @@
 	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
-	({ t r; memcpy(&r, insn->next_byte, sizeof(t)); insn->next_byte += sizeof(t); leXX_to_cpu(t, r); })
+	({ t r = get_unaligned((t *)(insn)->next_byte); (insn)->next_byte += sizeof(t); leXX_to_cpu(t, r); })
 
 #define __peek_nbyte_next(t, insn, n)	\
-	({ t r; memcpy(&r, (insn)->next_byte + n, sizeof(t)); leXX_to_cpu(t, r); })
+	({ t r = get_unaligned((t *)(insn)->next_byte + n); leXX_to_cpu(t, r); })
 
 #define get_next(t, insn)	\
 	({ if (unlikely(!validate_next(t, insn, 0))) goto err_out; __get_next(t, insn); })
diff --git a/tools/include/asm-generic/unaligned.h b/tools/include/asm-generic/unaligned.h
new file mode 100644
index 0000000000000..47387c607035e
--- /dev/null
+++ b/tools/include/asm-generic/unaligned.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copied from the kernel sources to tools/perf/:
+ */
+
+#ifndef __TOOLS_LINUX_ASM_GENERIC_UNALIGNED_H
+#define __TOOLS_LINUX_ASM_GENERIC_UNALIGNED_H
+
+#define __get_unaligned_t(type, ptr) ({						\
+	const struct { type x; } __packed *__pptr = (typeof(__pptr))(ptr);	\
+	__pptr->x;								\
+})
+
+#define __put_unaligned_t(type, val, ptr) do {					\
+	struct { type x; } __packed *__pptr = (typeof(__pptr))(ptr);		\
+	__pptr->x = (val);							\
+} while (0)
+
+#define get_unaligned(ptr)	__get_unaligned_t(typeof(*(ptr)), (ptr))
+#define put_unaligned(val, ptr) __put_unaligned_t(typeof(*(ptr)), (val), (ptr))
+
+#endif /* __TOOLS_LINUX_ASM_GENERIC_UNALIGNED_H */
+
diff --git a/tools/perf/util/intel-pt-decoder/Build b/tools/perf/util/intel-pt-decoder/Build
index bc629359826fb..b41c2e9c6f887 100644
--- a/tools/perf/util/intel-pt-decoder/Build
+++ b/tools/perf/util/intel-pt-decoder/Build
@@ -18,3 +18,5 @@ CFLAGS_intel-pt-insn-decoder.o += -I$(OUTPUT)util/intel-pt-decoder
 ifeq ($(CC_NO_CLANG), 1)
   CFLAGS_intel-pt-insn-decoder.o += -Wno-override-init
 endif
+
+CFLAGS_intel-pt-insn-decoder.o += -Wno-packed
-- 
2.33.0



