Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAC8156ABD
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgBINot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:44:49 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54767 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINot (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:44:49 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E34B421D51;
        Sun,  9 Feb 2020 08:44:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:44:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zgxxV3
        h/jqIOx/dEyyT9QU/MFBvoOx7MSmN2kDJF6Yg=; b=3azKUXqQBUpiiCbyQCEj5w
        m/vGCBfx7kjs++q45ySSxfRawKm73fsdn5VII4WdO3STdbmUIY4V3OsXdQ7ZqPWT
        IaODubk7ZiEjF1vMctcauQTnr5dlWnusftcBQKKIOXB5UDBzGPNuikrTQBIoKY/X
        PL9pGByxK+IUnUEA7XRdPZZLzoLH7elCOyN+5k/enxvy428vPcgsCE2fMjcJC58y
        j4YUm8+YgvWfi9QNUNVhjrvSlR7KWTbfh2vwdjwQB+7wnyCkjp2WvqJbfjc+X3Zd
        7b3Sxp6kd6E877wD1MC9nzZNAz9BbHO20k+lmb71udPODM3gdS360PIVd+QFAvyQ
        ==
X-ME-Sender: <xms:0AxAXlaLbIfidldQRF0c33yiesMSP-jMmL6McpZqgYm6X98cTABKvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepvddune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0AxAXqlK3a90P34EBZ6lR56oYDpNHWHMGhx9RiTKxlW2GnN47Y-vMQ>
    <xmx:0AxAXuSEhkbczhwWenoLYDCljMIyMBZmzdTo-CdGFv2fsUUnkA5LgQ>
    <xmx:0AxAXngyPAC_AcawC3OJqAwORc7ikrtv6aZqJbYiaxlnHxbzARi-fg>
    <xmx:0AxAXo3n280xobU2tasEmOnbiMN00Irp4wXi_eTZn6KG8A__u8dAfg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3CD23280059;
        Sun,  9 Feb 2020 08:44:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Play nice with read-only memslots when querying host" failed to apply to 4.4-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:36:58 +0100
Message-ID: <15812518181610@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

