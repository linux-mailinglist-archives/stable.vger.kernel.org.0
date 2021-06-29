Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7DB3B70D8
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 12:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhF2KnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 06:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232410AbhF2KnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 06:43:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A6F261DA7;
        Tue, 29 Jun 2021 10:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624963239;
        bh=sVkpmzQWCEEL9ONBlbVeGLRgcYrRDZb2ULQ+nFyRzcA=;
        h=From:To:Cc:Subject:Date:From;
        b=GfsuvHKEafoMf6jUf4q3uDvPoc/enit+62jqOsUE0IfvCIrE9wRRuDovrG+a0WLJO
         VnPoEgnNYNKWdNEzTL3BQfTKby+bsIn1MyE283r/zMA+DolOk3wG7H5bHARHrbpeXI
         2q08FJKGJQKmElGgg9upmFOd7j9aPe5hzffczyW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        iLifetruth <yixiaonn@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Qiang Liu <cyruscyliu@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] nds32: fix up stack guard gap
Date:   Tue, 29 Jun 2021 12:40:24 +0200
Message-Id: <20210629104024.2293615-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; h=from:subject; bh=sVkpmzQWCEEL9ONBlbVeGLRgcYrRDZb2ULQ+nFyRzcA=; b=owGbwMvMwCRo6H6F97bub03G02pJDAm3fkx6Pquq2nlT2sJVrpLa22wcv6qffFK/Vk/nJyNT+syn lwzmd8SyMAgyMciKKbJ82cZzdH/FIUUvQ9vTMHNYmUCGMHBxCsBE5CczLFh8Pi30j1tcWY7/rt0nz+ yVZ5+1q5xhrrDVB6Pbxl+2Lvh/LzxluWrQrZocTgA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 1be7107fbe18 ("mm: larger stack guard gap, between vmas") fixed
up almost all architectures to deal with the stack guard gap, but forgit
nds32.

Resolve this by properly fixing up the nsd32's version of
arch_get_unmapped_area()

Reported-by: iLifetruth <yixiaonn@gmail.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Qiang Liu <cyruscyliu@gmail.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nds32/mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nds32/mm/mmap.c b/arch/nds32/mm/mmap.c
index c206b31ce07a..1bdf5e7d1b43 100644
--- a/arch/nds32/mm/mmap.c
+++ b/arch/nds32/mm/mmap.c
@@ -59,7 +59,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 
 		vma = find_vma(mm, addr);
 		if (TASK_SIZE - len >= addr &&
-		    (!vma || addr + len <= vma->vm_start))
+		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
 
-- 
2.32.0

