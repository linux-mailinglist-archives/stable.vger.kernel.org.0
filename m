Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FCF1E2E9A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390475AbgEZS7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389758AbgEZS7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F3F8208B8;
        Tue, 26 May 2020 18:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519560;
        bh=rFkVQNNujsiod5XRz3hEq0OSBNINfauOjQl86zhZ1L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pErk6ewWfcM4pI8xAs7zHemX35HNb7n7oGymWC2fr5x5n6owIF1ldf9+H7+ASnAh1
         L4zmplL+FxNc+ggqEVrHxHd3WApFIrGuZu/2Yu+0latdR5o9gHlIGygVpwHaTo2F4u
         lYN3EpBkynPQPORDjzhbgi6tVRNyoKdX0d/7IEp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 52/64] x86/uaccess, ubsan: Fix UBSAN vs. SMAP
Date:   Tue, 26 May 2020 20:53:21 +0200
Message-Id: <20200526183930.626243998@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit d08965a27e84ca090b504844d50c24fc98587b11 upstream.

UBSAN can insert extra code in random locations; including AC=1
sections. Typically this code is not safe and needs wrapping.

So far, only __ubsan_handle_type_mismatch* have been observed in AC=1
sections and therefore only those are annotated.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[stable backport: only take the lib/Makefile change to resolve gcc-10
 build issues]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Makefile
+++ b/lib/Makefile
@@ -230,5 +230,6 @@ obj-$(CONFIG_UCS2_STRING) += ucs2_string
 obj-$(CONFIG_UBSAN) += ubsan.o
 
 UBSAN_SANITIZE_ubsan.o := n
+CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
 
 obj-$(CONFIG_SBITMAP) += sbitmap.o


