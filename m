Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3128B420F4D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhJDNdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237044AbhJDNb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E8D463215;
        Mon,  4 Oct 2021 13:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353246;
        bh=UPMXDFjMj4uUQEIY9z8v9Xv8Ch6dZZuSXPPiC+3LamM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uc4dORGuejC3shWoOQCYwo0KBv3u6EmUgKV3bMg7yh5xy+ZbjKncRoFj/iOb5Usf5
         ekpQVIT46IRxNSyRFZXFy5bEhNRa9uCyG7g81P5pfQfTLCWroSSN+ZuMSKj/I/kIiS
         9Bz4uK7ZPo7oUW28eqjHgUPgev9AzXiOJZwwTZHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 052/172] KVM: x86: Clear KVMs cached guest CR3 at RESET/INIT
Date:   Mon,  4 Oct 2021 14:51:42 +0200
Message-Id: <20211004125046.675618539@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 03a6e84069d1870f5b3d360e64cb330b66f76dee upstream.

Explicitly zero the guest's CR3 and mark it available+dirty at RESET/INIT.
Per Intel's SDM and AMD's APM, CR3 is zeroed at both RESET and INIT.  For
RESET, this is a nop as vcpu is zero-allocated.  For INIT, the bug has
likely escaped notice because no firmware/kernel puts its page tables root
at PA=0, let alone relies on INIT to get the desired CR3 for such page
tables.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210921000303.400537-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10873,6 +10873,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
 
+	vcpu->arch.cr3 = 0;
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+
 	/*
 	 * Reset the MMU context if paging was enabled prior to INIT (which is
 	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the


