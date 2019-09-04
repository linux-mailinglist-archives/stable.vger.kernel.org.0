Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C872A8FA5
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389172AbfIDSE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389173AbfIDSE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:04:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DEF7206B8;
        Wed,  4 Sep 2019 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620297;
        bh=zV6Oz1eNYxYgplHgnqQsHbvKLHOd2FEQv/eSx8SQHxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWa1TN/QQzTpu2hnUYAac6w6GnHuQF904jJ2GdDWfWH8FINbT0ZBBJNRhZc8ei6qG
         Rj4G/tHQVIoyzfky3pk7k0KBig4i4dCkGuUGGJW/sT1tQPhrJSEp8uI8TvXAQhx2z5
         PgcRXP5aTWVzDphbSNmedKuOQynQjAidLvhpLXcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 49/57] KVM: PPC: Book3S: Fix incorrect guest-to-user-translation error handling
Date:   Wed,  4 Sep 2019 19:54:17 +0200
Message-Id: <20190904175306.689260889@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ddfd151f3def9258397fcde7a372205a2d661903 ]

H_PUT_TCE_INDIRECT handlers receive a page with up to 512 TCEs from
a guest. Although we verify correctness of TCEs before we do anything
with the existing tables, there is a small window when a check in
kvmppc_tce_validate might pass and right after that the guest alters
the page of TCEs, causing an early exit from the handler and leaving
srcu_read_lock(&vcpu->kvm->srcu) (virtual mode) or lock_rmap(rmap)
(real mode) locked.

This fixes the bug by jumping to the common exit code with an appropriate
unlock.

Cc: stable@vger.kernel.org # v4.11+
Fixes: 121f80ba68f1 ("KVM: PPC: VFIO: Add in-kernel acceleration for VFIO")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c    | 6 ++++--
 arch/powerpc/kvm/book3s_64_vio_hv.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index e14cec6bc3398..2c6cce8e7cfd0 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -566,8 +566,10 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 
 		if (kvmppc_gpa_to_ua(vcpu->kvm,
 				tce & ~(TCE_PCI_READ | TCE_PCI_WRITE),
-				&ua, NULL))
-			return H_PARAMETER;
+				&ua, NULL)) {
+			ret = H_PARAMETER;
+			goto unlock_exit;
+		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
 			ret = kvmppc_tce_iommu_map(vcpu->kvm,
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 648cf6c013489..23d6d1592f117 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -475,8 +475,10 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		ua = 0;
 		if (kvmppc_gpa_to_ua(vcpu->kvm,
 				tce & ~(TCE_PCI_READ | TCE_PCI_WRITE),
-				&ua, NULL))
-			return H_PARAMETER;
+				&ua, NULL)) {
+			ret = H_PARAMETER;
+			goto unlock_exit;
+		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
 			ret = kvmppc_rm_tce_iommu_map(vcpu->kvm,
-- 
2.20.1



