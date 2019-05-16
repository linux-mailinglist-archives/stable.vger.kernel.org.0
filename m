Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB26520C27
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfEPQCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42856 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0006yk-Uu; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001MY-CH; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Borislav Petkov" <bp@alien8.de>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Jason Baron" <jbaron@akamai.com>, "Mel Gorman" <mgorman@suse.de>
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.466502981@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 03/86] jump_label: Fix small typos in the documentation
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

commit fd3cbdc0d1b5254a2e8793df58c409b469899a3f upstream.

Was reading through the documentation of this code and noticed
a few typos, missing commas, etc.

Cc: Jason Baron <jbaron@akamai.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/jump_label.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -8,28 +8,28 @@
  * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
  *
  * Jump labels provide an interface to generate dynamic branches using
- * self-modifying code. Assuming toolchain and architecture support the result
- * of a "if (static_key_false(&key))" statement is a unconditional branch (which
+ * self-modifying code. Assuming toolchain and architecture support, the result
+ * of a "if (static_key_false(&key))" statement is an unconditional branch (which
  * defaults to false - and the true block is placed out of line).
  *
  * However at runtime we can change the branch target using
  * static_key_slow_{inc,dec}(). These function as a 'reference' count on the key
- * object and for as long as there are references all branches referring to
+ * object, and for as long as there are references all branches referring to
  * that particular key will point to the (out of line) true block.
  *
- * Since this relies on modifying code the static_key_slow_{inc,dec}() functions
+ * Since this relies on modifying code, the static_key_slow_{inc,dec}() functions
  * must be considered absolute slow paths (machine wide synchronization etc.).
- * OTOH, since the affected branches are unconditional their runtime overhead
+ * OTOH, since the affected branches are unconditional, their runtime overhead
  * will be absolutely minimal, esp. in the default (off) case where the total
  * effect is a single NOP of appropriate size. The on case will patch in a jump
  * to the out-of-line block.
  *
- * When the control is directly exposed to userspace it is prudent to delay the
+ * When the control is directly exposed to userspace, it is prudent to delay the
  * decrement to avoid high frequency code modifications which can (and do)
  * cause significant performance degradation. Struct static_key_deferred and
  * static_key_slow_dec_deferred() provide for this.
  *
- * Lacking toolchain and or architecture support, it falls back to a simple
+ * Lacking toolchain and or architecture support, jump labels fall back to a simple
  * conditional branch.
  *
  * struct static_key my_key = STATIC_KEY_INIT_TRUE;
@@ -43,8 +43,7 @@
  *
  * Not initializing the key (static data is initialized to 0s anyway) is the
  * same as using STATIC_KEY_INIT_FALSE.
- *
-*/
+ */
 
 #include <linux/types.h>
 #include <linux/compiler.h>

