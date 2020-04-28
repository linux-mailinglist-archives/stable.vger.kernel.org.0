Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA8A1BCB22
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgD1Sy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbgD1SdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:33:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5340C21744;
        Tue, 28 Apr 2020 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098797;
        bh=8UiJs6jIRBpkRDsW57Nggg4rK9GDparxqDJXa96dMbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ul/ffulQrLKv+B+7xq0m16QLxN7WXa0hl1gJqYsDhQoNC2abkWjd6+qTmP65p83Hd
         spdlzVTD1oBkVCWpGseMczvEmmsO5d5+sqeVKgQKsbPGKUY05GcdVA2zQHAS/C2Fhm
         uBbIyW+F44TI65ADLzN3aioEiojIEbsZ5aFNM4OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.6 113/167] KVM: Check validity of resolved slot when searching memslots
Date:   Tue, 28 Apr 2020 20:24:49 +0200
Message-Id: <20200428182239.467833354@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit b6467ab142b708dd076f6186ca274f14af379c72 upstream.

Check that the resolved slot (somewhat confusingly named 'start') is a
valid/allocated slot before doing the final comparison to see if the
specified gfn resides in the associated slot.  The resolved slot can be
invalid if the binary search loop terminated because the search index
was incremented beyond the number of used slots.

This bug has existed since the binary search algorithm was introduced,
but went unnoticed because KVM statically allocated memory for the max
number of slots, i.e. the access would only be truly out-of-bounds if
all possible slots were allocated and the specified gfn was less than
the base of the lowest memslot.  Commit 36947254e5f98 ("KVM: Dynamically
size memslot array based on number of used slots") eliminated the "all
possible slots allocated" condition and made the bug embarrasingly easy
to hit.

Fixes: 9c1a5d38780e6 ("kvm: optimize GFN to memslot lookup with large slots amount")
Reported-by: syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200408064059.8957-2-sean.j.christopherson@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1039,7 +1039,7 @@ search_memslots(struct kvm_memslots *slo
 			start = slot + 1;
 	}
 
-	if (gfn >= memslots[start].base_gfn &&
+	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
 	    gfn < memslots[start].base_gfn + memslots[start].npages) {
 		atomic_set(&slots->lru_slot, start);
 		return &memslots[start];


