Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D0A1FE893
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgFRBJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbgFRBJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33C9321D92;
        Thu, 18 Jun 2020 01:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442572;
        bh=VbvwX07h7tv/JNZrZ3PGvYl0YFbuhr9qHoWR3e3SoN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TnSmiB0gpUmHOt/bhDReDt9ZokH6KAzMGk8cbl+Bgf4iheIObCqeQG8uRvO/mJ45
         fBRFFhmZAXotYk++yHQw25yjtVvp4yR0wP0lKFXBYui3KvtMscdh4Y2bC2ZO6cTOP7
         dT5tqr81y+I1r3PPtV7ZddjJKoIPzTdCERz7mY28=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.7 065/388] powerpc/book3s64/radix/tlb: Determine hugepage flush correctly
Date:   Wed, 17 Jun 2020 21:02:42 -0400
Message-Id: <20200618010805.600873-65-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit 8f53f9c0f68ab2168f637494b9e24034899c1310 ]

With a 64K page size flush with start and end:

  (start, end) = (721f680d0000, 721f680e0000)

results in:

  (hstart, hend) = (721f68200000, 721f68000000)

ie. hstart is above hend, which indicates no huge page flush is
needed.

However the current logic incorrectly sets hflush = true in this case,
because hstart != hend.

That causes us to call __tlbie_va_range() passing hstart/hend, to do a
huge page flush even though we don't need to. __tlbie_va_range() will
skip the actual tlbie operation for start > end. But it will still end
up calling fixup_tlbie_va_range() and doing the TLB fixups in there,
which is harmless but unnecessary work.

Reported-by: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Drop else case, hflush is already false, flesh out change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200513030616.152288-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/radix_tlb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 758ade2c2b6e..b5cc9b23cf02 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -884,9 +884,7 @@ static inline void __radix__flush_tlb_range(struct mm_struct *mm,
 		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			hstart = (start + PMD_SIZE - 1) & PMD_MASK;
 			hend = end & PMD_MASK;
-			if (hstart == hend)
-				hflush = false;
-			else
+			if (hstart < hend)
 				hflush = true;
 		}
 
-- 
2.25.1

