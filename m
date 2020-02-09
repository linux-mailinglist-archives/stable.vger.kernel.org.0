Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C524156AB8
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgBINoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:44:03 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37399 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727752AbgBINoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:44:03 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A9CEA21B01;
        Sun,  9 Feb 2020 08:44:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:44:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gtd09s
        EIbiiZzsxsSKbK72s/NwTjr6gb8SFjDvGxJi8=; b=eacR4GQhw016J0+yE45U0R
        5ZsqBU5z6cmlCRJyYY3mg+SU/0ZG7/QvVeZSjWZwXVOmL9rebG6W22Wkn5VaXlU7
        wCz41/9gQMOeT4txP0dR+llM/snwcZUk0q3GyUCa1IqrAtTO/SySu0GljvV8KJiz
        YZIyeU11WRcaV9rK5tE+mAJFNWTVdZolXAtzv/3jpAdo/xczw6gCV9P3qsQw1Hth
        eGitklLxtM1mpTvISvlOh16LVFUQg+YfP8c8NBTFeO4BhUofNh56fNdj5vFJZURF
        pPHTP/aZ0mxjv+/WZd2ebq4LTOvojzptpgSxFK00Uj0wIgraWlPYzw+krYdYY7Kw
        ==
X-ME-Sender: <xms:ogxAXiDDCbNHv7IjTEU10v9NA-CmvTESaksFVxKYpDN0RnUT9IZLLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudeine
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ogxAXja7I70ici2oFSwNq0VFXe0u4nFcTcT4-0hIGHbXHWJ8foSTXw>
    <xmx:ogxAXt7MQ69zjzxzwwMbXI3aaK8OmKpnCMBOB5FxirQUU7B-AZFv4g>
    <xmx:ogxAXsbYNnC5nqlsfeLFNXSvjvgB8XV_dvY3A8vWnLgAsbmfo9at0Q>
    <xmx:ogxAXh2nwR3Pzy4hon915cy-fhoIi29asIDkH7koMnba0zf1ZYDi7Q>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79CE63280063;
        Sun,  9 Feb 2020 08:44:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Play nice with read-only memslots when querying host" failed to apply to 5.5-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:36:52 +0100
Message-ID: <158125181221109@kroah.com>
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

From 42cde48b2d39772dba47e680781a32a6c4b7dc33 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 8 Jan 2020 12:24:38 -0800
Subject: [PATCH] KVM: Play nice with read-only memslots when querying host
 page size

Avoid the "writable" check in __gfn_to_hva_many(), which will always fail
on read-only memslots due to gfn_to_hva() assuming writes.  Functionally,
this allows x86 to create large mappings for read-only memslots that
are backed by HugeTLB mappings.

Note, the changelog for commit 05da45583de9 ("KVM: MMU: large page
support") states "If the largepage contains write-protected pages, a
large pte is not used.", but "write-protected" refers to pages that are
temporarily read-only, e.g. read-only memslots didn't even exist at the
time.

Fixes: 4d8b81abc47b ("KVM: introduce readonly memslot")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
[Redone using kvm_vcpu_gfn_to_memslot_prot. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f6f8ffc2e865..eb3709d55139 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1409,7 +1409,7 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 
 	size = PAGE_SIZE;
 
-	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
+	addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return PAGE_SIZE;
 

