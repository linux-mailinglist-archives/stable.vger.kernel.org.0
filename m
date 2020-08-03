Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA7723A627
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgHCMpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgHCM1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:27:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DC98207FC;
        Mon,  3 Aug 2020 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457662;
        bh=5zeqietPhyhUpjpUe2K3zAjtmebUM/EY9MObnePZxdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tC7suW3kc6NUDhSfWM2FfA2nTwpRT8xLHzDJf2s+Yxo6+HqcMffnLv2a4/HovODWF
         4r1dug6vaRex083LFvRJBH3yHmfQd7XOlNwFfy/kFsyYIdPod4J18L8+y4+L6GdPAr
         Q92RHI/+hSvRRk9l5/VOY/rLagSvZH7uqnBkfq/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Robert Stupp <snazy@gmx.de>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        SeongJae Park <sjpark@amazon.com>
Subject: [PATCH 5.4 06/90] mm/filemap.c: dont bother dropping mmap_sem for zero size readahead
Date:   Mon,  3 Aug 2020 14:18:28 +0200
Message-Id: <20200803121857.853351983@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 5c72feee3e45b40a3c96c7145ec422899d0e8964 upstream.

When handling a page fault, we drop mmap_sem to start async readahead so
that we don't block on IO submission with mmap_sem held.  However there's
no point to drop mmap_sem in case readahead is disabled.  Handle that case
to avoid pointless dropping of mmap_sem and retrying the fault.  This was
actually reported to block mlockall(MCL_CURRENT) indefinitely.

Fixes: 6b4c9f446981 ("filemap: drop the mmap_sem for all blocking operations")
Reported-by: Minchan Kim <minchan@kernel.org>
Reported-by: Robert Stupp <snazy@gmx.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Link: http://lkml.kernel.org/r/20200212101356.30759-1-jack@suse.cz
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: SeongJae Park <sjpark@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2438,7 +2438,7 @@ static struct file *do_async_mmap_readah
 	pgoff_t offset = vmf->pgoff;
 
 	/* If we don't want any read-ahead, don't bother */
-	if (vmf->vma->vm_flags & VM_RAND_READ)
+	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;


