Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D123D3353
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 06:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbhGWDVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233858AbhGWDRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F09760C41;
        Fri, 23 Jul 2021 03:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012666;
        bh=+tUf8UsEFsnhIbkN1zSKvp4omNtzqg1OVxJOYm4VOpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxLpHrh43oPPOI6xIj7CieJok+Q1+fyjOaLPOd61wH6L21I9YI9tCUE5lmll3LbIg
         r62UY6h0531Q03gE8yddJDVa6rwQU0kN51blqUIEZcv0GTm13U9s7SwF/tawVf1VPd
         6XYc4KPncZ3WoqrkVp7X0CpeQvbBkzvzbUPOYJ9aTYrkMgxOIzaHLO/jmgUPT3O3XZ
         esx2x8qK6S+mg9VBWmLELtAmNnXBQpZINtF+NY/cXUlyOFOC9KGGtQMlJ7I7xtKs/o
         awfjyo1GTGxe7/DuzFWJCKFHsDznHRAiBUkpFEqNs+qIfRe3CJ+nazg+T+xD9h9BN6
         Tq5lr0lIYsIlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Leizhen <thunder.leizhen@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 18/19] iomap: remove the length variable in iomap_seek_hole
Date:   Thu, 22 Jul 2021 23:57:19 -0400
Message-Id: <20210723035721.531372-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035721.531372-1-sashal@kernel.org>
References: <20210723035721.531372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 49694d14ff68fa4b5f86019dbcfb44a8bd213e58 ]

The length variable is rather pointless given that it can be trivially
deduced from offset and size.  Also the initial calculation can lead
to KASAN warnings.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Leizhen (ThunderTown) <thunder.leizhen@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/seek.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index 50b8f1418f26..ce6fb810854f 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -35,23 +35,20 @@ loff_t
 iomap_seek_hole(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
 {
 	loff_t size = i_size_read(inode);
-	loff_t length = size - offset;
 	loff_t ret;
 
 	/* Nothing to be found before or beyond the end of the file. */
 	if (offset < 0 || offset >= size)
 		return -ENXIO;
 
-	while (length > 0) {
-		ret = iomap_apply(inode, offset, length, IOMAP_REPORT, ops,
-				  &offset, iomap_seek_hole_actor);
+	while (offset < size) {
+		ret = iomap_apply(inode, offset, size - offset, IOMAP_REPORT,
+				  ops, &offset, iomap_seek_hole_actor);
 		if (ret < 0)
 			return ret;
 		if (ret == 0)
 			break;
-
 		offset += ret;
-		length -= ret;
 	}
 
 	return offset;
-- 
2.30.2

