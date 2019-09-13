Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522AAB208D
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbfIMNXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390232AbfIMNVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:35 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8ABE216F4;
        Fri, 13 Sep 2019 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380895;
        bh=2vm8YHevuXCo4kKWe+2+Yss5Zn0lCSFJs4a64fJVIAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNVcnDCYkJAgFNtml5l08spPDWjAcztFY05a9vlgcpB2OU8qsGG9piFvKJtF9AzUw
         xwP1Y37RcDCFnOFrUFD1dpr9Suq8xH19KaPfN6WSncL3sFPwnGrNGEv8zUrmJhRnh/
         c6Xo7JCm66UeFStFLVLWjpsuDjjaPCX542aOWdKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 13/37] powerpc/64e: Drop stale call to smp_processor_id() which hangs SMP startup
Date:   Fri, 13 Sep 2019 14:07:18 +0100
Message-Id: <20190913130515.860737471@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit b9ee5e04fd77898208c51b1395fa0b5e8536f9b6 upstream.

Commit ebb9d30a6a74 ("powerpc/mm: any thread in one core can be the
first to setup TLB1") removed the need to know the cpu_id in
early_init_this_mmu(), but the call to smp_processor_id() which was
marked __maybe_used remained.

Since commit ed1cd6deb013 ("powerpc: Activate CONFIG_THREAD_INFO_IN_TASK")
thread_info cannot be reached before MMU is properly set up.

Drop this stale call to smp_processor_id() which makes SMP hang when
CONFIG_PREEMPT is set.

Fixes: ebb9d30a6a74 ("powerpc/mm: any thread in one core can be the first to setup TLB1")
Fixes: ed1cd6deb013 ("powerpc: Activate CONFIG_THREAD_INFO_IN_TASK")
Cc: stable@vger.kernel.org # v5.1+
Reported-by: Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/bef479514f4c08329fa649f67735df8918bc0976.1565268248.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/nohash/tlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/mm/nohash/tlb.c
+++ b/arch/powerpc/mm/nohash/tlb.c
@@ -630,7 +630,6 @@ static void early_init_this_mmu(void)
 #ifdef CONFIG_PPC_FSL_BOOK3E
 	if (mmu_has_feature(MMU_FTR_TYPE_FSL_E)) {
 		unsigned int num_cams;
-		int __maybe_unused cpu = smp_processor_id();
 		bool map = true;
 
 		/* use a quarter of the TLBCAM for bolted linear map */


