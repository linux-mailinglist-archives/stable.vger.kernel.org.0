Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3962245264F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbhKPCEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239937AbhKOSFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD644632EF;
        Mon, 15 Nov 2021 17:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998014;
        bh=c0Vl1iW08QAKhWfF0DMPi0A5aI4dq+Ixb5x8kC6zQ0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3nuBaqYuV+0mCxi3D7R4YxG2TZqfrgOD5fxKOwggWIhjURDaMSUQuZYVUb4kD1zn
         Q9zbcn9nRTpB+fcXHV+GiBh+RdFzy54IZMWwgE9uNaxGcZtA+KZ6pDxIrEAVF0J0WW
         oOe1pkD49A1WDJHphMHd19zXUkWo90vOCNbTwHQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/575] KVM: s390: pv: avoid double free of sida page
Date:   Mon, 15 Nov 2021 18:01:20 +0100
Message-Id: <20211115165356.083550828@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit d4074324b07a94a1fca476d452dfbb3a4e7bf656 ]

If kvm_s390_pv_destroy_cpu is called more than once, we risk calling
free_page on a random page, since the sidad field is aliased with the
gbea, which is not guaranteed to be zero.

This can happen, for example, if userspace calls the KVM_PV_DISABLE
IOCTL, and it fails, and then userspace calls the same IOCTL again.
This scenario is only possible if KVM has some serious bug or if the
hardware is broken.

The solution is to simply return successfully immediately if the vCPU
was already non secure.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 19e1227768863a1469797c13ef8fea1af7beac2c ("KVM: S390: protvirt: Introduce instruction data area bounce buffer")
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Message-Id: <20210920132502.36111-3-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pv.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index f5847f9dec7c9..74265304dd9cd 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -16,18 +16,17 @@
 
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
-	int cc = 0;
+	int cc;
 
-	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
-		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
-				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
+	if (!kvm_s390_pv_cpu_get_handle(vcpu))
+		return 0;
+
+	cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu), UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
+
+	KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
+		     vcpu->vcpu_id, *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x", *rc, *rrc);
 
-		KVM_UV_EVENT(vcpu->kvm, 3,
-			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
-			     vcpu->vcpu_id, *rc, *rrc);
-		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
-			  *rc, *rrc);
-	}
 	/* Intended memory leak for something that should never happen. */
 	if (!cc)
 		free_pages(vcpu->arch.pv.stor_base,
-- 
2.33.0



