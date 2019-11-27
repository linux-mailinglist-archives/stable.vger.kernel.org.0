Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4277110BDE2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfK0UyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:54:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730814AbfK0UyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:54:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 051B62086A;
        Wed, 27 Nov 2019 20:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888057;
        bh=/owAWAfWpzYBTAYkM82lVwXJD9Kz4nA/JxzbBtagY9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqcTOVvjDeEDuqRNvBMphExFLh1HJnNlCol/EuVSucQWTguhmBaU1H1xAYvLwuGlc
         dgKg/CaAhviPFgQbCZwbOsvjro8MvvgxXy8r6SUmwwD8d2miSZWgS4bIeOm3AmgNkx
         Hx0FCZEe3gXE2XTklVvfx/c5PF70Yw64hHsdfLWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 4.14 182/211] x86/cpu_entry_area: Add guard page for entry stack on 32bit
Date:   Wed, 27 Nov 2019 21:31:55 +0100
Message-Id: <20191127203110.976968442@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 880a98c339961eaa074393e3a2117cbe9125b8bb upstream.

The entry stack in the cpu entry area is protected against overflow by the
readonly GDT on 64-bit, but on 32-bit the GDT needs to be writeable and
therefore does not trigger a fault on stack overflow.

Add a guard page.

Fixes: c482feefe1ae ("x86/entry/64: Make cpu_entry_area.tss read-only")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/cpu_entry_area.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -20,8 +20,12 @@ struct cpu_entry_area {
 
 	/*
 	 * The GDT is just below entry_stack and thus serves (on x86_64) as
-	 * a a read-only guard page.
+	 * a read-only guard page. On 32-bit the GDT must be writeable, so
+	 * it needs an extra guard page.
 	 */
+#ifdef CONFIG_X86_32
+	char guard_entry_stack[PAGE_SIZE];
+#endif
 	struct entry_stack_page entry_stack_page;
 
 	/*


