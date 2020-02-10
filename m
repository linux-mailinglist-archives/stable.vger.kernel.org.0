Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B04157577
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgBJMlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbgBJMlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:08 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C672F20842;
        Mon, 10 Feb 2020 12:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338467;
        bh=rGLiivk6f7DgkYW7sEW76EjeSIiunVd5IN341oIo/WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRjy4vSSrAJIoHn3ZE1BfULyZ8yo0NTrEWgs4da8NQJvqEa9REkhz9lxruWILHW2P
         TgMr6PLGaqgGhXsvzW0q31OIaj55BSsB3bMbmJJpja50BKdtOSSaylHvaScA+inJ1W
         vXx4c4vW/9V3wU1FosQ8RmYz9Up7SX8s7LaAj9n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 230/367] KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF attacks
Date:   Mon, 10 Feb 2020 04:32:23 -0800
Message-Id: <20200210122445.538817343@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -1047,9 +1047,11 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu
 
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
@@ -1086,9 +1088,11 @@ EXPORT_SYMBOL_GPL(kvm_set_dr);
 
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


