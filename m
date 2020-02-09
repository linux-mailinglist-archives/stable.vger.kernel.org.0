Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F27A2156AB0
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgBINmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:42:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54021 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBINmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:42:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7FA0421D51;
        Sun,  9 Feb 2020 08:42:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:42:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xC82UY
        D3hJR9TNLc58Llossz3rHpNW8+tJhR823y3rQ=; b=WSSDW4hsxHwX7Q/ZdIa4xV
        uqfKi8BphJmmJwkX4YSEcldNYUcRDYWVlFOcWRy9wyHLY8OoZJRzcdumcQpLJqh3
        xSFim/inb/LSBkfv/RbOEP+1c+kYaMy1HLrMu3c5mNYp3CLZrwGif59pi2DZUbTy
        8ctHoUBNKbwFBJiN5aFciPuDRIo6MG68MVPcru5cSpZ+Dr4AodnKsGLXroS55sQP
        m0HFdeUyK7TcNBl4bqreOj430xK7m6I19HmkR6bPTAwFxQjEFcFiGabM0ZhvYPR5
        /ZTk9JCixVdabZmxZCb6H3MrC/ZIQut4EkU/tKr+1MPrH81joP1EV+nLoS8d4xYw
        ==
X-ME-Sender: <xms:WQxAXqu842_7He1LA8zoNaHGUZk_4zag4o11t_oeG3rRJXlscbgzgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepkeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:WQxAXjvsQRhfe5WMZE6f6KmEI2GkNfrD5wgq5iSsiUntAp8tvTaQXA>
    <xmx:WQxAXgyEXUBt-AAs0-k8eF95zYmFV6yoLOqOm9FHQLm4RGClAfQd4g>
    <xmx:WQxAXpgKg5632QsrORiHjQqt8xYDwcNFFXG8wk8J3OCWdsUMX3bwvw>
    <xmx:WQxAXpe_7R-sKLnvQ74T8k2kSR9DjBBkNVLFN-hUrT__XozHtAESUg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3ABD93060717;
        Sun,  9 Feb 2020 08:42:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: vmread should not set rflags to specify success in" failed to apply to 4.19-stable tree
To:     linmiaohe@huawei.com, liran.alon@oracle.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:36:25 +0100
Message-ID: <15812517851339@kroah.com>
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

From a4d956b9390418623ae5d07933e2679c68b6f83c Mon Sep 17 00:00:00 2001
From: Miaohe Lin <linmiaohe@huawei.com>
Date: Sat, 28 Dec 2019 14:25:24 +0800
Subject: [PATCH] KVM: nVMX: vmread should not set rflags to specify success in
 case of #PF

In case writing to vmread destination operand result in a #PF, vmread
should not call nested_vmx_succeed() to set rflags to specify success.
Similar to as done in VMPTRST (See handle_vmptrst()).

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e038a331583c..ef2d53854d15 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4799,8 +4799,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 					instr_info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e))
+		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e)) {
 			kvm_inject_page_fault(vcpu, &e);
+			return 1;
+		}
 	}
 
 	return nested_vmx_succeed(vcpu);

