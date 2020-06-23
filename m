Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2508206684
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388515AbgFWVng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388046AbgFWUDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7122078A;
        Tue, 23 Jun 2020 20:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942610;
        bh=qlTTFYshQ7DBmBTg+fQe79WObOFPLuIlr88AUawQXrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqXIfmEZeKWb8EkE/SYtVvDF1p0GUZbngvW2G7OSOvsAezvShS+G7PUb8VwBLQYGq
         JU6WPhGobAebfHRSucpy3ZLNoRSclKhArn4n1+jkzav7K+RBSFFh9r8KkqktyiHiF5
         gOWTYWKoGsKN5rU4wxzxIxKQINpSpBvf0lsFAxy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 064/477] powerpc/book3s64/radix/tlb: Determine hugepage flush correctly
Date:   Tue, 23 Jun 2020 21:51:01 +0200
Message-Id: <20200623195410.644046112@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

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
index 758ade2c2b6ed..b5cc9b23cf024 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -884,9 +884,7 @@ is_local:
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



