Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985E743A222
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhJYTpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237040AbhJYTnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:43:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94403610EA;
        Mon, 25 Oct 2021 19:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190662;
        bh=R4AlfhHQrrwlU615CMvwMHsdnRiRMgjDXaLB02MIEtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t92fhQKr3IfrbkU8hUSfxSsDYbCbaXx6lGwFfksly38eOUyGek/AINQygfqXRzmlS
         TH3ZrSx+66y1oALQR2pkww0k9RwOQKwNi5W1m9ZXyoo2+1Q/47zFw8cAfA6DdZFGKr
         gT3kYD5OCpzJUfXgpGDKuEQRdNp5A3QovYTFegKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 023/169] KVM: arm64: Release mmap_lock when using VM_SHARED with MTE
Date:   Mon, 25 Oct 2021 21:13:24 +0200
Message-Id: <20211025191020.700306629@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit 6e6a8ef088e1222cb1250942f51ad9c1ab219ab2 ]

VM_SHARED mappings are currently forbidden in a memslot with MTE to
prevent two VMs racing to sanitise the same page. However, this check
is performed while holding current->mm's mmap_lock, but fails to release
it. Fix this by releasing the lock when needed.

Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211005122031.809857-1-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0625bf2353c2..3fcdacfee579 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1477,8 +1477,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		 * when updating the PG_mte_tagged page flag, see
 		 * sanitise_mte_tags for more details.
 		 */
-		if (kvm_has_mte(kvm) && vma->vm_flags & VM_SHARED)
-			return -EINVAL;
+		if (kvm_has_mte(kvm) && vma->vm_flags & VM_SHARED) {
+			ret = -EINVAL;
+			break;
+		}
 
 		if (vma->vm_flags & VM_PFNMAP) {
 			/* IO region dirty page logging not allowed */
-- 
2.33.0



