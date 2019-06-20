Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75324D73A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfFTSQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728759AbfFTSQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:16:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6330F205F4;
        Thu, 20 Jun 2019 18:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054599;
        bh=4i/pOg1BQheMfb1D9CPYgDXBxnXtl0Ni8DVdI9l0Nb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPo7Fmk0mUSMlIE3Adyn5/Pgqfq2qOZdMM908YehAddcR7CZ+tDAs1J5PhkG0EW4B
         SGvJ9DCMbn8M97o+zurdEim37L9GQiQ7Q8Md1m8P45QTlX0lL6LYo7je/BRBs6y91l
         m8BYNc83FbhoRJ0crOG1WFfSpnOY/KNAhAX94pMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 77/98] KVM: PPC: Book3S HV: Dont take kvm->lock around kvm_for_each_vcpu
Date:   Thu, 20 Jun 2019 19:57:44 +0200
Message-Id: <20190620174353.118893627@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5a3f49364c3ffa1107bd88f8292406e98c5d206c ]

Currently the HV KVM code takes the kvm->lock around calls to
kvm_for_each_vcpu() and kvm_get_vcpu_by_id() (which can call
kvm_for_each_vcpu() internally).  However, that leads to a lock
order inversion problem, because these are called in contexts where
the vcpu mutex is held, but the vcpu mutexes nest within kvm->lock
according to Documentation/virtual/kvm/locking.txt.  Hence there
is a possibility of deadlock.

To fix this, we simply don't take the kvm->lock mutex around these
calls.  This is safe because the implementations of kvm_for_each_vcpu()
and kvm_get_vcpu_by_id() have been designed to be able to be called
locklessly.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 9f49087c3a41..6d4f0f72231f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -445,12 +445,7 @@ static void kvmppc_dump_regs(struct kvm_vcpu *vcpu)
 
 static struct kvm_vcpu *kvmppc_find_vcpu(struct kvm *kvm, int id)
 {
-	struct kvm_vcpu *ret;
-
-	mutex_lock(&kvm->lock);
-	ret = kvm_get_vcpu_by_id(kvm, id);
-	mutex_unlock(&kvm->lock);
-	return ret;
+	return kvm_get_vcpu_by_id(kvm, id);
 }
 
 static void init_vpa(struct kvm_vcpu *vcpu, struct lppaca *vpa)
@@ -1502,7 +1497,6 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 mask;
 
-	mutex_lock(&kvm->lock);
 	spin_lock(&vc->lock);
 	/*
 	 * If ILE (interrupt little-endian) has changed, update the
@@ -1542,7 +1536,6 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 		mask &= 0xFFFFFFFF;
 	vc->lpcr = (vc->lpcr & ~mask) | (new_lpcr & mask);
 	spin_unlock(&vc->lock);
-	mutex_unlock(&kvm->lock);
 }
 
 static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
-- 
2.20.1



