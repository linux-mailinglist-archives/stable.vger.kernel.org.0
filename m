Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8961D5216F0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242608AbiEJNUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242610AbiEJNTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:19:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC2C16D5C4;
        Tue, 10 May 2022 06:13:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20709615DD;
        Tue, 10 May 2022 13:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF19C385A6;
        Tue, 10 May 2022 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188405;
        bh=Fq+uiXNrrJncXpaGY9VAdua8hHlsJPbzUlEDpb2IISQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KERhoIAg0Y49RkSq4jp/n/UjbhM+2L77xvWtkI8UYSLVjFaUgGpfx5z3M267qdlX8
         h9LTOGff9gR8tm2SH81Lfv6TzRZtFnxqOg/ZH/nDIQDpNLuZWSPAQ7NiAW9mJAqnnH
         Ekd+MFRhGsUihE2RhpG6Ga9gGGiiePyVi0dOMLqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasant Hegde <vasant.hegde@amd.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 62/66] kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU
Date:   Tue, 10 May 2022 15:07:52 +0200
Message-Id: <20220510130731.583338857@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 5a1bde46f98b893cda6122b00e94c0c40a6ead3c ]

On some x86 processors, CPUID leaf 0xA provides information
on Architectural Performance Monitoring features. It
advertises a PMU version which Qemu uses to determine the
availability of additional MSRs to manage the PMCs.

Upon receiving a KVM_GET_SUPPORTED_CPUID ioctl request for
the same, the kernel constructs return values based on the
x86_pmu_capability irrespective of the vendor.

This leaf and the additional MSRs are not supported on AMD
and Hygon processors. If AMD PerfMonV2 is detected, the PMU
version is set to 2 and guest startup breaks because of an
attempt to access a non-existent MSR. Return zeros to avoid
this.

Fixes: a6c06ed1a60a ("KVM: Expose the architectural performance monitoring CPUID leaf")
Reported-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Message-Id: <3fef83d9c2b2f7516e8ff50d60851f29a4bcb716.1651058600.git.sandipan.das@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/cpuid.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a6f8600672d7..c068027ac55f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -502,6 +502,11 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		union cpuid10_eax eax;
 		union cpuid10_edx edx;
 
+		if (!static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+
 		perf_get_x86_pmu_capability(&cap);
 
 		/*
-- 
2.35.1



