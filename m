Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FB4620CCB
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 11:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbiKHKCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 05:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiKHKCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 05:02:06 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BF72871E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 02:02:03 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id c130-20020a1c3588000000b003b56be513e1so6754903wma.0
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 02:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AhfNl4j1BETDRKv2Rd1qN5qVHyUwyY8zDm52r6q0JPo=;
        b=a8+W8Gz4EKIOQU/tbADa6+BxhRfMPLsRm197beK13+n8vi7pMGLRF03T1M1dZOttuH
         GsUnQFZteYt70nDh7OG7dv7C6ETi5bpfiFXHNkY63uCBBiWMbQPsRr+ag+EGPDaky+PI
         OXzBQkcGTjK7twaAprqFL7tO1gfS3h0kUDBSe8ljOF1HevRu2TCTVV9kQpLWICr3R9YT
         qS6B0ut/LIZ8WjsS91ivASp70YFmIm8QEmiaVbY2i+ZlD+pL7+j5oXMJATLVA39R5NMq
         HU6n+kxKvZPJmA2FdIehqA6FQ/UywPu1zI9IQWQTI90IlA6NCUH61mg7pl8ksdP6pD0J
         UBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AhfNl4j1BETDRKv2Rd1qN5qVHyUwyY8zDm52r6q0JPo=;
        b=6oStsu4OcW47nI88ILeQRR+b0krFdiC5TaVFD8+4SlqD/vaUsWF9f7vW4BBCxO5Cg4
         jOFOpO9LG/4WDM66SWzOBLi/U6VMJnjTpg/w6DfwRh31frjojDSaYdA1gLkuuMELtWMS
         pi710UUdtQxSnKQtImBmQlq4uh9StSGRfQTHbCYveb0o2Wss7P/NlcgJFh0pDNrXcRUp
         SEjhvd1ceEs2j+2aRpOpz+uavXg3RovZ+KAiRmJEozR+OgP69rWDy3sIihQzU4FYG8Jr
         7FCDg+97+mpvT5TWgzkEViJzM0j0rLcIT53F6Gu6321aDKJv9SKvFWD1s3SwPWzoENhJ
         Se3A==
X-Gm-Message-State: ACrzQf3xJhMdYJZoCykM9xBhhtZnmjMXarAEqPXrHZMFGAQjaE4Sl5dj
        kgzKfw4nutOqS8/8hP1oRssEIEjpANLUTm6u
X-Google-Smtp-Source: AMsMyM5sDirBelPUT2GuEStgJqeN0a5+M/0a0heV7YsSXWm1FHfDGCau6S6IkNXKnb4r4nSIpzR4uZwZ9oBDMdQv
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:600c:4d86:b0:3cf:7257:ba15 with
 SMTP id v6-20020a05600c4d8600b003cf7257ba15mr31185129wmp.22.1667901721936;
 Tue, 08 Nov 2022 02:02:01 -0800 (PST)
Date:   Tue,  8 Nov 2022 10:01:38 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221108100138.3887862-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the kernel
 resumes from EL1
From:   Vincent Donnefort <vdonnefort@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
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

Cc: <stable@vger.kernel.org> # 5.15+
Reported-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Vincent Donnefort <vdonnefort@google.com>

--- 

This patch doesn't have an upstream version. It's been fixed by the side
effect of another upstream patch. see conversation [1]

[1] https://lore.kernel.org/all/20221011165400.1241729-1-maz@kernel.org/

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
2.38.1.431.g37b22c650d-goog

