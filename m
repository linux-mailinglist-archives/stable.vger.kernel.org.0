Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652013830E3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbhEQOcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239997AbhEQO3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:29:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE7A7611ED;
        Mon, 17 May 2021 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260900;
        bh=pnKSpHyz9pQmxPkhijylRsJgz8hvUcVRIQ3sz0mB/KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePOtFEGyoDUHqOWrqAplyR+cvsM2ekRaqkIzLL+F47VkCGw2nxxBW+dSp2vkJoLJr
         3v6hErZin0UTRsfznlkaj3GlFGiwumLRI4p7oPfzyQ0ZOB3RQhWhgW9Z1IN6zxm02S
         ELxeUu9bqgou9FrekNFqXgNsZlFMJ4E2DNhHRpww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.12 263/363] arm64: Fix race condition on PG_dcache_clean in __sync_icache_dcache()
Date:   Mon, 17 May 2021 16:02:09 +0200
Message-Id: <20210517140311.497540449@linuxfoundation.org>
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

From: Catalin Marinas <catalin.marinas@arm.com>

commit 588a513d34257fdde95a9f0df0202e31998e85c6 upstream.

To ensure that instructions are observable in a new mapping, the arm64
set_pte_at() implementation cleans the D-cache and invalidates the
I-cache to the PoU. As an optimisation, this is only done on executable
mappings and the PG_dcache_clean page flag is set to avoid future cache
maintenance on the same page.

When two different processes map the same page (e.g. private executable
file or shared mapping) there's a potential race on checking and setting
PG_dcache_clean via set_pte_at() -> __sync_icache_dcache(). While on the
fault paths the page is locked (PG_locked), mprotect() does not take the
page lock. The result is that one process may see the PG_dcache_clean
flag set but the I/D cache maintenance not yet performed.

Avoid test_and_set_bit(PG_dcache_clean) in favour of separate test_bit()
and set_bit(). In the rare event of a race, the cache maintenance is
done twice.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210514095001.13236-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/flush.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/flush.c
+++ b/arch/arm64/mm/flush.c
@@ -55,8 +55,10 @@ void __sync_icache_dcache(pte_t pte)
 {
 	struct page *page = pte_page(pte);
 
-	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
+	if (!test_bit(PG_dcache_clean, &page->flags)) {
 		sync_icache_aliases(page_address(page), page_size(page));
+		set_bit(PG_dcache_clean, &page->flags);
+	}
 }
 EXPORT_SYMBOL_GPL(__sync_icache_dcache);
 


