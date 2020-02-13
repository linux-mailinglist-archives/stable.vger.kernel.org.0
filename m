Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5074A15C6F3
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgBMQFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:05:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbgBMPXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:50 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C0924690;
        Thu, 13 Feb 2020 15:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607429;
        bh=wfrSAr0KNk13gs0Ou2qSbGuJ1cF9Av2hKMxs2i1xMyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvcYOAf5RWcfhEzkQfiqIhh0YaG2abhGJWwgWqi9loUAjtncCBw3jhF6IpCzH0328
         9qvzwDOE8iAeKliAf1CuyZCa4JkbooWRrkbYUm7iV4QcJmPoCoCWR9PFxwCGD5XHpb
         bTZK6KgwsDZBGcdatKZghWyyp6oURh2wOBRz/yK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 045/116] KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF attacks
Date:   Thu, 13 Feb 2020 07:19:49 -0800
Message-Id: <20200213151900.549837543@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit ea740059ecb37807ba47b84b33d1447435a8d868 upstream.

This fixes a Spectre-v1/L1TF vulnerability in __kvm_set_dr() and
kvm_get_dr().
Both kvm_get_dr() and kvm_set_dr() (a wrapper of __kvm_set_dr()) are
exported symbols so KVM should tream them conservatively from a security
perspective.

Fixes: 020df0794f57 ("KVM: move DR register access handling into generic code")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -889,9 +889,11 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu
 
 static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
+	size_t size = ARRAY_SIZE(vcpu->arch.db);
+
 	switch (dr) {
 	case 0 ... 3:
-		vcpu->arch.db[dr] = val;
+		vcpu->arch.db[array_index_nospec(dr, size)] = val;
 		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
 			vcpu->arch.eff_db[dr] = val;
 		break;
@@ -928,9 +930,11 @@ EXPORT_SYMBOL_GPL(kvm_set_dr);
 
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 {
+	size_t size = ARRAY_SIZE(vcpu->arch.db);
+
 	switch (dr) {
 	case 0 ... 3:
-		*val = vcpu->arch.db[dr];
+		*val = vcpu->arch.db[array_index_nospec(dr, size)];
 		break;
 	case 4:
 		/* fall through */


