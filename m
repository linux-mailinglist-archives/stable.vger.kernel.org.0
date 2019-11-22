Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26142106D0B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfKVK5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbfKVK5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0BB2072E;
        Fri, 22 Nov 2019 10:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420228;
        bh=5MH6Ax/vtJQFiVkOpwSaJoxC1Gi53ZAWxPTk71j1TkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvnTW3rVsN8K3gTCFIV4Ou7Vfpdb0/aeE/5HYqfyuIN359esmjaTYm6FoDyduMQWv
         XLrESa3F4NYHQRmYlyWBubUtvGKjcSsDDPMn1nltOOUra2KiQsoTtK4auqoJK/Hk3u
         4FwYdEpbTmeRNVMyhYj8UL8MsLIDP4HIYhoWoRVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoffer Dall <cdall@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/220] kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table
Date:   Fri, 22 Nov 2019 11:26:41 +0100
Message-Id: <20191122100914.936074739@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit d2db7773ba864df6b4e19643dfc54838550d8049 ]

So far we have only supported 3 level page table with fixed IPA of
40bits, where PUD is folded. With 4 level page tables, we need
to check if the PUD entry is valid or not. Fix stage2_flush_memslot()
to do this check, before walking down the table.

Acked-by: Christoffer Dall <cdall@kernel.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 1344557a70852..bf330b493c1e7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -412,7 +412,8 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
 		next = stage2_pgd_addr_end(addr, end);
-		stage2_flush_puds(kvm, pgd, addr, next);
+		if (!stage2_pgd_none(*pgd))
+			stage2_flush_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
-- 
2.20.1



