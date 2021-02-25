Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E1F324D96
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhBYKG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233242AbhBYKAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 05:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A32F64F24;
        Thu, 25 Feb 2021 09:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246937;
        bh=oqiyN2ScAinz7TTlGaA9INPUXIh/BHpEd3EzpD1fVZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAQpATIr+GpZ7aLlHmMhGDpFdgfzoOMyJ7O/Qwyw7nWX9bdLBbJwgwoOz6h23g5F8
         AaOQqChOxvqk9ySO0s3zCO8pY4sAZu9uhBSy/o+qB9eH9Sp1AcgqxYem/HKsrl1b2s
         4Gz65gcIfdWHs5W7OqHTb7fqGijkGPx674w5bhlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Kaspar <zkaspar82@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 12/23] KVM: x86: Zap the oldest MMU pages, not the newest
Date:   Thu, 25 Feb 2021 10:53:43 +0100
Message-Id: <20210225092517.119149578@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 8fc517267fb28576dfca2380cc2497a2454b8fae upstream.

Walk the list of MMU pages in reverse in kvm_mmu_zap_oldest_mmu_pages().
The list is FIFO, meaning new pages are inserted at the head and thus
the oldest pages are at the tail.  Using a "forward" iterator causes KVM
to zap MMU pages that were just added, which obliterates guest
performance once the max number of shadow MMU pages is reached.

Fixes: 6b82ef2c9cf1 ("KVM: x86/mmu: Batch zap MMU pages when recycling oldest pages")
Reported-by: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210113205030.3481307-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2409,7 +2409,7 @@ static unsigned long kvm_mmu_zap_oldest_
 		return 0;
 
 restart:
-	list_for_each_entry_safe(sp, tmp, &kvm->arch.active_mmu_pages, link) {
+	list_for_each_entry_safe_reverse(sp, tmp, &kvm->arch.active_mmu_pages, link) {
 		/*
 		 * Don't zap active root pages, the page itself can't be freed
 		 * and zapping it will just force vCPUs to realloc and reload.


