Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5459355FEC
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfFZDna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbfFZDna (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:30 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B065205ED;
        Wed, 26 Jun 2019 03:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520609;
        bh=WQG4d7wo+oT5gncaeN0iEZzrks+hX0cXQBbrKttkDlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUcE084K2KRcE/FFl+hqg91ZWD1kWylsIRx8keUUQWpXH9KGe6Kq0PMWacbzfyM2F
         kyJEOEY0GR/Wt9U7PbA2GpDLQmmZyl0sDcYSPGg+zVKnB7eEIV0PK6rzkg2gq7LP9q
         zAdb8G36+jQlFtd0FlqdaMyE116871+vSxTqHaAE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     swkhack <swkhack@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.1 48/51] mm/mlock.c: change count_mm_mlocked_page_nr return type
Date:   Tue, 25 Jun 2019 23:41:04 -0400
Message-Id: <20190626034117.23247-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: swkhack <swkhack@gmail.com>

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
index 080f3b36415b..d614163f569b 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -636,11 +636,11 @@ static int apply_vma_lock_flags(unsigned long start, size_t len,
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

