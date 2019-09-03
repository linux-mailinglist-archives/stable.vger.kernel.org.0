Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A04EA72A0
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfICSkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:40:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51315 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfICSkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:40:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BC3D622106;
        Tue,  3 Sep 2019 14:40:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:40:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lhq3tc
        kpjZWGPSRGXC7qqTKjX6h/74Q9js6gtGsZGi8=; b=q/pGd/tI5ET7TI+CT6PPJY
        vpqU2WlRDb1z4WKB+Twg/BWpM0Z0x7ldClf7nua1xyr3Qi8xSaz9fDnejAHCS4ef
        7i8qsCB9Ncjzuf+zYRR8v+KZSgOsBz3vvGTWOtTo7oUYZTkfB/hnOAW2lgj7lNa9
        YaZArCz2aaqP+x7sys7flWy4KrSuML9FU5CPd+bTAGuYfJu/DQTSjrF3JWh3hpPJ
        Z2zl0Zyfn7RdTkWfk1eGBPp6no0OCFsQDQVlLzRM8d34yolvWKB/k7CmDCFcwToi
        GJk4xz+bsa0ULq+B/sTopsKEuYl868HF1qD0WxVjE4wkFKpq/8StoUDz6n7KXmEA
        ==
X-ME-Sender: <xms:j7NuXaEZWQuMeyhaHliQfzgQOyWfy_uurCKXDUHJtBL1VTV0_yv6Pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:j7NuXU6HMH0EeEklK2ULSdlFegpHAEhCjxPxo5cGgAMiHO0YqMukTA>
    <xmx:j7NuXfmSriR2Bk0Cg039_wzqvZ8Ef9w6H8EQNj9I1ZeYDqOj8NtOOw>
    <xmx:j7NuXSyLTeGzgPtpPRBufrNyq_0II-o5OFSzv3yMkf9hyzl9gvMufQ>
    <xmx:kbNuXXbMt7B9D2NtWhPBwxqHFpKqQYdDiRwpj4JF53nw9yKpzEA8KQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00D308005A;
        Tue,  3 Sep 2019 14:40:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S: Fix incorrect guest-to-user-translation" failed to apply to 4.19-stable tree
To:     aik@ozlabs.ru, paulus@ozlabs.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:40:13 +0200
Message-ID: <156753601315657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ddfd151f3def9258397fcde7a372205a2d661903 Mon Sep 17 00:00:00 2001
From: Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Mon, 26 Aug 2019 14:55:20 +1000
Subject: [PATCH] KVM: PPC: Book3S: Fix incorrect guest-to-user-translation
 error handling

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

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index e99a14798ab0..c4b606fe73eb 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -660,8 +660,10 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
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
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index f50bbeedfc66..b4f20f13b860 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -556,8 +556,10 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
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

