Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6801A72A2
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfICSkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:40:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55963 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfICSkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:40:25 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C025222106;
        Tue,  3 Sep 2019 14:40:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hYgrf7
        xvGKmBpZvzZCHyKSiFP4Y4dEPrZNQBL2AD4fg=; b=NydwphBjOqdecMpPO2TAI4
        AkcaKdOwJl3DIp52q4PLuG+S57Mzw8AzNo8Vt0MB4ReoJGNXnXE8VI7Qyw6fBRSH
        wi/ggkRB/3x/G0ifyPiuJZxqbzictnY3+c0/haLT3ohr1nzHipMGFR4FXXkFJV5+
        nfo47XKUkb/72g3k51wPso4TqFAhW3chYupAUPkzFI2FeqDpsap/ih0jGqxPmEV+
        nMs8c4ZyxIG5ugI3AlpeomLB/a8ef1q/YSyEUi7AxJMlQSYYYcZe243VX0TZlj3F
        lP9+c2J1Qi7UUtKG03PHgLnf6x2Ic8cgoIi9KgVBVrIamtIfVoBI4pB8ySSqKRog
        ==
X-ME-Sender: <xms:mLNuXdurGjd9I6Sd4ID1es2Ciol8cdZXtfdHgGoHnBkXSxIVW5awxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:mLNuXcSFTPQhdNacRcJTTjuF92bKullBEQwWTq2UwOIgz2q3sgcQJw>
    <xmx:mLNuXS0i5TLCv5teJgst9aVKE_67D05TnhBLMZvcqIA50rd2OVoVeA>
    <xmx:mLNuXcwRYQIUz7RFbpfaeHfjGLvrGxgFysUvyWs-sMohpGhw9jQGJw>
    <xmx:mLNuXeIjDo7HAuZru7hRCz5-HCCGJTvQCoyLGnR5H3NRoAgAfUdtXw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4931680060;
        Tue,  3 Sep 2019 14:40:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S: Fix incorrect guest-to-user-translation" failed to apply to 4.14-stable tree
To:     aik@ozlabs.ru, paulus@ozlabs.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:40:15 +0200
Message-ID: <156753601548146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

