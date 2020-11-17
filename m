Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E902B6221
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgKQNZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:25:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730786AbgKQNZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:25:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992952467A;
        Tue, 17 Nov 2020 13:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619542;
        bh=TmeKBkAzS56P7mnkUjDB+aQEQQUUKZkArc3fKZZWzqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfGIQtrt50p2Uh2cLYRjX8a5uWDdllTBdCQMM6DqlnyP8wVoW0B7qR3E7TbdmOgqy
         r2Tetszw1yffVNLnyqxMmloFo5FTzZ0RxqdzJjMRJk0KW/387zGeBhf9congNQcYQD
         BNn+odKqaQhJbooA+AA/SQ8lg4ORtBZ9esp4ipJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/151] KVM: x86: dont expose MSR_IA32_UMWAIT_CONTROL unconditionally
Date:   Tue, 17 Nov 2020 14:04:34 +0100
Message-Id: <20201117122123.570227176@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit f4cfcd2d5aea4e96c5d483c476f3057b6b7baf6a ]

This msr is only available when the host supports WAITPKG feature.

This breaks a nested guest, if the L1 hypervisor is set to ignore
unknown msrs, because the only other safety check that the
kernel does is that it attempts to read the msr and
rejects it if it gets an exception.

Cc: stable@vger.kernel.org
Fixes: 6e3ba4abce ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20200523161455.3940-3-mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit f4cfcd2d5aea4e96c5d483c476f3057b6b7baf6a
use boot_cpu_has for checking the feature)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 12e83297ea020..880a24889291c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5235,6 +5235,10 @@ static void kvm_init_msr_list(void)
 			if (!kvm_x86_ops->rdtscp_supported())
 				continue;
 			break;
+		case MSR_IA32_UMWAIT_CONTROL:
+			if (!boot_cpu_has(X86_FEATURE_WAITPKG))
+				continue;
+			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
 			if (!kvm_x86_ops->pt_supported())
-- 
2.27.0



