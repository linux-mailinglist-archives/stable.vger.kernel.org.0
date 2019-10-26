Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D254E5B21
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfJZNUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbfJZNUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19CC620867;
        Sat, 26 Oct 2019 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096038;
        bh=csRWAztyFgtKu6hrVl88CS566rdxacTIQKhsD+jkpHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEw/nFy5gIyxU/9ah8dhiIL3zvXQAagfJgc8t4EgtU5/AfE1VeoQDIxfcRvqFqIuc
         YWwwU0D9oSToKB8Sj63HA0UDB2NfNREyTZut1hNhgRjdyf24mJUfkzcrZn25i8pEcT
         SgOk3QGNFj5gSnw2mV7/MtteRWPzGfequ6CYC4aI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Tatashin <pasha.tatashin@soleen.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 46/59] arm64: hibernate: check pgd table allocation
Date:   Sat, 26 Oct 2019 09:18:57 -0400
Message-Id: <20191026131910.3435-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

[ Upstream commit 8c551f919a73c1dfa690a70a691be1da394145e8 ]

There is a bug in create_safe_exec_page(), when page table is allocated
it is not checked that table is allocated successfully:

But it is dereferenced in: pgd_none(READ_ONCE(*pgdp)).  Check that
allocation was successful.

Fixes: 82869ac57b5d ("arm64: kernel: Add support for hibernate/suspend-to-disk")
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 9859e1178e6be..dbeeeffdb9c9e 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -202,6 +202,7 @@ static int create_safe_exec_page(void *src_start, size_t length,
 				 gfp_t mask)
 {
 	int rc = 0;
+	pgd_t *trans_pgd;
 	pgd_t *pgdp;
 	pud_t *pudp;
 	pmd_t *pmdp;
@@ -216,7 +217,13 @@ static int create_safe_exec_page(void *src_start, size_t length,
 	memcpy((void *)dst, src_start, length);
 	__flush_icache_range(dst, dst + length);
 
-	pgdp = pgd_offset_raw(allocator(mask), dst_addr);
+	trans_pgd = allocator(mask);
+	if (!trans_pgd) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	pgdp = pgd_offset_raw(trans_pgd, dst_addr);
 	if (pgd_none(READ_ONCE(*pgdp))) {
 		pudp = allocator(mask);
 		if (!pudp) {
-- 
2.20.1

