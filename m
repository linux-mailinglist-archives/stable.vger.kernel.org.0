Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488FA261C9C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbgIHTXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731030AbgIHQBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3194F241A4;
        Tue,  8 Sep 2020 15:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579536;
        bh=G3yYAauvg1nc0U6RbIDLTD7OSZHU2kfssKheN+EhsM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoHLGhELAqmeaKJEyJJhiDhLxBWoHnqb9wwRFk2lrZUusYOGTYmU5cZSEjOMdJQxt
         7lEwtV88hVbqa4RtbbutUkmy1JY76p6coUawbfSdVQAxLxm/V97hDluYPgl/PG3ZH+
         l7RLnsWlGIDZOl7N790ULSsAdsySSkHToUYSxvo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 5.8 119/186] x86/entry: Fix AC assertion
Date:   Tue,  8 Sep 2020 17:24:21 +0200
Message-Id: <20200908152247.404223856@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 662a0221893a3d58aa72719671844264306f6e4b upstream.

The WARN added in commit 3c73b81a9164 ("x86/entry, selftests: Further
improve user entry sanity checks") unconditionally triggers on a IVB
machine because it does not support SMAP.

For !SMAP hardware the CLAC/STAC instructions are patched out and thus if
userspace sets AC, it is still have set after entry.

Fixes: 3c73b81a9164 ("x86/entry, selftests: Further improve user entry sanity checks")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200902133200.666781610@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/common.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -55,8 +55,16 @@ static noinstr void check_user_regs(stru
 		 * state, not the interrupt state as imagined by Xen.
 		 */
 		unsigned long flags = native_save_fl();
-		WARN_ON_ONCE(flags & (X86_EFLAGS_AC | X86_EFLAGS_DF |
-				      X86_EFLAGS_NT));
+		unsigned long mask = X86_EFLAGS_DF | X86_EFLAGS_NT;
+
+		/*
+		 * For !SMAP hardware we patch out CLAC on entry.
+		 */
+		if (boot_cpu_has(X86_FEATURE_SMAP) ||
+		    (IS_ENABLED(CONFIG_64_BIT) && boot_cpu_has(X86_FEATURE_XENPV)))
+			mask |= X86_EFLAGS_AC;
+
+		WARN_ON_ONCE(flags & mask);
 
 		/* We think we came from user mode. Make sure pt_regs agrees. */
 		WARN_ON_ONCE(!user_mode(regs));


