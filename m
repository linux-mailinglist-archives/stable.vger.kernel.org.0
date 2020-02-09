Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2D1156AAE
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgBINmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:42:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48337 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBINmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:42:32 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 487F121E1C;
        Sun,  9 Feb 2020 08:42:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0dMIUd
        VOlTSij+Bi8j/BnMYVbA05DLEB7H7hnQBtJOI=; b=dibk46lnwIpWcC5e3RFaAf
        9QT6UVbq8x2lWb++vKM8IVa6zgENJMoY+R4JdqcVinmXfKhDajp66LKKsug54AhR
        mKKJ7SdDeNA2RyuHAxrlRqcKYEhxGozJP/FawGAa+s4riONkmqwjyPb1z+HQsOLa
        cCR57H3Z4zgPFvJxb7ZJvjQdcn+3xkHo+M6WmUhUKPUk6oNYuJ479/ax6sAoE6jl
        2/D/ChDJp2ZKNd2hcoHZsBTwXctD5NLexV0bQjqxMRyi4BPy2+4bckk5OWqpVAf7
        QAawWPRH54HiBpsvxIy+tC6JAc5yFHWhLbyZ7u8YgMEG/hIlmF/Zx/3Vnx7kHE5Q
        ==
X-ME-Sender: <xms:RwxAXqld9E682sCfVQhUGcF3CgI6gHj_xUUJqhjH3KTmWgX42sOoOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepieenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RwxAXtPVPC6vIVoBLNcAEPrzsgMLw3wjV_gQhj7DVV7PF88jTvtTmw>
    <xmx:RwxAXiCjN52Bwo3G1Rxx0TMVNEDZXAeFFqA0S2NVaEApyoSOUNjoIg>
    <xmx:RwxAXmV8KoL3T4FZE6b6W74_AhdqxNZGAC3smttSkkeSap9X9do5yg>
    <xmx:RwxAXnX5o5KYk3ayY8Cpdono6sx5LAGzG4Rwbh6qIsc74mrLgLcxqA>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC8FE3060272;
        Sun,  9 Feb 2020 08:42:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: vmread should not set rflags to specify success in" failed to apply to 5.5-stable tree
To:     linmiaohe@huawei.com, liran.alon@oracle.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:36:23 +0100
Message-ID: <1581251783689@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
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

