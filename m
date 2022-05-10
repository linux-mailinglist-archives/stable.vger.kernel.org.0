Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9D452180A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242991AbiEJNcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243378AbiEJNam (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750812C511A;
        Tue, 10 May 2022 06:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1555F616D0;
        Tue, 10 May 2022 13:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2103AC385A6;
        Tue, 10 May 2022 13:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188886;
        bh=NmlfjBAVVEP/vw+cxYqZN4npXt02El+JYjH9uacL4go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQCh7XtIEUUU3dr4s85wAprRgDQqiIQ69jkKAiucbhSIPYiU6QM8MeP2GRWVqOOqT
         weD2q6Pz5cB+ah6nxohD3QiA0ciGNJBr6piuZjlDxmWDPc7440d7JbLb+qOXeKpUmN
         66B5h0eG9do6ErMVA5LmiwrBUtM+9IoimhWqek3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasant Hegde <vasant.hegde@amd.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 81/88] kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU
Date:   Tue, 10 May 2022 15:08:06 +0200
Message-Id: <20220510130736.084725368@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
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
index 097eef712cdc..0489ffc3dfe5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -532,6 +532,11 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
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



