Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4EC27C86F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgI2MCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730489AbgI2Ljj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:39:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B56F5206E5;
        Tue, 29 Sep 2020 11:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379579;
        bh=j47Y/OmtPQBlLz+805C+9tGJZUihfnFkicJQ1q/pSBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kw3C1XaWYuOQhzDEeZH+14SErpgO09h6WPX7eJy7ISiLY0gsiuL/7T+wd356Qzvok
         JWW4RKr74974QnMesiQTwNfL5mYLneHj0s4p1C1Hh3U/1e2U3aeZQ/BdbH50wohE5N
         9+BINzmv6qVVzXel8xvO+m4TzqniJjw3tpuMxctQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaewon Kim <jaewon31.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Michel Lespinasse <walken@google.com>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 227/388] mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area
Date:   Tue, 29 Sep 2020 12:59:18 +0200
Message-Id: <20200929110021.466184620@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaewon Kim <jaewon31.kim@samsung.com>

[ Upstream commit 09ef5283fd96ac424ef0e569626f359bf9ab86c9 ]

On passing requirement to vm_unmapped_area, arch_get_unmapped_area and
arch_get_unmapped_area_topdown did not set align_offset.  Internally on
both unmapped_area and unmapped_area_topdown, if info->align_mask is 0,
then info->align_offset was meaningless.

But commit df529cabb7a2 ("mm: mmap: add trace point of
vm_unmapped_area") always prints info->align_offset even though it is
uninitialized.

Fix this uninitialized value issue by setting it to 0 explicitly.

Before:
  vm_unmapped_area: addr=0x755b155000 err=0 total_vm=0x15aaf0 flags=0x1 len=0x109000 lo=0x8000 hi=0x75eed48000 mask=0x0 ofs=0x4022

After:
  vm_unmapped_area: addr=0x74a4ca1000 err=0 total_vm=0x168ab1 flags=0x1 len=0x9000 lo=0x8000 hi=0x753d94b000 mask=0x0 ofs=0x0

Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/20200409094035.19457-1-jaewon31.kim@samsung.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index a3584a90c55c2..ba78f1f1b1bd1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2126,6 +2126,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
 	info.align_mask = 0;
+	info.align_offset = 0;
 	return vm_unmapped_area(&info);
 }
 #endif
@@ -2167,6 +2168,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
+	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
 
 	/*
-- 
2.25.1



