Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA8A3A929
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388589AbfFIRHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388931AbfFIRF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB783206C3;
        Sun,  9 Jun 2019 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099958;
        bh=CfTl+fpW6LjVBvYMIX4vzX8rNYYe/sXxr5dMJWGW3Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bX18AZYACaBhJ1c/IwSneT2i6mTAeaJmAoHIHudGMzJ7ru9abD1kY8QjTSFtLc8bs
         hVBJLgoYJxco3fXmxAI0ucK1gwBBQv09kn0jP9RvJ7jqMqz/4YZ7feC7T1ZZIyhGX3
         sq+RdXxIcUNbTTZ+AVROQNgPKyN5d+ITvImpisSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alec Ari <neotheuser@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 225/241] Revert "x86/build: Move _etext to actual end of .text"
Date:   Sun,  9 Jun 2019 18:42:47 +0200
Message-Id: <20190609164155.196404269@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 392bef709659abea614abfe53cf228e7a59876a4.

It seems to cause lots of problems when using the gold linker, and no
one really needs this at the moment, so just revert it from the stable
trees.

Cc: Sami Tolvanen <samitolvanen@google.com>
Reported-by: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Alec Ari <neotheuser@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/vmlinux.lds.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -110,10 +110,10 @@ SECTIONS
 		*(.text.__x86.indirect_thunk)
 		__indirect_thunk_end = .;
 #endif
-	} :text = 0x9090
 
-	/* End of text section */
-	_etext = .;
+		/* End of text section */
+		_etext = .;
+	} :text = 0x9090
 
 	NOTES :text :note
 


