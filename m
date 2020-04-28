Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF7F1BC987
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgD1Smh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731126AbgD1Smh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:42:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4608F20575;
        Tue, 28 Apr 2020 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099356;
        bh=ghupO339lD3K+xHxFoqtrtWMaXlH4At1OwY6QqOhB0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDLJCdGupxP3gRCNOSgZikjHfcMXj6NBAukmJMvOJsVnC/N/ibu0/EZ4kJlwVIaxB
         68WFZ02e+eYJ22gXOPcW6uvhOT1Av3tYpJ0ZNmjCwj2fe5nfTyDrhcq93aV/8ol8vz
         t+1Wk2Ke0k6BT5J09eAFwEKgTGhmKxjT6PRyZmZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 117/168] KVM: s390: Return last valid slot if approx index is out-of-bounds
Date:   Tue, 28 Apr 2020 20:24:51 +0200
Message-Id: <20200428182247.288255691@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 97daa028f3f621adff2c4f7b15fe0874e5b5bd6c upstream.

Return the index of the last valid slot from gfn_to_memslot_approx() if
its binary search loop yielded an out-of-bounds index.  The index can
be out-of-bounds if the specified gfn is less than the base of the
lowest memslot (which is also the last valid memslot).

Note, the sole caller, kvm_s390_get_cmma(), ensures used_slots is
non-zero.

Fixes: afdad61615cc3 ("KVM: s390: Fix storage attributes migration with memory slots")
Cc: stable@vger.kernel.org # 4.19.x: 0774a964ef56: KVM: Fix out of range accesses to memslots
Cc: stable@vger.kernel.org # 4.19.x
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200408064059.8957-3-sean.j.christopherson@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/kvm-s390.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1932,6 +1932,9 @@ static int gfn_to_memslot_approx(struct
 			start = slot + 1;
 	}
 
+	if (start >= slots->used_slots)
+		return slots->used_slots - 1;
+
 	if (gfn >= memslots[start].base_gfn &&
 	    gfn < memslots[start].base_gfn + memslots[start].npages) {
 		atomic_set(&slots->lru_slot, start);


