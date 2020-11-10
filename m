Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596742ACDBB
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbgKJEEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732628AbgKJDyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F4A22080A;
        Tue, 10 Nov 2020 03:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980463;
        bh=L9hys1Giri6V/FU+HlVhSRrLuGhgm3iyfg9ETMDZEj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICLUn1MghNRns9G3b1KYdITIzhQPl64YzZ9wkd76T7pJvkVGVga2u1fBFNEpVy/qM
         Q3h44tKd8RxO+R+UbCpbiSr6JbIaJCG/0LZig6IAiTGqj3+OKojVhKIS7FEwBke70d
         8rMg/4+dH/CD4L657xQIEkachNMbBrTmcIfhIdOI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 45/55] iomap: clean up writeback state logic on writepage error
Date:   Mon,  9 Nov 2020 22:53:08 -0500
Message-Id: <20201110035318.423757-45-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 50e7d6c7a5210063b9a6f0d8799d9d1440907fcf ]

The iomap writepage error handling logic is a mash of old and
slightly broken XFS writepage logic. When keepwrite writeback state
tracking was introduced in XFS in commit 0d085a529b42 ("xfs: ensure
WB_SYNC_ALL writeback handles partial pages correctly"), XFS had an
additional cluster writeback context that scanned ahead of
->writepage() to process dirty pages over the current ->writepage()
extent mapping. This context expected a dirty page and required
retention of the TOWRITE tag on partial page processing so the
higher level writeback context would revisit the page (in contrast
to ->writepage(), which passes a page with the dirty bit already
cleared).

The cluster writeback mechanism was eventually removed and some of
the error handling logic folded into the primary writeback path in
commit 150d5be09ce4 ("xfs: remove xfs_cancel_ioend"). This patch
accidentally conflated the two contexts by using the keepwrite logic
in ->writepage() without accounting for the fact that the page is
not dirty. Further, the keepwrite logic has no practical effect on
the core ->writepage() caller (write_cache_pages()) because it never
revisits a page in the current function invocation.

Technically, the page should be redirtied for the keepwrite logic to
have any effect. Otherwise, write_cache_pages() may find the tagged
page but will skip it since it is clean. Even if the page was
redirtied, however, there is still no practical effect to keepwrite
since write_cache_pages() does not wrap around within a single
invocation of the function. Therefore, the dirty page would simply
end up retagged on the next writeback sequence over the associated
range.

All that being said, none of this really matters because redirtying
a partially processed page introduces a potential infinite redirty
-> writeback failure loop that deviates from the current design
principle of clearing the dirty state on writepage failure to avoid
building up too much dirty, unreclaimable memory on the system.
Therefore, drop the spurious keepwrite usage and dirty state
clearing logic from iomap_writepage_map(), treat the partially
processed page the same as a fully processed page, and let the
imminent ioend failure clean up the writeback state.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index b115e7d47fcec..238613443bec2 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1395,6 +1395,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	WARN_ON_ONCE(!wpc->ioend && !list_empty(&submit_list));
 	WARN_ON_ONCE(!PageLocked(page));
 	WARN_ON_ONCE(PageWriteback(page));
+	WARN_ON_ONCE(PageDirty(page));
 
 	/*
 	 * We cannot cancel the ioend directly here on error.  We may have
@@ -1415,21 +1416,9 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 			unlock_page(page);
 			goto done;
 		}
-
-		/*
-		 * If the page was not fully cleaned, we need to ensure that the
-		 * higher layers come back to it correctly.  That means we need
-		 * to keep the page dirty, and for WB_SYNC_ALL writeback we need
-		 * to ensure the PAGECACHE_TAG_TOWRITE index mark is not removed
-		 * so another attempt to write this page in this writeback sweep
-		 * will be made.
-		 */
-		set_page_writeback_keepwrite(page);
-	} else {
-		clear_page_dirty_for_io(page);
-		set_page_writeback(page);
 	}
 
+	set_page_writeback(page);
 	unlock_page(page);
 
 	/*
-- 
2.27.0

