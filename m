Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385F84803B6
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhL0TE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhL0TEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0EAC06173E;
        Mon, 27 Dec 2021 11:04:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B3B2B81144;
        Mon, 27 Dec 2021 19:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A18BC36AEB;
        Mon, 27 Dec 2021 19:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631877;
        bh=jN8XbEdyMOfKvFmQaoGrfiE+SM32l2+uo956K9/gBvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwvhiDveGiYdQVZImhLvt1FXLyqXqw0VnphPqLCGASfOjIOOL1Dh1nh8kBF1Kv1ug
         itpMd6WdK4DlHsaHQlpjXsXJWoWxlRKYPWX84zAODtGvdmyHhQ9452cLOvPmfaKM4i
         UrZSbbrr4AaRkjK1XbhLMryA0Of9/+oiyaeSLC9zhj4959/dlu2VIsp8/IVs6waUq0
         iDz0ghSkdoY/SBvBk/OsSFcm6UMBe41R5Q9YvpBSp49Mcatl+XAnwaYsynZrLHYc/4
         o1RLjS3DZD+Ev1rPYJ6bkJ9VRZGlhVOz9owQesMewwCT189kLkXWyUncveJeqaCGZd
         mq4Z6FwHeuFdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jackie Liu <liuyun01@kylinos.cn>, k2ci <kernel-bot@kylinos.cn>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.15 23/26] memblock: fix memblock_phys_alloc() section mismatch error
Date:   Mon, 27 Dec 2021 14:03:24 -0500
Message-Id: <20211227190327.1042326-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit d7f55471db2719629f773c2d6b5742a69595bfd3 ]

Fix modpost Section mismatch error in memblock_phys_alloc()

[...]
WARNING: modpost: vmlinux.o(.text.unlikely+0x1dcc): Section mismatch in reference
from the function memblock_phys_alloc() to the function .init.text:memblock_phys_alloc_range()
The function memblock_phys_alloc() references
the function __init memblock_phys_alloc_range().
This is often because memblock_phys_alloc lacks a __init
annotation or the annotation of memblock_phys_alloc_range is wrong.

ERROR: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
[...]

memblock_phys_alloc() is a one-line wrapper, make it __always_inline to
avoid these section mismatches.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
[rppt: slightly massaged changelog ]
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Link: https://lore.kernel.org/r/20211217020754.2874872-1-liu.yun@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memblock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 34de69b3b8bad..5df38332e4139 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -388,8 +388,8 @@ phys_addr_t memblock_alloc_range_nid(phys_addr_t size,
 				      phys_addr_t end, int nid, bool exact_nid);
 phys_addr_t memblock_phys_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid);
 
-static inline phys_addr_t memblock_phys_alloc(phys_addr_t size,
-					      phys_addr_t align)
+static __always_inline phys_addr_t memblock_phys_alloc(phys_addr_t size,
+						       phys_addr_t align)
 {
 	return memblock_phys_alloc_range(size, align, 0,
 					 MEMBLOCK_ALLOC_ACCESSIBLE);
-- 
2.34.1

