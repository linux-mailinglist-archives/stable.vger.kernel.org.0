Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE898A90FD
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbfIDSMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390574AbfIDSMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:12:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 049AB208E4;
        Wed,  4 Sep 2019 18:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620771;
        bh=WG6u3c/wJsZm7IRUx+2/MEegebeZguAiiPGP3fzt7h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjBgFaHzT14VfFMHxRgPG5arkdIhV8pgyE0b0LAi/8mv3rk5CEKRI47Ok1YopzY3r
         VhAvA4o8YJbHZtxSouy1FAcnTGZKSBool0ePaPR/WSRC15v7d6et5OvP3ELjIEIy1e
         3KIo3DtJ1nkmxWgFsT+BsArHpl00drmS3n2iGx64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 5.2 088/143] KVM: PPC: Book3S: Fix incorrect guest-to-user-translation error handling
Date:   Wed,  4 Sep 2019 19:53:51 +0200
Message-Id: <20190904175317.528542156@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit ddfd151f3def9258397fcde7a372205a2d661903 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_64_vio.c    |    6 ++++--
 arch/powerpc/kvm/book3s_64_vio_hv.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -696,8 +696,10 @@ long kvmppc_h_put_tce_indirect(struct kv
 		}
 		tce = be64_to_cpu(tce);
 
-		if (kvmppc_tce_to_ua(vcpu->kvm, tce, &ua))
-			return H_PARAMETER;
+		if (kvmppc_tce_to_ua(vcpu->kvm, tce, &ua)) {
+			ret = H_PARAMETER;
+			goto unlock_exit;
+		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
 			ret = kvmppc_tce_iommu_map(vcpu->kvm, stt,
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -556,8 +556,10 @@ long kvmppc_rm_h_put_tce_indirect(struct
 		unsigned long tce = be64_to_cpu(((u64 *)tces)[i]);
 
 		ua = 0;
-		if (kvmppc_rm_tce_to_ua(vcpu->kvm, tce, &ua, NULL))
-			return H_PARAMETER;
+		if (kvmppc_rm_tce_to_ua(vcpu->kvm, tce, &ua, NULL)) {
+			ret = H_PARAMETER;
+			goto unlock_exit;
+		}
 
 		list_for_each_entry_lockless(stit, &stt->iommu_tables, next) {
 			ret = kvmppc_rm_tce_iommu_map(vcpu->kvm, stt,


