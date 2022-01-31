Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DD44A44A6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359052AbiAaLbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378742AbiAaL3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1047FC02C308;
        Mon, 31 Jan 2022 03:17:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A81B8B82A5D;
        Mon, 31 Jan 2022 11:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AE8C340E8;
        Mon, 31 Jan 2022 11:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627874;
        bh=mcIynJX9/ae1Tt6SIcDzhd8KHQ7zHoNNEnRPfxvnOd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJTB0l0xkUgJt5yuu8Kcr35iOQ4SurIcokJ/kGfBz2hzaqIlzLS2F4eGs3O0WMrDq
         PWBFJ6jw2+3OalH5x0riY14l8/gTuLEy7f5mYnjF0WP/Y33B/ffRiv2cR82G2IwMhS
         z4Ps0LGjiffKqrEH7MWTRDXPpeu3D8HmLGcMKPdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Valeev <lemniscattaden@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 051/200] KVM: x86: nSVM: skip eax alignment check for non-SVM instructions
Date:   Mon, 31 Jan 2022 11:55:14 +0100
Message-Id: <20220131105235.285631010@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Valeev <lemniscattaden@gmail.com>

commit 47c28d436f409f5b009dc82bd82d4971088aa391 upstream.

The bug occurs on #GP triggered by VMware backdoor when eax value is
unaligned. eax alignment check should not be applied to non-SVM
instructions because it leads to incorrect omission of the instructions
emulation.
Apply the alignment check only to SVM instructions to fix.

Fixes: d1cba6c92237 ("KVM: x86: nSVM: test eax for 4K alignment for GP errata workaround")
Signed-off-by: Denis Valeev <lemniscattaden@gmail.com>
Message-Id: <Yexlhaoe1Fscm59u@q>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2306,10 +2306,6 @@ static int gp_interception(struct kvm_vc
 	if (error_code)
 		goto reinject;
 
-	/* All SVM instructions expect page aligned RAX */
-	if (svm->vmcb->save.rax & ~PAGE_MASK)
-		goto reinject;
-
 	/* Decode the instruction for usage later */
 	if (x86_decode_emulated_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
 		goto reinject;
@@ -2327,8 +2323,13 @@ static int gp_interception(struct kvm_vc
 		if (!is_guest_mode(vcpu))
 			return kvm_emulate_instruction(vcpu,
 				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
-	} else
+	} else {
+		/* All SVM instructions expect page aligned RAX */
+		if (svm->vmcb->save.rax & ~PAGE_MASK)
+			goto reinject;
+
 		return emulate_svm_instr(vcpu, opcode);
+	}
 
 reinject:
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);


