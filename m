Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3BE3A7F8
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732479AbfFIQzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732833AbfFIQzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:55:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92CEB206BB;
        Sun,  9 Jun 2019 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099346;
        bh=hcCWdm8G1C81OZqG9T6IE40vqZ2g7WBEfGBUW8Mt+Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7HaMUTUOWIwaqh6k998TYxrU5KCT+VJKs/uLS9cFC2JW5DxNfkEv0yu0gc6Ff7qa
         LPLo9fHepmTxJmFnbjvBje9IwJ0aJBWuzwbXlasUFZxKEIUfJo2iPhOzSk2HT49Nsj
         IxZ/Q6mkWLpxkQVU/ik4knY95TWB+fkgQ3z92SXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 002/241] x86/speculation/mds: Improve CPU buffer clear documentation
Date:   Sun,  9 Jun 2019 18:39:04 +0200
Message-Id: <20190609164147.855003688@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 9d8d0294e78a164d407133dea05caf4b84247d6a upstream.

On x86_64, all returns to usermode go through
prepare_exit_to_usermode(), with the sole exception of do_nmi().
This even includes machine checks -- this was added several years
ago to support MCE recovery.  Update the documentation.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jon Masters <jcm@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Fixes: 04dcbdb80578 ("x86/speculation/mds: Clear CPU buffers on exit to user")
Link: http://lkml.kernel.org/r/999fa9e126ba6a48e9d214d2f18dbde5c62ac55c.1557865329.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/x86/mds.rst |   39 +++++++--------------------------------
 1 file changed, 7 insertions(+), 32 deletions(-)

--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -142,38 +142,13 @@ Mitigation points
    mds_user_clear.
 
    The mitigation is invoked in prepare_exit_to_usermode() which covers
-   most of the kernel to user space transitions. There are a few exceptions
-   which are not invoking prepare_exit_to_usermode() on return to user
-   space. These exceptions use the paranoid exit code.
-
-   - Non Maskable Interrupt (NMI):
-
-     Access to sensible data like keys, credentials in the NMI context is
-     mostly theoretical: The CPU can do prefetching or execute a
-     misspeculated code path and thereby fetching data which might end up
-     leaking through a buffer.
-
-     But for mounting other attacks the kernel stack address of the task is
-     already valuable information. So in full mitigation mode, the NMI is
-     mitigated on the return from do_nmi() to provide almost complete
-     coverage.
-
-   - Machine Check Exception (#MC):
-
-     Another corner case is a #MC which hits between the CPU buffer clear
-     invocation and the actual return to user. As this still is in kernel
-     space it takes the paranoid exit path which does not clear the CPU
-     buffers. So the #MC handler repopulates the buffers to some
-     extent. Machine checks are not reliably controllable and the window is
-     extremly small so mitigation would just tick a checkbox that this
-     theoretical corner case is covered. To keep the amount of special
-     cases small, ignore #MC.
-
-   - Debug Exception (#DB):
-
-     This takes the paranoid exit path only when the INT1 breakpoint is in
-     kernel space. #DB on a user space address takes the regular exit path,
-     so no extra mitigation required.
+   all but one of the kernel to user space transitions.  The exception
+   is when we return from a Non Maskable Interrupt (NMI), which is
+   handled directly in do_nmi().
+
+   (The reason that NMI is special is that prepare_exit_to_usermode() can
+    enable IRQs.  In NMI context, NMIs are blocked, and we don't want to
+    enable IRQs with NMIs blocked.)
 
 
 2. C-State transition


