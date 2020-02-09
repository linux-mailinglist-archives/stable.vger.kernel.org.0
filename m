Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568C7156AAF
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgBINml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:42:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42733 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBINmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:42:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5ABEB21B01;
        Sun,  9 Feb 2020 08:42:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:42:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4o4AEq
        K2n5W1o6bB8Wr8YYQziS7pS9PxvAS50odjQ5Y=; b=tAXjNLZS8YUvhN6aB9mx8T
        3EJcym/MoGcZ+IH6CTZAcZ/jrdaRm+vYNEGeeOCDUAJc/pN2ZgZ1gq874u+UpixR
        kcdp7P/LpgrUhr4gbNyGgGBl+g+SL6+I21WTMoaVigBRm5V1N5Qg/6yS5oaCMQuL
        h2iFtb/+5tZEaFlAbTQprPglD08DpdVW6xEtvU9ir8gnufvHaTAqmiNc0H03nDYE
        fV9/Zw/rkuR5vq06uqHNTIOIhDkWEFkP3ULFOuXmlinxinmmXDjtdzlRflAA7/KD
        umn+Z32qeKNfPtzcrF3bIOs1TWT4yHEzWURVO7U5L0QbK0Be5yEz3VilGKFjjSGg
        ==
X-ME-Sender: <xms:UAxAXvtyRI5V5Wkd8Seqg96ZQDFLhUe5Lr3iN7G5AblsQykevhI-gA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepjeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UAxAXowtmXsnMV8e89zoHVdJQQ692jwRLka-jL2BDaSKNbV_dVGe-g>
    <xmx:UAxAXsyzmicQeH6TU9mof0CDhftUDpLUMZLY0xNEIX1GRyza-XanaQ>
    <xmx:UAxAXsC_35uZzoDEJqZknOxMbwhP5fCJUpPGUmzyHZ5YrKiH4Rz5HA>
    <xmx:UAxAXok2XHxojTyfnFjXVqDRRQTnXmFcn485i9kEOEqLauX6Dmor3g>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D1BC3280060;
        Sun,  9 Feb 2020 08:42:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: vmread should not set rflags to specify success in" failed to apply to 5.4-stable tree
To:     linmiaohe@huawei.com, liran.alon@oracle.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:36:24 +0100
Message-ID: <158125178414544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

