Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD00B156ABC
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgBINol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:44:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43129 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727663AbgBINok (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:44:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B6E1121D51;
        Sun,  9 Feb 2020 08:44:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iat59n
        bkGOIXwF+bj/MjKT7gslihtM+tKukZTzWm+Lo=; b=BIv80R/2YVrDLmZgAaRnek
        M/fySpYvBcIzlG1BkrFg2TJ+VxIMJCiPd9wJroifx0iGQibHcqwadvNz3VONyWaL
        +aBvQ7OXAmJ5YsUxe2y96RsGXdjEnfAQn38ufruI8dfzRukHL+onxPtbrc/e4+3J
        OlvfCltTDVN8e/Cvwo95stzwyq1loUHOW/Mn5tXEtVYmI0QgtgrfIUoMU6KauJU3
        UsFpV+2IX7QgpXrQsHTebeGurGsDmWtkoDZkxJuoEgX+ZnZkJP/yVUgsGoqDkfLX
        AKs6yshCDbkdHeddONho2ZTmzcgM7fraK7Ds+K8N7mKWmtvVU3+k+Yq55jdbAx5Q
        ==
X-ME-Sender: <xms:xwxAXjOPl_NBExLIOyy5IAH5VQBsleNukoLcqzzIt385nDsTs47LMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepvddtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xwxAXnVcdENbdZynO6Zvjaxs9hCEuh5LQLOXjTykZDzmdpMK7nSy_w>
    <xmx:xwxAXrb6mgTkGlmNUtro-pNIKN2JX8tM--yO8TI6VSJCDrbYMIq4Hw>
    <xmx:xwxAXqtx4WFkOuiYNpRnJqmKdgV0MSI1-B1O91_QAN00lrBO-K_dTQ>
    <xmx:xwxAXjDV_RA1Fxr3uhnYYuE2APDW0jUfrfbe7l3ljw-VnOCIwPOc6Q>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 743E730606FB;
        Sun,  9 Feb 2020 08:44:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Play nice with read-only memslots when querying host" failed to apply to 4.9-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:36:56 +0100
Message-ID: <1581251816206188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

