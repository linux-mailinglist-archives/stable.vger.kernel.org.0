Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4539A66C17B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjAPOMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjAPOLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:11:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9EA2A9B5;
        Mon, 16 Jan 2023 06:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03EE760FDA;
        Mon, 16 Jan 2023 14:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E7AC43392;
        Mon, 16 Jan 2023 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877871;
        bh=T8dcQhY+g/M+RHVtQdcw+dJXmMpA6Rmp8a77OB9I7kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j79uRc+fe780g2IklB/CLACnLpD0nrVaGcm2ZhZqVMc7qJ0jj+cJpptERefAeuC92
         krb9nrdwuMME3LJDjJ9e50P+RBlhHtCZAZb9GmsWDgKj8+t540hW8Xm/j7EgZgE9iF
         klLVAYgQqctN1HcEgpjdrOeXOkIV3oA2hycqMPzN6EEVU+tNSHXBvezEgaD9W+ow03
         DYelyIrr2q63AUndyJ6o9AEGP0LzDBus7hBjRm4mxpWzOfRcltHkEgZc4NWSQvuJ2c
         DWv+qq1jV/enuxOe+Xbdw9bngm+pXOM4WBV+jun7fjXURyRajqVzsHZaG5cM+pAPEo
         RG2+LWMyhoIZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, frankja@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/24] KVM: s390: interrupt: use READ_ONCE() before cmpxchg()
Date:   Mon, 16 Jan 2023 09:03:53 -0500
Message-Id: <20230116140359.115716-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
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
index 8ce03a5ca863..ca7d09f09809 100644
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

