Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1534F324D61
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhBYJ6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235601AbhBYJ4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:56:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048B664F12;
        Thu, 25 Feb 2021 09:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246867;
        bh=UEDpM2iNq1Jh298bEQH9lI2lZIkdVnRfLGHTU/RCeyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LbII0DNa6xFsmVvp8/WvfEadQvdCuoC0KdqHPR4W03PmfI3340uIzyCp7ZHfmeYL
         6wMAZmYdO2d42VYC8SiWihflvW1tSIPRFhUX5q/OlToAxI52BJn4nXBPa++RuLqrmi
         tA//1ZEBt5NmCOu6l4pqbICXcMIBaJ4xUhBLC5lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Kaspar <zkaspar82@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 09/12] KVM: x86: Zap the oldest MMU pages, not the newest
Date:   Thu, 25 Feb 2021 10:53:43 +0100
Message-Id: <20210225092515.434032433@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
References: <20210225092515.015261674@linuxfoundation.org>
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
@@ -2417,7 +2417,7 @@ static unsigned long kvm_mmu_zap_oldest_
 		return 0;
 
 restart:
-	list_for_each_entry_safe(sp, tmp, &kvm->arch.active_mmu_pages, link) {
+	list_for_each_entry_safe_reverse(sp, tmp, &kvm->arch.active_mmu_pages, link) {
 		/*
 		 * Don't zap active root pages, the page itself can't be freed
 		 * and zapping it will just force vCPUs to realloc and reload.


