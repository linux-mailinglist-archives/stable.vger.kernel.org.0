Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2C2156AB1
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgBINm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:42:59 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38859 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBINm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:42:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9DE9621DC1;
        Sun,  9 Feb 2020 08:42:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:42:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lIz8Od
        wNoV+4Ia8bIZU8D8Y+2rw4/NXkLQC/50G7xIk=; b=uexdlxsMiV53sZjUCAhVH7
        TfQCl1pnPOq7Y1dKJRhOEvk63j2+Md5vvXOTwJFBrzVB33SPsriHbq9jau4IRIsV
        MjBjfg4txbuqny5M33hcjFYxHmW1z8lI6MNGMoHXTN+aRJx81G0Q9fx+N7+NeRW0
        zYsQQlwbpQ6+kuw2S19JA/JfBD47sDA/rfELoBXSB7kcFzlDvLCkOFcvDmB7MZcT
        3tyJVfUtBsLkycwnbnDT6fQBnQRFA690x2Scck9ff6uhbzJQUv7dpILUJ6h9zYY4
        MxMv2vIHlBGk1cBeKRiH11EBjpY20gRyqIjgUJmPMSmthAOyqBQNiWOMKUOkWp+Q
        ==
X-ME-Sender: <xms:YgxAXl42_Ln16KhMvVCpXPWaFNlTvuBKW7zkIRLyrv0kRDKTD6Ve1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepleenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:YgxAXrsJ98Lsqdm_DStyfMdyY2eh6LqJoZntA5PXd5smABamPZYtdA>
    <xmx:YgxAXjbhJRpAMe076_yQqXiSRzw9imQGeJ-OpORgoUuOsLmbaey8XA>
    <xmx:YgxAXnudsmbMxi9curHTV995qlyUxP_mFDq0UHi4jCEWmbD4TG9eKQ>
    <xmx:YgxAXr095fQQiYwypBxt_UH2tivXttplZ8IS78Ts5jKGj4SzJrMDnQ>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C57F328005D;
        Sun,  9 Feb 2020 08:42:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: vmread should not set rflags to specify success in" failed to apply to 4.14-stable tree
To:     linmiaohe@huawei.com, liran.alon@oracle.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:36:26 +0100
Message-ID: <1581251786207242@kroah.com>
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

