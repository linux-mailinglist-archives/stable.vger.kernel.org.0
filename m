Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAF3333E28
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhCJNZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232787AbhCJNZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A4A464FDC;
        Wed, 10 Mar 2021 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382700;
        bh=XQQ9uTjCOGkWb5LHQKTQFVtOqVSsw6/cFLW0mJpYp4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GajVXrZnIOfGoGM5pgzVIOgzbmBcjIgUthBnIKAwKOLkOxjifY62bzHL+vd2eFHGp
         6fqCFDUTnvwuomYv1e0XEBHVLtsrBwjxWeRSoqmSyaBnXormCMR7PZCObHAHRjK5uH
         tn1qNaVvmOJGsgnJW7N1DMowz4QGrs1EOLxm4B08=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/49] KVM: x86: Supplement __cr4_reserved_bits() with X86_FEATURE_PCID check
Date:   Wed, 10 Mar 2021 14:23:41 +0100
Message-Id: <20210310132322.895507927@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 4683d758f48e6ae87d3d3493ffa00aceb955ee16 ]

Commit 7a873e455567 ("KVM: selftests: Verify supported CR4 bits can be set
before KVM_SET_CPUID2") reveals that KVM allows to set X86_CR4_PCIDE even
when PCID support is missing:

==== Test Assertion Failure ====
  x86_64/set_sregs_test.c:41: rc
  pid=6956 tid=6956 - Invalid argument
     1	0x000000000040177d: test_cr4_feature_bit at set_sregs_test.c:41
     2	0x00000000004014fc: main at set_sregs_test.c:119
     3	0x00007f2d9346d041: ?? ??:0
     4	0x000000000040164d: _start at ??:?
  KVM allowed unsupported CR4 bit (0x20000)

Add X86_FEATURE_PCID feature check to __cr4_reserved_bits() to make
kvm_is_valid_cr4() fail.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210201142843.108190-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e7ca622a468f..2249a7d7ca27 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -404,6 +404,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_UMIP;        \
 	if (!__cpu_has(__c, X86_FEATURE_VMX))           \
 		__reserved_bits |= X86_CR4_VMXE;        \
+	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
+		__reserved_bits |= X86_CR4_PCIDE;       \
 	__reserved_bits;                                \
 })
 
-- 
2.30.1



