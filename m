Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78F35F998F
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiJJHOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiJJHNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:13:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937D524084;
        Mon, 10 Oct 2022 00:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DB93B80E62;
        Mon, 10 Oct 2022 07:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDD0C433C1;
        Mon, 10 Oct 2022 07:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385647;
        bh=E44DQ4Za03GQzbvMam2sCoX3jPZyCievlyAL0u9o1Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+PC0lsL2MmrWcbIreLDOVjjuO5I8x/e12TEPXB1ZjTPllAOcCqeDj+yzBSXzIGuc
         N7My4T2OfHjg3RF1qtJ+6majQMaqSBy6KHKxAD8TsYPlNDZXahj1Y3SvUPpJ+hhq7V
         2J9zuMQSzGhdrl3n58pUsz2q+k1eEiZAcGFHLhww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 28/48] KVM: s390: Pass initialized arg even if unused
Date:   Mon, 10 Oct 2022 09:05:26 +0200
Message-Id: <20221010070334.431830252@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



