Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3F92F1459
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbhAKNXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732617AbhAKNRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D78D22B30;
        Mon, 11 Jan 2021 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371036;
        bh=3pEz0FIIu+fu/KJfgYF3aR7EIsGGl7yKccvVx1G/XRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a094M9auXmEblFJBzTMFy/JkC8MuJGWj3R2kGAABxyYaB6xeZOD8cG/W3UL79QrJi
         SgKkAMW6Q/G7xAAb+r8xY3Tofr7d9caGLq4Vjwyt2urAQ4xNdvK09KDLl+90ywZ3bs
         hC05WdZqzT2yLjJ0ivETcfmcbKfLn8+AQ0shlekg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 113/145] kvm: check tlbs_dirty directly
Date:   Mon, 11 Jan 2021 14:02:17 +0100
Message-Id: <20210111130053.957222980@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit 88bf56d04bc3564542049ec4ec168a8b60d0b48c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/kvm_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -482,9 +482,8 @@ static int kvm_mmu_notifier_invalidate_r
 	kvm->mmu_notifier_count++;
 	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
 					     range->flags);
-	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush)
+	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);


