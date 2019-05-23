Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0F5287E8
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391016AbfEWTY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391019AbfEWTY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:24:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2586D217D7;
        Thu, 23 May 2019 19:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639497;
        bh=FxkdIhG38ihpYGCunrzIqZkGUeuxlN4iMAdCgEIL3v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOnaQInDBmYTd+MKS+uKYG2kbyn5Kop+ryqR1NYcl0LHmSZ0E5Bm16TRNdpFDcPtf
         WCvGeH8F/cex/dgd007vveP9hScNW1GHIKgW1vUg7Embz65FDSzp5xqmsAhPNGBgQg
         7IXXpk/a1rgT5G8FNCRw4JQpJs2NrckSEm2Tae4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 127/139] KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned size
Date:   Thu, 23 May 2019 21:06:55 +0200
Message-Id: <20190523181735.824545490@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 76d58e0f07ec203bbdfcaabd9a9fc10a5a3ed5ea ]

If a memory slot's size is not a multiple of 64 pages (256K), then
the KVM_CLEAR_DIRTY_LOG API is unusable: clearing the final 64 pages
either requires the requested page range to go beyond memslot->npages,
or requires log->num_pages to be unaligned, and kvm_clear_dirty_log_protect
requires log->num_pages to be both in range and aligned.

To allow this case, allow log->num_pages not to be a multiple of 64 if
it ends exactly on the last page of the slot.

Reported-by: Peter Xu <peterx@redhat.com>
Fixes: 98938aa8edd6 ("KVM: validate userspace input in kvm_clear_dirty_log_protect()", 2019-01-02)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virtual/kvm/api.txt            | 5 +++--
 tools/testing/selftests/kvm/dirty_log_test.c | 9 ++++++---
 virt/kvm/kvm_main.c                          | 7 ++++---
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index ba8927c0d45c4..a1b8e6d92298c 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3790,8 +3790,9 @@ The ioctl clears the dirty status of pages in a memory slot, according to
 the bitmap that is passed in struct kvm_clear_dirty_log's dirty_bitmap
 field.  Bit 0 of the bitmap corresponds to page "first_page" in the
 memory slot, and num_pages is the size in bits of the input bitmap.
-Both first_page and num_pages must be a multiple of 64.  For each bit
-that is set in the input bitmap, the corresponding page is marked "clean"
+first_page must be a multiple of 64; num_pages must also be a multiple of
+64 unless first_page + num_pages is the size of the memory slot.  For each
+bit that is set in the input bitmap, the corresponding page is marked "clean"
 in KVM's dirty bitmap, and dirty tracking is re-enabled for that page
 (for example via write-protection, or by clearing the dirty bit in
 a page table entry).
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 4715cfba20dce..93f99c6b7d79e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -288,8 +288,11 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 #endif
 	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
 	guest_page_size = (1ul << guest_page_shift);
-	/* 1G of guest page sized pages */
-	guest_num_pages = (1ul << (30 - guest_page_shift));
+	/*
+	 * A little more than 1G of guest page sized pages.  Cover the
+	 * case where the size is not aligned to 64 pages.
+	 */
+	guest_num_pages = (1ul << (30 - guest_page_shift)) + 3;
 	host_page_size = getpagesize();
 	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
 			 !!((guest_num_pages * guest_page_size) % host_page_size);
@@ -359,7 +362,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
 #ifdef USE_CLEAR_DIRTY_LOG
 		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
-				       DIV_ROUND_UP(host_num_pages, 64) * 64);
+				       host_num_pages);
 #endif
 		vm_dirty_log_verify(bmap);
 		iteration++;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b5238bcba72cb..4cc0d8a46891f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1241,7 +1241,7 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
-	if ((log->first_page & 63) || (log->num_pages & 63))
+	if (log->first_page & 63)
 		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
@@ -1254,8 +1254,9 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	n = ALIGN(log->num_pages, BITS_PER_LONG) / 8;
 
 	if (log->first_page > memslot->npages ||
-	    log->num_pages > memslot->npages - log->first_page)
-			return -EINVAL;
+	    log->num_pages > memslot->npages - log->first_page ||
+	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
+	    return -EINVAL;
 
 	*flush = false;
 	dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
-- 
2.20.1



