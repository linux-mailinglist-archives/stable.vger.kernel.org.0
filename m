Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15DD157B27
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbgBJN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:27:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgBJMg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:28 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99BFA24671;
        Mon, 10 Feb 2020 12:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338187;
        bh=Iris8Bkm5Qug/iixkPX0VeElL1IF+1X3zXHKnZ7aAIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRPXKi2yOIwGfd80kz5cKPQYZEf00tDumUrH7TaAlUwLU2k+EId+bn6LgEJYVYTeU
         BHFZJuauV68jUbazHLrvdMN5qKAQXQhYyTQgkhqNi8lNac2jwBcGs5ITHJVAlRq0sO
         Tq7J9fzbGpiOAcu1AFjYAlR0yiis/bbaQAx8ZSqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 187/195] KVM: Play nice with read-only memslots when querying host page size
Date:   Mon, 10 Feb 2020 04:34:05 -0800
Message-Id: <20200210122323.499280254@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
index df7ece0bfcbd3..beec19fcf8cdb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1301,7 +1301,7 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 
 	size = PAGE_SIZE;
 
-	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
+	addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return PAGE_SIZE;
 
-- 
2.20.1



