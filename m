Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B5363B1A9
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 19:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiK1Swj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 13:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiK1Swh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 13:52:37 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDF92722
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 10:52:35 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3a0e59c5ad7so104468427b3.20
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 10:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g7g4RhlXELbE9mncxtogCkihwk7rwqZo9vNhDg0vpIY=;
        b=gLiQMSjrS7BAc+cDBoYJ8QkRjv/JwyKjdWjThHs+LovqvsEkNVlxUJge/mB1Q944WQ
         pcWxgUlAZtKLAYXGIo9yc2bk3anrMjRex18LhiwM7Y4TOqmrEGwYvtwxbVcz6w6I/wcV
         I6QEo2PRe/hzBm8DiwNMEf/M6BLdqVEF1S53yfQ8qR+7HDz5fD+DGF3W3NWz8aRFPoyT
         7p6gKAA/6aCLb6nvebxH6b49Dos3ihyZAAzWLVKn8i8y08rv8Pas+tRKIOs5h7YxedcM
         QkOHayGMGsuCSZsG0Wi7ax13IK/gW9M3HOoRlisY7aJrtpFN7VMydv6Rf6a7FWzw8oHY
         EGbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g7g4RhlXELbE9mncxtogCkihwk7rwqZo9vNhDg0vpIY=;
        b=EW9dnDQvNvPeo6oFLnOs3Z5/IvivRLqCiD3TsziOO4a+5EsEymtJBW9ptsodyImsgB
         vKMdlkXpd26gjAyHJyY4maezE5ncIKjKfFr37bWQb+7xRA1vJ9R+Nlvr5P21N7vPVM7i
         XmSqlJMHbtZcnfQYHwptyTOO28Kp2jK9LHup0lV+3HYSWle832umWsM3PjSEQlYWOzmG
         54U8nnezluZ2yNiZl7gondpzvlTZK6BrP6eI5iXf1b9XIdyAnqRbS3fgu6s0g2cnk5y9
         ixPDgLtZGlzUUjdiyihochL4UtfnZQ7IAsVWCc6DaqRHFr5BwCwL7QffahqhmV0ZZyy4
         nd5w==
X-Gm-Message-State: ANoB5plnRXy4odGz4GNh+AKMroZZGeUJplrLEj6O0Ou/DKrA4Elbaxz2
        Dd0NcGe4m2/zIr3da/pIqQJUJ/mEtzhPvfnl
X-Google-Smtp-Source: AA0mqf5J/UtgmB5+0wl4kR6SaUn4y3Qnp5fCQ/xbhTh40p8aqVQow4Hi+EI/hSWvHjEMEhiBlcXZU5aOScyDjnws
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a25:7343:0:b0:6f3:aedd:e75 with SMTP id
 o64-20020a257343000000b006f3aedd0e75mr15691319ybc.611.1669661554505; Mon, 28
 Nov 2022 10:52:34 -0800 (PST)
Date:   Mon, 28 Nov 2022 18:52:22 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221128185222.1291038-1-vdonnefort@google.com>
Subject: [PATCH 5.15] KVM: arm64: pkvm: Fixup boot mode to reflect that the
 kernel resumes from EL1
From:   Vincent Donnefort <vdonnefort@google.com>
To:     gregkh@kernel.org
Cc:     kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

The kernel has an awfully complicated boot sequence in order to cope
with the various EL2 configurations, including those that "enhanced"
the architecture. We go from EL2 to EL1, then back to EL2, staying
at EL2 if VHE capable and otherwise go back to EL1.

Here's a paracetamol tablet for you.

The cpu_resume path follows the same logic, because coming up with
two versions of a square wheel is hard.

However, things aren't this straightforward with pKVM, as the host
resume path is always proxied by the hypervisor, which means that
the kernel is always entered at EL1. Which contradicts what the
__boot_cpu_mode[] array contains (it obviously says EL2).

This thus triggers a HVC call from EL1 to EL2 in a vain attempt
to upgrade from EL1 to EL2 VHE, which we are, funnily enough,
reluctant to grant to the host kernel. This is also completely
unexpected, and puzzles your average EL2 hacker.

Address it by fixing up the boot mode at the point the host gets
deprivileged. is_hyp_mode_available() and co already have a static
branch to deal with this, making it pretty safe.

This stable fix doesn't have an upstream version. The entire bootflow
has been reworked from 6.0 and that fixed the boot mode at the same
time, from commit 005e12676af0 ("arm64: head: record CPU boot mode after
enabling the MMU") to be precise. However, the latter is part of a 20
patches long series and can't be simply cherry-pick'ed.

Link: https://lore.kernel.org/r/20220624150651.1358849-1-ardb@kernel.org/
Link: https://lore.kernel.org/r/20221011165400.1241729-1-maz@kernel.org/
Cc: <stable@vger.kernel.org> # 5.15+
Reported-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
[Vincent: Add a paragraph about why this patch is for stable only]
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4cb265e15361..3fe816c244ce 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2000,6 +2000,17 @@ static int pkvm_drop_host_privileges(void)
 	 * once the host stage 2 is installed.
 	 */
 	static_branch_enable(&kvm_protected_mode_initialized);
+
+	/*
+	 * Fixup the boot mode so that we don't take spurious round
+	 * trips via EL2 on cpu_resume. Flush to the PoC for a good
+	 * measure, so that it can be observed by a CPU coming out of
+	 * suspend with the MMU off.
+	 */
+	__boot_cpu_mode[0] = __boot_cpu_mode[1] = BOOT_CPU_MODE_EL1;
+	dcache_clean_poc((unsigned long)__boot_cpu_mode,
+			 (unsigned long)(__boot_cpu_mode + 2));
+
 	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
 	return ret;
 }
-- 
2.38.1.584.g0f3c55d4c2-goog

