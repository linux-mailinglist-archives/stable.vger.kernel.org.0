Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA939601E6D
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiJRAK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiJRAJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:09:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5116188A3D;
        Mon, 17 Oct 2022 17:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF68B81BE2;
        Tue, 18 Oct 2022 00:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA90C433D6;
        Tue, 18 Oct 2022 00:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051700;
        bh=NqURN77r9MhBGrwVVovenXOafIgRuDAmFLodlWUYiJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njAzXxbq+YX3MEC7lZe5l8eAN1t/7bhHf0SjL+PcFHI+f0xyrNuhI+ZvP8g1D463k
         mEL5V+Ss1qDhZ7cuEBBWIOJd/gswVXVlhrtNcIt5Ua4jTnMeys68TQL9mXr+7ctUgk
         MPMonWO3KspIWVWdxcj0sXHNAmdpWVFtTLLIu4dSJLW58TaL3Ji71hqHg4tvr680BU
         FnL8Fdi8QPWN0qSBmsljsKIyXmJnS9xGj/X/FI1UI616zrxsM6fA49HNWUBat3rVIA
         k/mUvvzlSGJjJVvzLMLgOJG9x6Q3nCVrV49kJmUh/QTqTguNhlll2yfh1Kb00iBwue
         BBkKzMHWPyqlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ardb@kernel.org,
        will@kernel.org, jgross@suse.com, christophe.leroy@csgroup.eu,
        mhiramat@kernel.org, mcgrof@kernel.org, dmitry.torokhov@gmail.com,
        atomlin@redhat.com, yangtiezhu@loongson.cn, davidgow@google.com,
        sander@svanheule.net, Jason@zx2c4.com, isabbasso@riseup.net,
        hare@suse.de, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 22/32] kmsan: disable instrumentation of unsupported common kernel code
Date:   Mon, 17 Oct 2022 20:07:19 -0400
Message-Id: <20221018000729.2730519-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

[ Upstream commit 79dbd006a6d6f51777ba4948046561b6d9270504 ]

EFI stub cannot be linked with KMSAN runtime, so we disable
instrumentation for it.

Instrumenting kcov, stackdepot or lockdep leads to infinite recursion
caused by instrumentation hooks calling instrumented code again.

Link: https://lkml.kernel.org/r/20220915150417.722975-13-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 1 +
 kernel/Makefile                       | 1 +
 kernel/locking/Makefile               | 3 ++-
 lib/Makefile                          | 3 +++
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 2c67f71f2375..2c1eb1fb0f22 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -53,6 +53,7 @@ GCOV_PROFILE			:= n
 # Sanitizer runtimes are unavailable and cannot be linked here.
 KASAN_SANITIZE			:= n
 KCSAN_SANITIZE			:= n
+KMSAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 318789c728d3..d754e0be1176 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -38,6 +38,7 @@ KCOV_INSTRUMENT_kcov.o := n
 KASAN_SANITIZE_kcov.o := n
 KCSAN_SANITIZE_kcov.o := n
 UBSAN_SANITIZE_kcov.o := n
+KMSAN_SANITIZE_kcov.o := n
 CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
 # Don't instrument error handlers
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index d51cabf28f38..ea925731fa40 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -5,8 +5,9 @@ KCOV_INSTRUMENT		:= n
 
 obj-y += mutex.o semaphore.o rwsem.o percpu-rwsem.o
 
-# Avoid recursion lockdep -> KCSAN -> ... -> lockdep.
+# Avoid recursion lockdep -> sanitizer -> ... -> lockdep.
 KCSAN_SANITIZE_lockdep.o := n
+KMSAN_SANITIZE_lockdep.o := n
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = $(CC_FLAGS_FTRACE)
diff --git a/lib/Makefile b/lib/Makefile
index ffabc30a27d4..fcebece0f5b6 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -275,6 +275,9 @@ obj-$(CONFIG_POLYNOMIAL) += polynomial.o
 CFLAGS_stackdepot.o += -fno-builtin
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
+# In particular, instrumenting stackdepot.c with KMSAN will result in infinite
+# recursion.
+KMSAN_SANITIZE_stackdepot.o := n
 KCOV_INSTRUMENT_stackdepot.o := n
 
 obj-$(CONFIG_REF_TRACKER) += ref_tracker.o
-- 
2.35.1

