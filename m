Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69D538360A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbhEQP1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242810AbhEQPZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4ACB613F3;
        Mon, 17 May 2021 14:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262171;
        bh=NSsqVeWI/aMWf9NH32tBVF3Q4W4cpI/mjD7psRtOA+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9+gBqbrMuCT8RdXtTlrNHtsncQRfFcoCXW1eVQXF/TB8W39UnJvw5sNXPbB7yWXt
         CKjgQKSVyfF1VCy7sStHYZ+9geG+Wg2TmlMkwsXYyT+gMkvKUVbBJ7C5BRfLbxfYH4
         HQrEmeG2XNnX29ond94aH0E9nAB7Fb+QHca6+1eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Isaev <isaev@synopsys.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.11 231/329] ARC: mm: Use max_high_pfn as a HIGHMEM zone border
Date:   Mon, 17 May 2021 16:02:22 +0200
Message-Id: <20210517140309.925703257@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Isaev <isaev@synopsys.com>

commit 1d5e4640e5df15252398c1b621f6bd432f2d7f17 upstream.

Commit 4af22ded0ecf ("arc: fix memory initialization for systems
with two memory banks") fixed highmem, but for the PAE case it causes
bug messages:

| BUG: Bad page state in process swapper  pfn:80000
| page:(ptrval) refcount:0 mapcount:1 mapping:00000000 index:0x0 pfn:0x80000 flags: 0x0()
| raw: 00000000 00000100 00000122 00000000 00000000 00000000 00000000 00000000
| raw: 00000000
| page dumped because: nonzero mapcount
| Modules linked in:
| CPU: 0 PID: 0 Comm: swapper Not tainted 5.12.0-rc5-00003-g1e43c377a79f #1

This is because the fix expects highmem to be always less than
lowmem and uses min_low_pfn as an upper zone border for highmem.

max_high_pfn should be ok for both highmem and highmem+PAE cases.

Fixes: 4af22ded0ecf ("arc: fix memory initialization for systems with two memory banks")
Signed-off-by: Vladimir Isaev <isaev@synopsys.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: stable@vger.kernel.org  #5.8 onwards
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/mm/init.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -157,7 +157,16 @@ void __init setup_arch_memory(void)
 	min_high_pfn = PFN_DOWN(high_mem_start);
 	max_high_pfn = PFN_DOWN(high_mem_start + high_mem_sz);
 
-	max_zone_pfn[ZONE_HIGHMEM] = min_low_pfn;
+	/*
+	 * max_high_pfn should be ok here for both HIGHMEM and HIGHMEM+PAE.
+	 * For HIGHMEM without PAE max_high_pfn should be less than
+	 * min_low_pfn to guarantee that these two regions don't overlap.
+	 * For PAE case highmem is greater than lowmem, so it is natural
+	 * to use max_high_pfn.
+	 *
+	 * In both cases, holes should be handled by pfn_valid().
+	 */
+	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
 
 	high_memory = (void *)(min_high_pfn << PAGE_SHIFT);
 


