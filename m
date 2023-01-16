Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C907366C1B0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjAPOOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjAPONq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:13:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A6725E08;
        Mon, 16 Jan 2023 06:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 203BFB80FA3;
        Mon, 16 Jan 2023 14:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC69C433F2;
        Mon, 16 Jan 2023 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877912;
        bh=ssVnZrCTN+KYvMaSdEtcY+L24YAGnLtGwEcEJ5KZZVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0WZbRtxQWH5VeOUDONg2Z+pnRf6epapKbXWagka0iU8wA013qmeoq8/g0S+Ez8ex
         FCakD8mnEepNV+Kb+YZEs9xDQHepivxRA++m/Rl3pF5goGxlLElDOA9jKCiUzrsVua
         JoBIo4ydEofnrS19xvBzzTsPZAkJYDlwuz2A7HAcRxYuJgcAb5nO0BI1ZGZphrUXf4
         KgR2QGTmeSO79vqxfBYyhsOh8iDuElqNTzgUnFSG1qnA6uDyMNfG6zrENk9BFRLYxf
         rXqffq2o+LnCVlYPhOqm/t5KfQjCQaB0yMtRJkFNPYXrLoaDs1R2Xz8TgkAToULFpa
         wHBOm0JFypOUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, frankja@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/17] KVM: s390: interrupt: use READ_ONCE() before cmpxchg()
Date:   Mon, 16 Jan 2023 09:04:44 -0500
Message-Id: <20230116140448.116034-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140448.116034-1-sashal@kernel.org>
References: <20230116140448.116034-1-sashal@kernel.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 42400d99e9f0728c17240edb9645637ead40f6b9 ]

Use READ_ONCE() before cmpxchg() to prevent that the compiler generates
code that fetches the to be compared old value several times from memory.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230109145456.2895385-1-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/interrupt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index b51ab19eb972..64d1dfe6dca5 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -81,8 +81,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 		struct esca_block *sca = vcpu->kvm->arch.sca;
 		union esca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
+		union esca_sigp_ctrl new_val = {0}, old_val;
 
+		old_val = READ_ONCE(*sigp_ctrl);
 		new_val.scn = src_id;
 		new_val.c = 1;
 		old_val.c = 0;
@@ -93,8 +94,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 		struct bsca_block *sca = vcpu->kvm->arch.sca;
 		union bsca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
+		union bsca_sigp_ctrl new_val = {0}, old_val;
 
+		old_val = READ_ONCE(*sigp_ctrl);
 		new_val.scn = src_id;
 		new_val.c = 1;
 		old_val.c = 0;
@@ -124,16 +126,18 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 		struct esca_block *sca = vcpu->kvm->arch.sca;
 		union esca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl old = *sigp_ctrl;
+		union esca_sigp_ctrl old;
 
+		old = READ_ONCE(*sigp_ctrl);
 		expect = old.value;
 		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
 	} else {
 		struct bsca_block *sca = vcpu->kvm->arch.sca;
 		union bsca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl old = *sigp_ctrl;
+		union bsca_sigp_ctrl old;
 
+		old = READ_ONCE(*sigp_ctrl);
 		expect = old.value;
 		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
 	}
-- 
2.35.1

