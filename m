Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD4F157682
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBJMxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729857AbgBJMmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:13 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B29F2085B;
        Mon, 10 Feb 2020 12:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338533;
        bh=lsrYIvTCKm6UNqj2q/1UKHaCwzyVnZJCvOu7RzNSAD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zw3pk42tJ/yONhmzA1pbog4Cnm84UFoPB9YqFqTQn8C2/26L2F33vvIvMavuvAj3a
         YnKemuD4zcieWnzmBnELzMdVVwKiezHPPtKx4er8W372/gE1lm14V2kijTbXc/Ff6N
         bqTcq0senMyr47sGQvCadOULZV45zoETvZcdc1q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 359/367] KVM: Play nice with read-only memslots when querying host page size
Date:   Mon, 10 Feb 2020 04:34:32 -0800
Message-Id: <20200210122455.534464170@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 42cde48b2d39772dba47e680781a32a6c4b7dc33 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb1a4bbe3b30f..2b3f36df3d855 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1413,7 +1413,7 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 
 	size = PAGE_SIZE;
 
-	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
+	addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return PAGE_SIZE;
 
-- 
2.20.1



