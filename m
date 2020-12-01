Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7372C9BB3
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389840AbgLAJLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389836AbgLAJLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:11:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37846206D8;
        Tue,  1 Dec 2020 09:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813860;
        bh=97rXMXm2dBPWDSP1AUJYVwLfVwzxgl9TYjZ+v2PpO8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTln4Os3L/eNlWdCs31yJSBqP8D+2DqWa6Zd0uTYy4sLI0O+nIvMVTK/GUBpLvZ6s
         IpM3D7LdUXIK3YmLzhjHoTfgaRDMneNpu8USd8PsHtYalsz2B3jNjXT5foMjz6AvVD
         pmGRXNCubRbfoowkp6IWBOeaEO7r3cOefxBc8y/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Collin Walling <walling@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 077/152] KVM: s390: remove diag318 reset code
Date:   Tue,  1 Dec 2020 09:53:12 +0100
Message-Id: <20201201084721.981329345@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Collin Walling <walling@linux.ibm.com>

[ Upstream commit 6cbf1e960fa52e4c63a6dfa4cda8736375b34ccc ]

The diag318 data must be set to 0 by VM-wide reset events
triggered by diag308. As such, KVM should not handle
resetting this data via the VCPU ioctls.

Fixes: 23a60f834406 ("s390/kvm: diagnose 0x318 sync and reset")
Signed-off-by: Collin Walling <walling@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20201104181032.109800-1-walling@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 08ea6c4735cdc..425d3d75320bf 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3564,7 +3564,6 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->pp = 0;
 		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
 		vcpu->arch.sie_block->todpr = 0;
-		vcpu->arch.sie_block->cpnc = 0;
 	}
 }
 
@@ -3582,7 +3581,6 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
 
 	regs->etoken = 0;
 	regs->etoken_extension = 0;
-	regs->diag318 = 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
-- 
2.27.0



