Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C62469F20
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391437AbhLFPpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390540AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724A4C0698D0;
        Mon,  6 Dec 2021 07:27:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 391C3B810E7;
        Mon,  6 Dec 2021 15:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2ADC34901;
        Mon,  6 Dec 2021 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804476;
        bh=IXA0CVp9SYoCYm4mlREv4C9eZ/bobKpZTmnrBHkg9Xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqyGmuZaUGU9KLbWic6A3I03pT22MucnDNc2inoEPx/mIn39ipT1Bzv8UvaaL/BV0
         THm7f9/jQeSYFnPHSx6m1roOFtTCTU8+dgLWBvYPFjTXxiYxBauBTmlXD93+0zx3li
         GQSntru8fweNOq4fLZhh++W3lnA3BpX6hsD3aGYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/207] KVM: X86: Fix when shadow_root_level=5 && guest root_level<4
Date:   Mon,  6 Dec 2021 15:56:54 +0100
Message-Id: <20211206145615.815799251@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit 12ec33a705749e18d9588b0a0e69e02821371156 ]

If the is an L1 with nNPT in 32bit, the shadow walk starts with
pae_root.

Fixes: a717a780fc4e ("KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host)
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211124122055.64424-2-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c9b1d63d3cfba..287fc1086db78 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2188,10 +2188,10 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 	iterator->shadow_addr = root;
 	iterator->level = vcpu->arch.mmu->shadow_root_level;
 
-	if (iterator->level == PT64_ROOT_4LEVEL &&
+	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
 	    !vcpu->arch.mmu->direct_map)
-		--iterator->level;
+		iterator->level = PT32E_ROOT_LEVEL;
 
 	if (iterator->level == PT32E_ROOT_LEVEL) {
 		/*
-- 
2.33.0



