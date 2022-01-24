Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AEA499A0A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456574AbiAXVjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453928AbiAXVbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:31:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72672C06137B;
        Mon, 24 Jan 2022 12:20:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 305BAB8122F;
        Mon, 24 Jan 2022 20:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE94C340E5;
        Mon, 24 Jan 2022 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055604;
        bh=Fy97BY3BCmq+EiEuDqWIRCj+/y9yRMgy604pK4Qo1iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=undDHj5LqMSYSla+RNLhQjYKm42mbMsR8kZVfhmQxM3ZXza/MIdAJJUsmOca9Tso/
         qQaQ/oxvtETze/e1xpOZNALDgFJuZAebT3OVFRwpsA3R8EqGKr1vGaPeYrb1kYMtKN
         k9sMTcJ8G+kPuuZn97s7ZqlSR58R0xMb8HCjUBXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/846] arm64: mte: DC {GVA,GZVA} shouldnt be used when DCZID_EL0.DZP == 1
Date:   Mon, 24 Jan 2022 19:35:22 +0100
Message-Id: <20220124184108.001144253@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

[ Upstream commit 685e2564daa1493053fcd7f1dbed38b35ee2f3cb ]

Currently, mte_set_mem_tag_range() and mte_zero_clear_page_tags() use
DC {GVA,GZVA} unconditionally.  But, they should make sure that
DCZID_EL0.DZP, which indicates whether or not use of those instructions
is prohibited, is zero when using those instructions.
Use ST{G,ZG,Z2G} instead when DCZID_EL0.DZP == 1.

Fixes: 013bb59dbb7c ("arm64: mte: handle tags zeroing at page allocation time")
Fixes: 3d0cca0b02ac ("kasan: speed up mte_set_mem_tag_range")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Link: https://lore.kernel.org/r/20211206004736.1520989-3-reijiw@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/mte-kasan.h | 8 +++++---
 arch/arm64/lib/mte.S               | 8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
index 22420e1f8c037..26e013e540ae2 100644
--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -84,10 +84,12 @@ static inline void __dc_gzva(u64 p)
 static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag,
 					 bool init)
 {
-	u64 curr, mask, dczid_bs, end1, end2, end3;
+	u64 curr, mask, dczid, dczid_bs, dczid_dzp, end1, end2, end3;
 
 	/* Read DC G(Z)VA block size from the system register. */
-	dczid_bs = 4ul << (read_cpuid(DCZID_EL0) & 0xf);
+	dczid = read_cpuid(DCZID_EL0);
+	dczid_bs = 4ul << (dczid & 0xf);
+	dczid_dzp = (dczid >> 4) & 1;
 
 	curr = (u64)__tag_set(addr, tag);
 	mask = dczid_bs - 1;
@@ -106,7 +108,7 @@ static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag,
 	 */
 #define SET_MEMTAG_RANGE(stg_post, dc_gva)		\
 	do {						\
-		if (size >= 2 * dczid_bs) {		\
+		if (!dczid_dzp && size >= 2 * dczid_bs) {\
 			do {				\
 				curr = stg_post(curr);	\
 			} while (curr < end1);		\
diff --git a/arch/arm64/lib/mte.S b/arch/arm64/lib/mte.S
index e83643b3995f4..f531dcb95174a 100644
--- a/arch/arm64/lib/mte.S
+++ b/arch/arm64/lib/mte.S
@@ -43,17 +43,23 @@ SYM_FUNC_END(mte_clear_page_tags)
  *	x0 - address to the beginning of the page
  */
 SYM_FUNC_START(mte_zero_clear_page_tags)
+	and	x0, x0, #(1 << MTE_TAG_SHIFT) - 1	// clear the tag
 	mrs	x1, dczid_el0
+	tbnz	x1, #4, 2f	// Branch if DC GZVA is prohibited
 	and	w1, w1, #0xf
 	mov	x2, #4
 	lsl	x1, x2, x1
-	and	x0, x0, #(1 << MTE_TAG_SHIFT) - 1	// clear the tag
 
 1:	dc	gzva, x0
 	add	x0, x0, x1
 	tst	x0, #(PAGE_SIZE - 1)
 	b.ne	1b
 	ret
+
+2:	stz2g	x0, [x0], #(MTE_GRANULE_SIZE * 2)
+	tst	x0, #(PAGE_SIZE - 1)
+	b.ne	2b
+	ret
 SYM_FUNC_END(mte_zero_clear_page_tags)
 
 /*
-- 
2.34.1



