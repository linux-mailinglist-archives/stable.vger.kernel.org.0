Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445E376A3E
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfGZN5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbfGZNlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F62322BE8;
        Fri, 26 Jul 2019 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148476;
        bh=fpt9gHlgHFABDDyRXQzXw1gk5uU8yrS8EcsUFXPNdQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIiCtH4cmSCpAD4ZuU/N4Ddlz1h4I5XYuQBkjZNXToag3d6ogjYl/FuPZoPxVgUeV
         tG7D3tH66+uRHcMH0UxqwBm5pbpO7mZCgsRizUKVVyprCW6aF9yDeNiV2J/m/kdFFd
         cMwngPQUuE4rnAbZ1ieLPjBY3pu1A5JWIpqQmzSE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Will Deacon <will.deacon@arm.com>,
        Chintan Pandya <cpandya@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 59/85] mm/ioremap: check virtual address alignment while creating huge mappings
Date:   Fri, 26 Jul 2019 09:39:09 -0400
Message-Id: <20190726133936.11177-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 6b95ab4218bfa59bc315105127ffe03aef3b5742 ]

Virtual address alignment is essential in ensuring correct clearing for
all intermediate level pgtable entries and freeing associated pgtable
pages.  An unaligned address can end up randomly freeing pgtable page
that potentially still contains valid mappings.  Hence also check it's
alignment along with existing phys_addr check.

Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/ioremap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/ioremap.c b/lib/ioremap.c
index 063213685563..a95161d9c883 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -86,6 +86,9 @@ static int ioremap_try_huge_pmd(pmd_t *pmd, unsigned long addr,
 	if ((end - addr) != PMD_SIZE)
 		return 0;
 
+	if (!IS_ALIGNED(addr, PMD_SIZE))
+		return 0;
+
 	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
 		return 0;
 
@@ -126,6 +129,9 @@ static int ioremap_try_huge_pud(pud_t *pud, unsigned long addr,
 	if ((end - addr) != PUD_SIZE)
 		return 0;
 
+	if (!IS_ALIGNED(addr, PUD_SIZE))
+		return 0;
+
 	if (!IS_ALIGNED(phys_addr, PUD_SIZE))
 		return 0;
 
@@ -166,6 +172,9 @@ static int ioremap_try_huge_p4d(p4d_t *p4d, unsigned long addr,
 	if ((end - addr) != P4D_SIZE)
 		return 0;
 
+	if (!IS_ALIGNED(addr, P4D_SIZE))
+		return 0;
+
 	if (!IS_ALIGNED(phys_addr, P4D_SIZE))
 		return 0;
 
-- 
2.20.1

