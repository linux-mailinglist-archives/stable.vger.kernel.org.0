Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C8B37CB3E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242512AbhELQe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241569AbhELQ1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A1E461A13;
        Wed, 12 May 2021 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834849;
        bh=R4wTKQ0YFjwYNyattlZQ1c75MroXM4RY9p9Y5WHrNpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRhd+auUdQXwQGPtbdYWEZ2y19uECeiOr9BiTWxLiZPeG/SZ71MAz+WBTpRRhh86y
         4x2WlNUhl1+urrJwCtioXYWx43iYfmqjvMqbQUkrGERdiG9i2jO4DlPdfmJKJcpUTc
         j1MoFa3ScHZkLLbdSHV8boFwiwzUl4ooPNcwb+Uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 107/677] KVM: x86/xen: Drop RAX[63:32] when processing hypercall
Date:   Wed, 12 May 2021 16:42:33 +0200
Message-Id: <20210512144840.778755308@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 6b48fd4cb206485c357420d91ea766ef81b20dc3 upstream.

Truncate RAX to 32 bits, i.e. consume EAX, when retrieving the hypecall
index for a Xen hypercall.  Per Xen documentation[*], the index is EAX
when the vCPU is not in 64-bit mode.

[*] http://xenbits.xenproject.org/docs/sphinx-unstable/guest-guide/x86/hypercall-abi.html

Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -673,7 +673,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *v
 	bool longmode;
 	u64 input, params[6];
 
-	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
+	input = (u64)kvm_register_readl(vcpu, VCPU_REGS_RAX);
 
 	/* Hyper-V hypercalls get bit 31 set in EAX */
 	if ((input & 0x80000000) &&


