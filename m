Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C8E37C731
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbhELP7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237639AbhELP4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8712E6192E;
        Wed, 12 May 2021 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833292;
        bh=XjcTsIZP995vaSJ04Gn8Q+wc3g96iBVdzPX/2ic9Pdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFoKivEWR/LYW4fsNnFC8DNoUNQ14dPbxsJcf0G5dYlE8BHP5cGJ5Xf6jy+qPnFFc
         4CUJ197eubiuE2CdumVb1X67PYryB8TZXwxPa6mr5hctbJNXSvisxGUnMYLzPBl8Zm
         GrSzIdqzosmgmoSqmzcomBgcJSTGOmtrly5Y4Jfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 5.11 091/601] KVM: s390: fix guarded storage control register handling
Date:   Wed, 12 May 2021 16:42:48 +0200
Message-Id: <20210512144830.823268433@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit 44bada28219031f9e8e86b84460606efa57b871e upstream.

store_regs_fmt2() has an ordering problem: first the guarded storage
facility is enabled on the local cpu, then preemption disabled, and
then the STGSC (store guarded storage controls) instruction is
executed.

If the process gets scheduled away between enabling the guarded
storage facility and before preemption is disabled, this might lead to
a special operation exception and therefore kernel crash as soon as
the process is scheduled back and the STGSC instruction is executed.

Fixes: 4e0b1ab72b8a ("KVM: s390: gs support for kvm guests")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Cc: <stable@vger.kernel.org> # 4.12
Link: https://lore.kernel.org/r/20210415080127.1061275-1-hca@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4310,16 +4310,16 @@ static void store_regs_fmt2(struct kvm_v
 	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
 	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
 	if (MACHINE_HAS_GS) {
+		preempt_disable();
 		__ctl_set_bit(2, 4);
 		if (vcpu->arch.gs_enabled)
 			save_gs_cb(current->thread.gs_cb);
-		preempt_disable();
 		current->thread.gs_cb = vcpu->arch.host_gscb;
 		restore_gs_cb(vcpu->arch.host_gscb);
-		preempt_enable();
 		if (!vcpu->arch.host_gscb)
 			__ctl_clear_bit(2, 4);
 		vcpu->arch.host_gscb = NULL;
+		preempt_enable();
 	}
 	/* SIE will save etoken directly into SDNX and therefore kvm_run */
 }


