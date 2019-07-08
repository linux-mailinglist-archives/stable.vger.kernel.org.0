Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932B662244
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbfGHPYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388296AbfGHPYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:24:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66009216C4;
        Mon,  8 Jul 2019 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599445;
        bh=hgQ+2bVAoQQuV8KG06d4Eq1oE3qf1lul/5N4UIfJLCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+44ugMoRSgjQPn2bQq+vPhsiLSR7VjRCt9lUoncIkMtNlqkRcRs1KcOw0dZrlVWv
         C9aRzcieoVM5pcd+pRBY3nG55EaZjxVr8R1BxmNSmlOqWTy4+iNpy8X5IW5ef+fpWP
         y1xjy8L2v+MJer8+zdt01IH49Ou6pjUrUGEutOfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, swkhack <swkhack@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/56] mm/mlock.c: change count_mm_mlocked_page_nr return type
Date:   Mon,  8 Jul 2019 17:13:10 +0200
Message-Id: <20190708150520.182687785@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0874bb49bb21bf24deda853e8bf61b8325e24bcb ]

On a 64-bit machine the value of "vma->vm_end - vma->vm_start" may be
negative when using 32 bit ints and the "count >> PAGE_SHIFT"'s result
will be wrong.  So change the local variable and return value to
unsigned long to fix the problem.

Link: http://lkml.kernel.org/r/20190513023701.83056-1-swkhack@gmail.com
Fixes: 0cf2f6f6dc60 ("mm: mlock: check against vma for actual mlock() size")
Signed-off-by: swkhack <swkhack@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mlock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 46af369c13e5..1f9ee86672e8 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -629,11 +629,11 @@ static int apply_vma_lock_flags(unsigned long start, size_t len,
  * is also counted.
  * Return value: previously mlocked page counts
  */
-static int count_mm_mlocked_page_nr(struct mm_struct *mm,
+static unsigned long count_mm_mlocked_page_nr(struct mm_struct *mm,
 		unsigned long start, size_t len)
 {
 	struct vm_area_struct *vma;
-	int count = 0;
+	unsigned long count = 0;
 
 	if (mm == NULL)
 		mm = current->mm;
-- 
2.20.1



