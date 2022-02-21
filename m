Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7E54BDE84
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242693AbiBUJN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:13:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349056AbiBUJMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:12:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB28229C97;
        Mon, 21 Feb 2022 01:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45EEE60FB6;
        Mon, 21 Feb 2022 09:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1D0C340E9;
        Mon, 21 Feb 2022 09:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434288;
        bh=BlVGSWzcKf/HzPDNKVqs/ptJwKBbwsdtW1dVNKbX9Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVfWQGN47SNDDdqBrWGri5ozVJmIpOOjbTxlUlMt8M+SJCU3TWPF2ioVDhXioWJIr
         RHSr8TV8TyfUQU8jk4w79EHvy7PCZG6yCmXOnJx02lcpj9JaQJkZtiZWoV4PJYIsel
         B+Du0PGSBo6/+rmBB6GlJVDXdIrZdtwTPT6RfM3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 5.10 077/121] KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests
Date:   Mon, 21 Feb 2022 09:49:29 +0100
Message-Id: <20220221084923.816329383@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 55467fcd55b89c622e62b4afe60ac0eb2fae91f2 upstream.

Always signal that emulation is possible for !SEV guests regardless of
whether or not the CPU provided a valid instruction byte stream.  KVM can
read all guest state (memory and registers) for !SEV guests, i.e. can
fetch the code stream from memory even if the CPU failed to do so because
of the SMAP errata.

Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Message-Id: <20220120010719.711476-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[jwang: adjust context for kernel 5.10.101]
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4103,6 +4103,10 @@ static bool svm_can_emulate_instruction(
 	bool smep, smap, is_user;
 	unsigned long cr4;
 
+	/* Emulation is always possible when KVM has access to all guest state. */
+	if (!sev_guest(vcpu->kvm))
+		return true;
+
 	/*
 	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
 	 *
@@ -4151,9 +4155,6 @@ static bool svm_can_emulate_instruction(
 	smap = cr4 & X86_CR4_SMAP;
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
-		if (!sev_guest(vcpu->kvm))
-			return true;
-
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
 
 		/*


