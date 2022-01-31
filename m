Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344E14A428E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376291AbiAaLMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377541AbiAaLKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1278CC06174E;
        Mon, 31 Jan 2022 03:08:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4562B82A5E;
        Mon, 31 Jan 2022 11:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DB0C340EF;
        Mon, 31 Jan 2022 11:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627292;
        bh=HRSLQn0z6LNxbCa6iskITmAgvh9vAe/2BIM6raJ4kg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRm3yV6GQY9vw55IpA7NKuHGZk/XH50/MCFH83q3ICw5riBF/YOesoiVzFC68633B
         niXgwc9A1yzzPxI+19M7/rfNQuUv/M+PZ2Oi8m+uuwwcJ7BtDDVtOoiGqipkjwgglw
         YLBcmGDXPvgEugY8L6ENtyqfdblCbIPr3lyHCj5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Valeev <lemniscattaden@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 037/171] KVM: x86: nSVM: skip eax alignment check for non-SVM instructions
Date:   Mon, 31 Jan 2022 11:55:02 +0100
Message-Id: <20220131105231.271283678@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
@@ -2238,10 +2238,6 @@ static int gp_interception(struct kvm_vc
 	if (error_code)
 		goto reinject;
 
-	/* All SVM instructions expect page aligned RAX */
-	if (svm->vmcb->save.rax & ~PAGE_MASK)
-		goto reinject;
-
 	/* Decode the instruction for usage later */
 	if (x86_decode_emulated_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
 		goto reinject;
@@ -2259,8 +2255,13 @@ static int gp_interception(struct kvm_vc
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


