Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22154513DB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347853AbhKOT5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:57:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344092AbhKOTXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0063363472;
        Mon, 15 Nov 2021 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002293;
        bh=UxQqafP2iEoFfUVpJbLDbkyteGP6ArFOWDBsgr6dihY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRrmDcBeFFH1qriKMjSrHiwYHC6voX8bjthhAH51VX+hFz13OKCrUa6tQJxrwg0Ri
         z4Km5VPnsHL4exqdNDESjeQXxJiNcnt0DiXI5KJbssnCPhHc93dAbTE+B7GujcY/6J
         uLxZxt9FU66+eJYEegzPOg95vAAscx90Ppxr7HN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 511/917] KVM: s390: pv: avoid double free of sida page
Date:   Mon, 15 Nov 2021 18:00:06 +0100
Message-Id: <20211115165446.091735172@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index c8841f476e913..0a854115100b4 100644
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



