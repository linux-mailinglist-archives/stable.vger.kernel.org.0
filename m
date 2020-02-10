Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEDA157B26
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbgBJN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:27:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgBJMg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:27 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 894FC21734;
        Mon, 10 Feb 2020 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338186;
        bh=xcdR/fqcrQT5DMsxHRLC8z4taZHvVyE52sWGVDYPjp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1X/swcdpWzZylvSyJ1CEFFICuMUIqshJHw1+iY3vYLnpqTLHR+Bbtipt19WQNdve
         cpQufiYn8fdBL5PkGr7didV36d2xJLuELHbhBcXK1NAeuQRwVu7BspgxXasiuTNB0V
         u7Fc1hm0o5f5ySJHybHsYQSaYoX35Pku7pKK8Ots=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/195] KVM: nVMX: vmread should not set rflags to specify success in case of #PF
Date:   Mon, 10 Feb 2020 04:34:03 -0800
Message-Id: <20200210122323.320745076@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit a4d956b9390418623ae5d07933e2679c68b6f83c ]

In case writing to vmread destination operand result in a #PF, vmread
should not call nested_vmx_succeed() to set rflags to specify success.
Similar to as done in VMPTRST (See handle_vmptrst()).

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fa2abed1a14da..2660c01eadaeb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8793,8 +8793,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
 		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
 						(is_long_mode(vcpu) ? 8 : 4),
-						&e))
+						&e)) {
 			kvm_inject_page_fault(vcpu, &e);
+			return 1;
+		}
 	}
 
 	nested_vmx_succeed(vcpu);
-- 
2.20.1



