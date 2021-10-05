Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3634223F9
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 12:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhJEK7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 06:59:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50166 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhJEK7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 06:59:47 -0400
Date:   Tue, 05 Oct 2021 10:57:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633431476;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/MH3AcqsYgZPb3nH6khavLyjQPoJ1MtKqyR+74p21ug=;
        b=Nd45NkmnygAmAv6XKAaDIZaK8ugtN4Q4wTWWkV2kgboIDkFb6VWLNTl8d8KGkgNe81yReC
        hNB5h/F5YpClgOowFUl+NQAve3CIdeau00caoP9i4GXzHJxY127y64cDLKR5fyNGBseM0u
        GiiXR/sKycxyi1E9Tr08iDo/4HKym2TyryNh/ewKKXnZisP0kL75RlquAn92chomYQrcc0
        webSIU/HdabXN4sNnINceDbcPM5R0ZnI0l702hyfJyZcwgIniNcfPFSZtzASyERgdziuPS
        FVnj2voqMTm6MQl6NaqTzvRPdAPG65mbokzMfqPgTIQhNXooPZVqMKm59wjPjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633431476;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/MH3AcqsYgZPb3nH6khavLyjQPoJ1MtKqyR+74p21ug=;
        b=Kfe22vG8AQACyO4JD017XIdRN5T/NAi7VTYYesebMdrxKPd1bi28gK5sngXniQAyIBjEDt
        Jnzz0RyWY+T49lAA==
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
Message-ID: <163343147484.25758.10816020611027836077.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     de85c350dde63d7f554d91c333d57ce6ad3bfc62
Gitweb:        https://git.kernel.org/tip/de85c350dde63d7f554d91c333d57ce6ad3bfc62
Author:        Vegard Nossum <vegard.nossum@oracle.com>
AuthorDate:    Mon, 04 Oct 2021 00:34:23 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 05 Oct 2021 12:37:45 +02:00

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
