Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37B063DEC5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiK3Skl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiK3Skk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:40:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF4597012
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:40:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67DADB81CA6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0148C433D7;
        Wed, 30 Nov 2022 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833637;
        bh=zAQpQivTUrQeULADrqynRP/ht9xmNo+DvDiRY6+dG7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sj3tWcXuTQX+WrSVA8bLaSn1+lZapqf5FuajxhT3hSfnU5+YllZE9y0pbUao/Yfuy
         U7+0aUmtmEZoQXv5mUkOlzdUhuJ+sGdTlGytEVY1mMUpQJubhU7dxOmf0Z6wOEA0BY
         EbEg/yxZGCtwm6OLk290nG578R8WMzMr3Uhb8nns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vincent Donnefort <vdonnefort@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 140/206] KVM: arm64: pkvm: Fixup boot mode to reflect that the kernel resumes from EL1
Date:   Wed, 30 Nov 2022 19:23:12 +0100
Message-Id: <20221130180536.601894233@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/arm.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2000,6 +2000,17 @@ static int pkvm_drop_host_privileges(voi
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


