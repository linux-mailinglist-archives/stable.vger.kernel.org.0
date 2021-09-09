Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F663404C0C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241373AbhIILzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241089AbhIILxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 570C76138D;
        Thu,  9 Sep 2021 11:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187881;
        bh=E0Wwtt/RpBwqOEd5e7ec+rsEkQxJmd7cg46/1odlycA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrGW+5P6XFqDSyv4lLwvo3AyHMm/LrjG747uCDOu7xjg/LRbWqK7trnpxBCRaLmFo
         bbxZ/fHMEVOB3QtPXNEKyDBBsmMivaMJ1bgXMo4QAlxVZiOvmRCxN+67hB62eMWZcW
         mCSCg3TudC7nfceXFl6Q3jKP8HIRZj1niW4mAh7KCQ5Tiyi7rrb2ixnXvVNnvObdS6
         wE2/hRZNDWTkzhsCn/FA4LHebUY7946qk/UGCI/ceuYbtdr3l/zCDrETiwBbjwjipB
         +JcJFij1Kg3ICwO69QhLgnvge6tKzeGrh9ZNE35/DVM/UYRHGCeXdqFL76rMslIe7A
         Xrj+nEK+6BaOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 164/252] iomap: pass writeback errors to the mapping
Date:   Thu,  9 Sep 2021 07:39:38 -0400
Message-Id: <20210909114106.141462-164-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b69eea82d37d9ee7cfb3bf05103549dd4ed5ffc3 ]

Modern-day mapping_set_error has the ability to squash the usual
negative error code into something appropriate for long-term storage in
a struct address_space -- ENOSPC becomes AS_ENOSPC, and everything else
becomes EIO.  iomap squashes /everything/ to EIO, just as XFS did before
that, but this doesn't make sense.

Fix this by making it so that we can pass ENOSPC to userspace when
writeback fails due to space problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 87ccb3438bec..b06138c6190b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1016,7 +1016,7 @@ iomap_finish_page_writeback(struct inode *inode, struct page *page,
 
 	if (error) {
 		SetPageError(page);
-		mapping_set_error(inode->i_mapping, -EIO);
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	WARN_ON_ONCE(i_blocks_per_page(inode, page) > 1 && !iop);
-- 
2.30.2

