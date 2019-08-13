Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856088BD19
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 17:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfHMP2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 11:28:16 -0400
Received: from 8bytes.org ([81.169.241.247]:48944 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfHMP2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 11:28:12 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E17EC1D3; Tue, 13 Aug 2019 17:28:09 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/3] x86/mm: Check for pfn instead of page in vmalloc_sync_one()
Date:   Tue, 13 Aug 2019 17:28:03 +0200
Message-Id: <20190813152805.5251-2-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813152805.5251-1-joro@8bytes.org>
References: <20190813152805.5251-1-joro@8bytes.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 51b75b5b563a2637f9d8dc5bd02a31b2ff9e5ea0 upstream.

Do not require a struct page for the mapped memory location because it
might not exist. This can happen when an ioremapped region is mapped with
2MB pages.

Fixes: 5d72b4fba40ef ('x86, mm: support huge I/O mapping capability I/F')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20190719184652.11391-2-joro@8bytes.org
---
 arch/x86/mm/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9d9765e4d1ef..4d12176a470e 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -267,7 +267,7 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	if (!pmd_present(*pmd))
 		set_pmd(pmd, *pmd_k);
 	else
-		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
+		BUG_ON(pmd_pfn(*pmd) != pmd_pfn(*pmd_k));
 
 	return pmd_k;
 }
-- 
2.16.4

