Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDAE26B3C5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgIOXJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgIOOlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:41:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 176D52224D;
        Tue, 15 Sep 2020 14:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180287;
        bh=kqWVoB6h2CFpmY55/s5EOL3IJKW4VIsT2Cg+XF1ceas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dso/cic9ktB13Dvp9phT6UZot/2FpzOvbxA5f4U40aMp2lRDJg5xHmez02XHDQlbF
         5ETnrm2Psr9x+ewTX41bFXMAHszU6YylO8aQBhanlbDvFZj5wyu853Z2dyUcQILPaW
         /HOeFg/qBIS9ufFHP3tSDORM+rPt7Xleg2iOlMcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.8 156/177] KVM: arm64: Do not try to map PUDs when they are folded into PMD
Date:   Tue, 15 Sep 2020 16:13:47 +0200
Message-Id: <20200915140701.167300561@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 3fb884ffe921c99483a84b0175f3c03f048e9069 upstream.

For the obscure cases where PMD and PUD are the same size
(64kB pages with 42bit VA, for example, which results in only
two levels of page tables), we can't map anything as a PUD,
because there is... erm... no PUD to speak of. Everything is
either a PMD or a PTE.

So let's only try and map a PUD when its size is different from
that of a PMD.

Cc: stable@vger.kernel.org
Fixes: b8e0ba7c8bea ("KVM: arm64: Add support for creating PUD hugepages at stage 2")
Reported-by: Gavin Shan <gshan@redhat.com>
Reported-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/mmu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1968,7 +1968,12 @@ static int user_mem_abort(struct kvm_vcp
 		(fault_status == FSC_PERM &&
 		 stage2_is_exec(kvm, fault_ipa, vma_pagesize));
 
-	if (vma_pagesize == PUD_SIZE) {
+	/*
+	 * If PUD_SIZE == PMD_SIZE, there is no real PUD level, and
+	 * all we have is a 2-level page table. Trying to map a PUD in
+	 * this case would be fatally wrong.
+	 */
+	if (PUD_SIZE != PMD_SIZE && vma_pagesize == PUD_SIZE) {
 		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
 
 		new_pud = kvm_pud_mkhuge(new_pud);


