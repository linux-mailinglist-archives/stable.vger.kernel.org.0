Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BC63D32CC
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhGWDST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234200AbhGWDR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 276A660F36;
        Fri, 23 Jul 2021 03:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012713;
        bh=PcJSEufoi0i8jRxWfiKREwhqCPga+r/UzzLHV2wQEnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBeLVZSP3iVZ5R436dWTy+VhSNFV5x2gaXeiCA9QwYz/I+mAEwm31/7YTrBDEtHXm
         qMwMT9Ir9CFesdQV7Rmtl9zIfqJMn+jJZaPxF9SRAVLe6jawtq50hEiBZ3BFs+sp9/
         KvsAsaECkXG48Q0B8+73kR44vO1QUACefmEkyDXGQ40Gy1Q/qqVj/Qhx/v2rFepc+D
         4xw7XoqkXFQK9WA7n5C5vOpzszCuCxFcGUst91caOkQP6fAS8HNGMuC6TC3jJ/gG6f
         eXR52nW+Bi4YRiRCwuWVhI6eUJ+EKGZUav+zx9xka5JWDQC2vrZMXAqSlUmZoUO0Pd
         G1R6CQx+BRWqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Leizhen <thunder.leizhen@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/14] iomap: remove the length variable in iomap_seek_hole
Date:   Thu, 22 Jul 2021 23:58:12 -0400
Message-Id: <20210723035813.531837-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035813.531837-1-sashal@kernel.org>
References: <20210723035813.531837-1-sashal@kernel.org>
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
index c61b889235b3..10c4c1e80124 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -140,23 +140,20 @@ loff_t
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

