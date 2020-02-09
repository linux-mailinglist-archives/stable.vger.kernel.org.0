Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D71B156AAA
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBINlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:41:55 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34129 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBINly (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:41:54 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C6AC21E44;
        Sun,  9 Feb 2020 08:41:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kL6qYj
        Jz86cfSMp4tNoYhOlz4rgI+L27bZVxJbQn4mM=; b=OzR7QVAQXiPpWc4LGhtGs0
        Utl7ukmVC7EkMfh8HrEiEWsNu/cwCIEBPhXSMY2r4pDHm4SVv3FdBvISRt3UVt4f
        RXKrfzplPszwKi/u0SxCdH6PtooSyh4q4+VBdZld6Nj8J6jsL05Z2+KT1WZz/yNS
        pSdOKYJXJmy4WWCwgAreMeX3OxUr79xBbS80DC8DYid/+Zduq2j5yXMH8xqJYLEp
        p7+c7BHUwwIK3+0T5GSG1X92cObkvDKEaKVDQe1QXG5yZvANlsMrNiRPQ2Qc/2jO
        YjT8FKn2VBYvtNhFwMPG/KeLqnLIKuYQqcDjf5a/12L44vM7+6pTBak/zI1oKEWA
        ==
X-ME-Sender: <xms:IgxAXniU_m_EZxW4Xx4MNgH_JpT_sNhEf04Ohu-ulCpYhEhcmsZqEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IgxAXvw891My-mMmG_SL_rhdpDA7U9L8OZM3rJGqsVrLgFRC3ys73Q>
    <xmx:IgxAXp0wzUD85SqNnRK1iXFMnx6ErzdkV_PKCfymUlOdgMHLsw5JHA>
    <xmx:IgxAXqS_rNehvaiBBK3sTifAurQ6g_F7c1fcgFMRP9objy5aFDvAGw>
    <xmx:IgxAXsB6By8SA7dzYnpRk92Iz-012Ab2i-EgjbvknkWQhanmkez1Yw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2E9A30600DC;
        Sun,  9 Feb 2020 08:41:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: VMX: Add non-canonical check on writes to RTIT address" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:31:58 +0100
Message-ID: <15812515183712@kroah.com>
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

From fe6ed369fca98e99df55c932b85782a5687526b5 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 10 Dec 2019 15:24:32 -0800
Subject: [PATCH] KVM: VMX: Add non-canonical check on writes to RTIT address
 MSRs

Reject writes to RTIT address MSRs if the data being written is a
non-canonical address as the MSRs are subject to canonical checks, e.g.
KVM will trigger an unchecked #GP when loading the values to hardware
during pt_guest_enter().

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2ced79aee3e..aea4fa957fd2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2144,6 +2144,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_num_address_ranges)))
 			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
 		if (index % 2)
 			vmx->pt_desc.guest.addr_b[index / 2] = data;
 		else

