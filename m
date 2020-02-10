Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA6615774E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgBJM7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:59:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729237AbgBJMlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:11 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 532A620733;
        Mon, 10 Feb 2020 12:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338471;
        bh=qR8NXDPCQMI8FGPV19d0pW79RHVbnYIvHzvQJh07a0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKyWhmAX1ik6asdzcD70wK5CNHYQ4KcM2oAD26LWa6hOeqSQSECJHq4ispYTsxe3b
         e+bMH1BWCweTn7Fgvuv+M/jaXWiVfrqT089zZZuutDMfCTI6ZhelABHuFzy3Z38x+r
         YOSoSH8GkJArrzg2rmqqcbpK4cFl1jjGG8TSJwJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 236/367] KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF attacks in x86.c
Date:   Mon, 10 Feb 2020 04:32:29 -0800
Message-Id: <20200210122445.979512283@linuxfoundation.org>
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

commit 6ec4c5eee1750d5d17951c4e1960d953376a0dda upstream.

This fixes a Spectre-v1/L1TF vulnerability in set_msr_mce() and
get_msr_mce().
Both functions contain index computations based on the
(attacker-controlled) MSR number.

Fixes: 890ca9aefa78 ("KVM: Add MCE support")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2489,7 +2489,10 @@ static int set_msr_mce(struct kvm_vcpu *
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = msr - MSR_IA32_MC0_CTL;
+			u32 offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL,
+				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+
 			/* only 0 or all 1s can be written to IA32_MCi_CTL
 			 * some Linux kernels though clear bit 10 in bank 4 to
 			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
@@ -2930,7 +2933,10 @@ static int get_msr_mce(struct kvm_vcpu *
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = msr - MSR_IA32_MC0_CTL;
+			u32 offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL,
+				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+
 			data = vcpu->arch.mce_banks[offset];
 			break;
 		}


