Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3B02E3C61
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436540AbgL1OAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:00:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436533AbgL1OAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C752B207AB;
        Mon, 28 Dec 2020 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163995;
        bh=16ofqNDOtTdD+Nbw3rTnBhytlvP13deUuWsiMlij8zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=maB5Pon4rQFeqLklMvF/GH+N70Q2+qXiOM903gzb/XhUzb3iFFvn91jUsomnQATBd
         gePVYvVxR4xTggBQsD09d0ydoETlQSeaB+il43NQxrWIgGIfj2UOKZfcyDodZtko7b
         /apGkkuZAhCvlqxstUwJtJorE3bgyoeJ/IO/egFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/717] x86/mm/ident_map: Check for errors from ident_pud_init()
Date:   Mon, 28 Dec 2020 13:40:22 +0100
Message-Id: <20201228125022.140943892@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit 1fcd009102ee02e217f2e7635ab65517d785da8e ]

Commit

  ea3b5e60ce80 ("x86/mm/ident_map: Add 5-level paging support")

added ident_p4d_init() to support 5-level paging, but this function
doesn't check and return errors from ident_pud_init().

For example, the decompressor stub uses this code to create an identity
mapping. If it runs out of pages while trying to allocate a PMD
pagetable, the error will be currently ignored.

Fix this to propagate errors.

 [ bp: Space out statements for better readability. ]

Fixes: ea3b5e60ce80 ("x86/mm/ident_map: Add 5-level paging support")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lkml.kernel.org/r/20201027230648.1885111-1-nivedita@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/ident_map.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
index fe7a12599d8eb..968d7005f4a72 100644
--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -62,6 +62,7 @@ static int ident_p4d_init(struct x86_mapping_info *info, p4d_t *p4d_page,
 			  unsigned long addr, unsigned long end)
 {
 	unsigned long next;
+	int result;
 
 	for (; addr < end; addr = next) {
 		p4d_t *p4d = p4d_page + p4d_index(addr);
@@ -73,13 +74,20 @@ static int ident_p4d_init(struct x86_mapping_info *info, p4d_t *p4d_page,
 
 		if (p4d_present(*p4d)) {
 			pud = pud_offset(p4d, 0);
-			ident_pud_init(info, pud, addr, next);
+			result = ident_pud_init(info, pud, addr, next);
+			if (result)
+				return result;
+
 			continue;
 		}
 		pud = (pud_t *)info->alloc_pgt_page(info->context);
 		if (!pud)
 			return -ENOMEM;
-		ident_pud_init(info, pud, addr, next);
+
+		result = ident_pud_init(info, pud, addr, next);
+		if (result)
+			return result;
+
 		set_p4d(p4d, __p4d(__pa(pud) | info->kernpg_flag));
 	}
 
-- 
2.27.0



