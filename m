Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7719404F64
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351229AbhIIMS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349282AbhIIMQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:16:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD0D061A81;
        Thu,  9 Sep 2021 11:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188183;
        bh=xHALvjEpIWz1vlc9j7zhvfX1vK6Thq282rPyW89XmQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ta/4Y7JAecyHhB1wFvbzqmcNOH/wqwyDf0EI1BnCLCJuX8jFBkLRXHpxIZdZVxeP3
         n2YTh9bAXhXGusTLy/5WVxSSqyMGJf4efxYMZBG0Iohupbvaqw7KAIoWRz8fFY9kwO
         LtyWVCvkKnjnnnCCtXs42Drrwp/dZervEXpQDSC1GAB2V3RgonFG7u65KkO1hOPs/F
         Cbfm+D1eE++jvc2vWwRo5u5hWkT8JZOgropmzYAC9Z2DS91XuZdXbuUNZqqJNYGzKT
         Qw6pZH6LMmFUH1CdIBNZc1YelMch/KVpLKljc+2ve0tr2hq6nOskTcMSPDLKItjOFT
         xUN0GBU1jZ3oQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 145/219] iomap: pass writeback errors to the mapping
Date:   Thu,  9 Sep 2021 07:45:21 -0400
Message-Id: <20210909114635.143983-145-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 9023717c5188..35839acd0004 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1045,7 +1045,7 @@ iomap_finish_page_writeback(struct inode *inode, struct page *page,
 
 	if (error) {
 		SetPageError(page);
-		mapping_set_error(inode->i_mapping, -EIO);
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	WARN_ON_ONCE(i_blocks_per_page(inode, page) > 1 && !iop);
-- 
2.30.2

