Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3417242447B
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 19:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbhJFRkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 13:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbhJFRkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 13:40:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9796C061746;
        Wed,  6 Oct 2021 10:39:00 -0700 (PDT)
Date:   Wed, 06 Oct 2021 17:38:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633541939;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HbBcwO46ghlzGlldTW5up+KgrQYVo1AYS64WZHNZw0w=;
        b=xTebzhHaZTQlKTOJWUQgSdFsUmx2nK7S61HwpdAmrAEQEtwckAwJAP86YDVyLFRT0QOnRa
        0ySPZ3RthxEz1gAxGmYyPMuzqKBkPBwHhe0cdZddEjBBFtCA2T3hR7SlnWq4Jd5T9gQW4Q
        yCNjSVjr+3PlvSPouIDHOCDoJcfdCTqtYFWdQt505PwAgR9I7kEjde1Ut3HgjfHz9Ru+QW
        KbdolqBJdaB7tmR9GugdXIbOgSS5qrkUhYhcNkeiZT4Y8FnDTrPLjZV09yjb5Xhj+k2d7O
        eOciI84Bue2OmD7zcoGtzlGCQr8Gi0DP0bBrj1qYVNKMTH6vRIVAPesyv110aQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633541939;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HbBcwO46ghlzGlldTW5up+KgrQYVo1AYS64WZHNZw0w=;
        b=lBozIC/26ZMPHYIdzxs/B1iUJLMhzNSTfua1l/uFV/8UgMClYM39EGVM6xwXwrdaEK88jG
        VVCpNwOOBskEc9Aw==
From:   "tip-bot2 for Vegard Nossum" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/entry: Clear X86_FEATURE_SMAP when CONFIG_X86_SMAP=n
Cc:     Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211003223423.8666-1-vegard.nossum@oracle.com>
References: <20211003223423.8666-1-vegard.nossum@oracle.com>
MIME-Version: 1.0
Message-ID: <163354193843.25758.18095540454061769767.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     3958b9c34c2729597e182cc606cc43942fd19f7c
Gitweb:        https://git.kernel.org/tip/3958b9c34c2729597e182cc606cc43942fd19f7c
Author:        Vegard Nossum <vegard.nossum@oracle.com>
AuthorDate:    Mon, 04 Oct 2021 00:34:23 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 06 Oct 2021 18:46:06 +02:00

x86/entry: Clear X86_FEATURE_SMAP when CONFIG_X86_SMAP=n

Commit

  3c73b81a9164 ("x86/entry, selftests: Further improve user entry sanity checks")

added a warning if AC is set when in the kernel.

Commit

  662a0221893a3d ("x86/entry: Fix AC assertion")

changed the warning to only fire if the CPU supports SMAP.

However, the warning can still trigger on a machine that supports SMAP
but where it's disabled in the kernel config and when running the
syscall_nt selftest, for example:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 49 at irqentry_enter_from_user_mode
  CPU: 0 PID: 49 Comm: init Tainted: G                T 5.15.0-rc4+ #98 e6202628ee053b4f310759978284bd8bb0ce6905
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
  RIP: 0010:irqentry_enter_from_user_mode
  ...
  Call Trace:
   ? irqentry_enter
   ? exc_general_protection
   ? asm_exc_general_protection
   ? asm_exc_general_protectio

IS_ENABLED(CONFIG_X86_SMAP) could be added to the warning condition, but
even this would not be enough in case SMAP is disabled at boot time with
the "nosmap" parameter.

To be consistent with "nosmap" behaviour, clear X86_FEATURE_SMAP when
!CONFIG_X86_SMAP.

Found using entry-fuzz + satrandconfig.

 [ bp: Massage commit message. ]

Fixes: 3c73b81a9164 ("x86/entry, selftests: Further improve user entry sanity checks")
Fixes: 662a0221893a ("x86/entry: Fix AC assertion")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211003223423.8666-1-vegard.nossum@oracle.com
---
 arch/x86/kernel/cpu/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0f88859..b3410f1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -326,6 +326,7 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_SMAP
 		cr4_set_bits(X86_CR4_SMAP);
 #else
+		clear_cpu_cap(c, X86_FEATURE_SMAP);
 		cr4_clear_bits(X86_CR4_SMAP);
 #endif
 	}
