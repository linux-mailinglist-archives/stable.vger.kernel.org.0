Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A985157B5F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbgBJN31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbgBJMgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:22 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 313F1215A4;
        Mon, 10 Feb 2020 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338182;
        bh=YqFCPjKgWc4DKAjrGg9o1HNbm1MIWgIOHOp4cprPImA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEp5z2EDdVXkt1QTSWHbdcnSuEbeNqseEqDQP3KlbFl8pj2zKkZZcQ3h07auciNir
         p7BnDnvsWZf9HOR8xskSLIaw4673gd2/1MfQxyzOc3MtfRgTPqxQN+qkdJ4gouYnT5
         1tQR3ffzU5zAlnnJZZrl3UYqyqfzVqPfnKShvvS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 134/195] KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks
Date:   Mon, 10 Feb 2020 04:33:12 -0800
Message-Id: <20200210122318.475526191@linuxfoundation.org>
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

From: Marios Pomonis <pomonis@google.com>

commit 25a5edea71b7c154b6a0b8cec14c711cafa31d26 upstream.

This fixes a Spectre-v1/L1TF vulnerability in fixed_msr_to_seg_unit().
This function contains index computations based on the
(attacker-controlled) MSR number.

Fixes: de9aef5e1ad6 ("KVM: MTRR: introduce fixed_mtrr_segment table")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mtrr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -194,11 +194,15 @@ static bool fixed_msr_to_seg_unit(u32 ms
 		break;
 	case MSR_MTRRfix16K_80000 ... MSR_MTRRfix16K_A0000:
 		*seg = 1;
-		*unit = msr - MSR_MTRRfix16K_80000;
+		*unit = array_index_nospec(
+			msr - MSR_MTRRfix16K_80000,
+			MSR_MTRRfix16K_A0000 - MSR_MTRRfix16K_80000 + 1);
 		break;
 	case MSR_MTRRfix4K_C0000 ... MSR_MTRRfix4K_F8000:
 		*seg = 2;
-		*unit = msr - MSR_MTRRfix4K_C0000;
+		*unit = array_index_nospec(
+			msr - MSR_MTRRfix4K_C0000,
+			MSR_MTRRfix4K_F8000 - MSR_MTRRfix4K_C0000 + 1);
 		break;
 	default:
 		return false;


