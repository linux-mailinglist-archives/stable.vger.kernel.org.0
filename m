Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C48498D0C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346751AbiAXT1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:27:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52506 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348369AbiAXTYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:24:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 701D760010;
        Mon, 24 Jan 2022 19:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE41C340E5;
        Mon, 24 Jan 2022 19:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052250;
        bh=+CWjJhb3LHq2nkKWhUKIM9khMf6V6/hB/5bZ3Edscmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdLidgITTPvkiMhvT638G1YDoxJOlWinwWKOquAN6Zf8FIU1LAv2v2QJd5dcliS6P
         oyNNV2rtOXbjzHmuIAnNYhr3x61CVSrMmQF5F0dg1oBt/EeULLwO+fHSLuJmyNPND9
         EoPP4EyVzb5Es3zqMDaz8YkqZvULIHSNFsmaHzqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 237/239] mips,s390,sh,sparc: gup: Work around the "COW can break either way" issue
Date:   Mon, 24 Jan 2022 19:44:35 +0100
Message-Id: <20220124183950.633915249@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

In Linux 4.14 and 4.19 these architectures still have their own
implementations of get_user_pages_fast().  These also need to force
the write flag on when taking the fast path.

Fixes: 407faed92b4a ("gup: document and work around "COW can break either way" issue")
Fixes: 5e24029791e8 ("gup: document and work around "COW can break either way" issue")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/mm/gup.c  |    9 ++++++++-
 arch/s390/mm/gup.c  |    9 ++++++++-
 arch/sh/mm/gup.c    |    9 ++++++++-
 arch/sparc/mm/gup.c |    9 ++++++++-
 4 files changed, 32 insertions(+), 4 deletions(-)

--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -274,7 +274,14 @@ int get_user_pages_fast(unsigned long st
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_enable();
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -287,7 +287,14 @@ int get_user_pages_fast(unsigned long st
 
 	might_sleep();
 	start &= PAGE_MASK;
-	nr = __get_user_pages_fast(start, nr_pages, write, pages);
+	/*
+	 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+	 * because get_user_pages() may need to cause an early COW in
+	 * order to avoid confusing the normal COW routines. So only
+	 * targets that are already writable are safe to do by just
+	 * looking at the page tables.
+	 */
+	nr = __get_user_pages_fast(start, nr_pages, 1, pages);
 	if (nr == nr_pages)
 		return nr;
 
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -242,7 +242,14 @@ int get_user_pages_fast(unsigned long st
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_enable();
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -303,7 +303,14 @@ int get_user_pages_fast(unsigned long st
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 


