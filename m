Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25903217A5
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhBVMwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:52:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhBVMsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:48:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685F664EF5;
        Mon, 22 Feb 2021 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997759;
        bh=k+uH5JhWqxcQBAXaoYHY6wyG1XuJ0CDvbMOB7XR4PUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdXJjF3DiElhbHjrf0/dgvGDHJDmFe3JVLC95HLTE0oYCnPDxl5Ph3J4B6MNhS9CU
         RWcj2lIIwOZX+3CeKGbTXdy3oLBKbKzrB0DTG4IT9ceVT5tcBjJartZpUMv/Jne+wW
         n9ZRG2KTjWGQmhot0FIZ/Xm9FU5Hdok0HzcUYXvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 49/49] kvm: check tlbs_dirty directly
Date:   Mon, 22 Feb 2021 13:36:47 +0100
Message-Id: <20210222121028.503479620@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit 88bf56d04bc3564542049ec4ec168a8b60d0b48c upstream

In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
        need_tlb_flush |= kvm->tlbs_dirty;
with need_tlb_flush's type being int and tlbs_dirty's type being long.

It means that tlbs_dirty is always used as int and the higher 32 bits
is useless.  We need to check tlbs_dirty in a correct way and this
change checks it directly without propagating it to need_tlb_flush.

Note: it's _extremely_ unlikely this neglecting of higher 32 bits can
cause problems in practice.  It would require encountering tlbs_dirty
on a 4 billion count boundary, and KVM would need to be using shadow
paging or be running a nested guest.

Cc: stable@vger.kernel.org
Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20201217154118.16497-1-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -382,9 +382,8 @@ static void kvm_mmu_notifier_invalidate_
 	 */
 	kvm->mmu_notifier_count++;
 	need_tlb_flush = kvm_unmap_hva_range(kvm, start, end);
-	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush)
+	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);


