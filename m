Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78884BBA69
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiBROIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:08:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiBROIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:08:10 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E672245A5
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:07:53 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qk11so15382372ejb.2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pjxl5aC6FG6s9X0FhLwCqFHefI1WSbCAr7eiD5y2+3o=;
        b=CiZjVPN/tSsNYup23xFBonAykV5qAU62MVipwMpsd3rGmqY4xg5bd+iJL40T/KJ265
         RwcHwxUe9FcWi34dhm8vWjK1SZG2/BdBRsfr4OE62Gj/31at4m1djtmISXn5Zpg4GJnr
         +wZThKJAs662QA5WiEK5QjNUHsPyfy5LIHxCUBZGTE1oJVevBy0/SK2vqE+SSx3KiAi7
         wOP8GSI4JRPK55SxrquZyxf2bZEqyjEKKYGOfLyLotysSGXPq02yiRQ8YOdFPU+M+Npo
         Tnd7+viEmYLw2SwrCAemoLUy0M8HWtKOQzOwvk/DXzDjXzH6nu9kc0wG86EbRZSxDGA7
         bajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pjxl5aC6FG6s9X0FhLwCqFHefI1WSbCAr7eiD5y2+3o=;
        b=AXPIdsqrKJVpkqzxo8WmnYdDboOSkRD+D+FWk5tGKbWOmXUaNFWH5Sleid+ZU0kOD8
         5sOk1mN1AnPSSQ2cCLGuaKKwGvA4o2xvdxhT1z/P+/6JnhYlIQx6oVoA6FXSnGPbmHBx
         R9DOQOZGfFlbrUAGPYlgDZ1mTU14Susj5xboEuRTR+3pIJWIjBByPD4UbwBV0/UWVpU3
         mLXAzJS25c1amS+CKFkjSgmOug74F3W7T/BW7/TPrc/R7MYIaljJszhWaHaXGh0gKWV8
         aow1hv8PsfElCkHt7M6O3AGnczDL9BrfOdHTa+eN+SY3wc6TFtyBfjLr9x+h5eTclFHJ
         tXiQ==
X-Gm-Message-State: AOAM531msHg4DcKuMTTYEcv7Wm5w0KmKqMEo/Vqj8D1CfhuOB5C9HHqo
        3MzC6i+P86DDrIVsEbJ02M26/bekSBtagg==
X-Google-Smtp-Source: ABdhPJyz2GBEJJKX+o6bTrsh8IFbfcToNCuJTldsd5mlx2I00Eu5vqt0bBqCrYAqdvQfGUrA3/y0Ig==
X-Received: by 2002:a17:907:30cc:b0:6ce:d97:cb0f with SMTP id vl12-20020a17090730cc00b006ce0d97cb0fmr6672120ejb.0.1645193271488;
        Fri, 18 Feb 2022 06:07:51 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box (200116b845b0f800acc0184cb7906b69.dip.versatel-1u1.de. [2001:16b8:45b0:f800:acc0:184c:b790:6b69])
        by smtp.gmail.com with ESMTPSA id q16sm1896307ejc.21.2022.02.18.06.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 06:07:51 -0800 (PST)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [stable-5.10] KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests
Date:   Fri, 18 Feb 2022 15:07:50 +0100
Message-Id: <20220218140750.236302-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[jwang: adjust context for kernel 5.10.101]
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d515c8e68314..7773a765f548 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4103,6 +4103,10 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	bool smep, smap, is_user;
 	unsigned long cr4;
 
+	/* Emulation is always possible when KVM has access to all guest state. */
+	if (!sev_guest(vcpu->kvm))
+		return true;
+
 	/*
 	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
 	 *
@@ -4151,9 +4155,6 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	smap = cr4 & X86_CR4_SMAP;
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
-		if (!sev_guest(vcpu->kvm))
-			return true;
-
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
 
 		/*
-- 
2.25.1

