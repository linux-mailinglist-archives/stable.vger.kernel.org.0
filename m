Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB0DC996A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfJCIBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:01:20 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41599 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727831AbfJCIBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 04:01:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1B68421E97;
        Thu,  3 Oct 2019 04:01:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 04:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=l6ea8H
        VjsUCAuhoIkjQO1IMVmcctaaaqXnUbh178Tug=; b=Y3kE3uSUOiQo4QU3KzcVPD
        QX9NSvAs8ugVj0uWKwA4yFZUwQ6ugkb3G/URiSD4WePNC1pjpErwZyRlKhWgoRp2
        ZXEZueAfG7WEY8gjcFRLFqUb/8vAI1wFkGfNfeUvL82lTnWbgznEL98UYlbf1OJh
        C0YEqxXu5NnSK9sHgqrW9XQw9As3C51nOofNLV4focXVrDkzewTUL+d9L8ZgyFTZ
        Au0xMb9AIqpADzLHvcgq6ZejzFd6Nn0/hbx2/NmaPS8Ecn4C+I5Na8WFwwbwDIUC
        iV+PtZT4SVRu0qJHBN75WvIEV58rXy4/0WMaAZJJO5ab5veZp/cFnF181EVrHHFA
        ==
X-ME-Sender: <xms:zqqVXWrar-mOXoQU6Hf2uszzW496PPx1qgEYFep0_sanLMcEqhU2CQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:zqqVXV7Ac3nA918rWK9SryTd2WNBbrQXQ0Hcr0_nsKzwahyaarBtYQ>
    <xmx:zqqVXc8AjzbQ1STbp-nQhAOyM94HHSqdlCTAFjLQCIOMxzGXSzMubw>
    <xmx:zqqVXfWq7kZOZmVJvFDahJr9WkfElyEBnCp65YkAEF4NpxlDRazT6g>
    <xmx:z6qVXcxQwIoaDNd-nd8kl2hlenVlIbQA0ur4Vd3nOqS5qCf5kBLojg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A16780061;
        Thu,  3 Oct 2019 04:01:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86: KVM: svm: Fix a check in nested_svm_vmrun()" failed to apply to 5.3-stable tree
To:     dan.carpenter@oracle.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 10:01:16 +0200
Message-ID: <1570089676108127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a061985b81a20248da60589d01375ebe9bec4dfc Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 27 Aug 2019 12:38:52 +0300
Subject: [PATCH] x86: KVM: svm: Fix a check in nested_svm_vmrun()

We refactored this code a bit and accidentally deleted the "-" character
from "-EINVAL".  The kvm_vcpu_map() function never returns positive
EINVAL.

Fixes: c8e16b78c614 ("x86: KVM: svm: eliminate hardcoded RIP advancement from vmrun_interception()")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fdeaf8f44949..2854aafc489e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3598,7 +3598,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm)
 	vmcb_gpa = svm->vmcb->save.rax;
 
 	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
-	if (ret == EINVAL) {
+	if (ret == -EINVAL) {
 		kvm_inject_gp(&svm->vcpu, 0);
 		return 1;
 	} else if (ret) {

