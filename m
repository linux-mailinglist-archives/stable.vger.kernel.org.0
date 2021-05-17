Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F2D383037
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbhEQOZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239271AbhEQOWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 700FF61242;
        Mon, 17 May 2021 14:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260725;
        bh=ggzgiK2KK9osGXto5Yoydw2qtqMmS2X5cvTtKI0/8Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/11dgDfnk9H9W1RBYL1bRTkVFJnZkXCK1EjCNJffhiP3Ai887falhsg538Bmc3y4
         KHLVQAkLmWqyzLXf3d4K02hccR131PcQlkGqvgtMU+Qk8bVZp9nG7EdBSSV82AzPHj
         Aem7RUNwbKClezABPMOK7g6eP/T7HKKUOVigbGHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandipan Das <sandipan@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 211/363] powerpc/powernv/memtrace: Fix dcache flushing
Date:   Mon, 17 May 2021 16:01:17 +0200
Message-Id: <20210517140309.711008455@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan@linux.ibm.com>

[ Upstream commit b910fcbada9721c21f1d59ab59e07e8e354c23cc ]

Trace memory is cleared and the corresponding dcache lines
are flushed after allocation. However, this should not be
done using the PFN. This adds the missing conversion to
virtual address.

Fixes: 2ac02e5ecec0 ("powerpc/mm: Remove dcache flush from memory remove.")
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210501160254.1179831-1-sandipan@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/memtrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/memtrace.c b/arch/powerpc/platforms/powernv/memtrace.c
index 019669eb21d2..4ab7c3ef5826 100644
--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -88,8 +88,8 @@ static void memtrace_clear_range(unsigned long start_pfn,
 	 * Before we go ahead and use this range as cache inhibited range
 	 * flush the cache.
 	 */
-	flush_dcache_range_chunked(PFN_PHYS(start_pfn),
-				   PFN_PHYS(start_pfn + nr_pages),
+	flush_dcache_range_chunked((unsigned long)pfn_to_kaddr(start_pfn),
+				   (unsigned long)pfn_to_kaddr(start_pfn + nr_pages),
 				   FLUSH_CHUNK_SIZE);
 }
 
-- 
2.30.2



