Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1DA5F265C
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiJBWw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiJBWvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:51:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF2837F82;
        Sun,  2 Oct 2022 15:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 630D6B80C81;
        Sun,  2 Oct 2022 22:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C854CC433C1;
        Sun,  2 Oct 2022 22:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751020;
        bh=E44DQ4Za03GQzbvMam2sCoX3jPZyCievlyAL0u9o1Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9qQmOylrLvLRhxSbphRR4L+dWg+jOnIXfz0BDv7at6URcmFdm2hnCRulNX25yecb
         tDpMJyWXX0wfCmIEkueU502H9bg5OCW/CNoYeXtSZeK/BUMJuqvLU2yFB8VCXlLDd/
         BzocW1a0il50/T18nxOMp0mcd/EegdNqMAPTEMSmnCFt+6JKGq8NkI96IYqGrOup9y
         R9nNAKANyypsPHqmG984Cl9SgJncp6V63O+2fWYsi91GOWaE0bo4TANPwQ9v1V8/Dd
         7ULVzhj9Tq4ZWSHlKf0BDKzF2mbZHTLsERDDy0MhZozjQqkLavM9nNCFDJW4d4xiYw
         tG/1BAqQHjSjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 22/29] KVM: s390: Pass initialized arg even if unused
Date:   Sun,  2 Oct 2022 18:49:15 -0400
Message-Id: <20221002224922.238837-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

[ Upstream commit b3cefd6bf16e7234ffbd4209f6083060f4e35f59 ]

This silences smatch warnings reported by kbuild bot:
arch/s390/kvm/gaccess.c:859 guest_range_to_gpas() error: uninitialized symbol 'prot'.
arch/s390/kvm/gaccess.c:1064 access_guest_with_key() error: uninitialized symbol 'prot'.

This is because it cannot tell that the value is not used in this case.
The trans_exc* only examine prot if code is PGM_PROTECTION.
Pass a dummy value for other codes.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220825192540.1560559-1-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/gaccess.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 227ed0009354..0e82bf85e59b 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -489,6 +489,8 @@ enum prot_type {
 	PROT_TYPE_ALC  = 2,
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
+	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
+	PROT_NONE,
 };
 
 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -504,6 +506,10 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
+		case PROT_NONE:
+			/* We should never get here, acts like termination */
+			WARN_ON_ONCE(1);
+			break;
 		case PROT_TYPE_IEP:
 			tec->b61 = 1;
 			fallthrough;
@@ -968,8 +974,10 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 				return rc;
 		} else {
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
-			if (kvm_is_error_gpa(vcpu->kvm, gpa))
+			if (kvm_is_error_gpa(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
+				prot = PROT_NONE;
+			}
 		}
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, prot);
@@ -1112,8 +1120,6 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		if (rc == PGM_PROTECTION && try_storage_prot_override)
 			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
 							data, fragment_len, PAGE_SPO_ACC);
-		if (rc == PGM_PROTECTION)
-			prot = PROT_TYPE_KEYC;
 		if (rc)
 			break;
 		len -= fragment_len;
@@ -1123,6 +1129,10 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	if (rc > 0) {
 		bool terminate = (mode == GACC_STORE) && (idx > 0);
 
+		if (rc == PGM_PROTECTION)
+			prot = PROT_TYPE_KEYC;
+		else
+			prot = PROT_NONE;
 		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
 	}
 out_unlock:
-- 
2.35.1

