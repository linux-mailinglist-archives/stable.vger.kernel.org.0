Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAAA83B5D
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfHFVep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727860AbfHFVeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0E05217D9;
        Tue,  6 Aug 2019 21:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127284;
        bh=iaM43qCCC5bNlVt7SIRVxodUFhg3MptrAPwcX2CNjwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptuiB3m8HEIss/MJbUgQYaGuCLCRfK1wBosMOuiP8oHx8MbOH15CO9F1hohwvfibj
         Gq1GPbbf9VipH3lxKQjmh1oXorykXU9vDx21uVnUi+aCTkooTYpT7w8J6nBctuEeb7
         To++mdEhksw79zx10RGmCJAvUsOwsqg18TX9k5BY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 42/59] arm64/mm: fix variable 'pud' set but not used
Date:   Tue,  6 Aug 2019 17:33:02 -0400
Message-Id: <20190806213319.19203-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 7d4e2dcf311d3b98421d1f119efe5964cafa32fc ]

GCC throws a warning,

arch/arm64/mm/mmu.c: In function 'pud_free_pmd_page':
arch/arm64/mm/mmu.c:1033:8: warning: variable 'pud' set but not used
[-Wunused-but-set-variable]
  pud_t pud;
        ^~~

because pud_table() is a macro and compiled away. Fix it by making it a
static inline function and for pud_sect() as well.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index fca26759081a7..b9574d850f14f 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -419,8 +419,8 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				 PMD_TYPE_SECT)
 
 #if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS < 3
-#define pud_sect(pud)		(0)
-#define pud_table(pud)		(1)
+static inline bool pud_sect(pud_t pud) { return false; }
+static inline bool pud_table(pud_t pud) { return true; }
 #else
 #define pud_sect(pud)		((pud_val(pud) & PUD_TYPE_MASK) == \
 				 PUD_TYPE_SECT)
-- 
2.20.1

