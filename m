Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09E16DD70
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733029AbfGSEKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388098AbfGSEKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:10:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D55218B6;
        Fri, 19 Jul 2019 04:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509432;
        bh=rEOxhVje41GtsRNcgA834B2vdF8qdzCHLjggyEcMFM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+aMUavrXnh81sXlmspXJ+9K/U9W4Q3/cvhL/RIF9FDCCVE39iy70dJFC/YSYy7R2
         9W22NXzO95FNIveejdgjlJOm5PvKNZ5eI3H7xYIABMhVjw3JvEmCsK12tJ6CbR8qki
         gJ4XtSAXKmC0onyvicApzIRCbL9QUffGax/HAPKw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Robin Murphy <robin.murphy@arm.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 090/101] mm/gup.c: mark undo_dev_pagemap as __maybe_unused
Date:   Fri, 19 Jul 2019 00:07:21 -0400
Message-Id: <20190719040732.17285-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 790c73690c2bbecb3f6f8becbdb11ddc9bcff8cc ]

Several mips builds generate the following build warning.

  mm/gup.c:1788:13: warning: 'undo_dev_pagemap' defined but not used

The function is declared unconditionally but only called from behind
various ifdefs. Mark it __maybe_unused.

Link: http://lkml.kernel.org/r/1562072523-22311-1-git-send-email-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index caadd31714a5..43c71397c7ca 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1367,7 +1367,8 @@ static inline pte_t gup_get_pte(pte_t *ptep)
 }
 #endif
 
-static void undo_dev_pagemap(int *nr, int nr_start, struct page **pages)
+static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
+					    struct page **pages)
 {
 	while ((*nr) - nr_start) {
 		struct page *page = pages[--(*nr)];
-- 
2.20.1

