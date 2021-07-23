Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1565B3D3294
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhGWDRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233743AbhGWDRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B6760F36;
        Fri, 23 Jul 2021 03:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012665;
        bh=NBwycyZpcWFpXMuqm52Myl7XVI6DIA0P1rTPJSPJshM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ic2nJKIrCBwu3sfucijcpkEErlDZrR//hMefpeHrlWl4CI1cAQwW0iYJGL80rbU4q
         sze5ctQpWDJR47y/GrjdBjcS0vaYg4nXDj7XR3hW4YcsGMrR4Vr8WKgz64e2awIsr/
         /i44iKTd8D9o8UEE9b9GzM3aoEncJq3WmrYoWQO7j5KVHgDdGb7FskPmscO+IwL8Qx
         qS7IHAlqOfffgGqk3D5RTJlHrjUnSD4C5buEfkc+SdG5VbKg8ygwGdZtoxVXmjvW7G
         PW0VfVvenMbpG+EY6i5yGxuVjYwwbosB5ChoYscD6M4EkVy7tcvnvpiYusRsXmURb7
         CD17QKXMUBHGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Leizhen <thunder.leizhen@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 17/19] iomap: remove the length variable in iomap_seek_data
Date:   Thu, 22 Jul 2021 23:57:18 -0400
Message-Id: <20210723035721.531372-17-sashal@kernel.org>
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

[ Upstream commit 3ac1d426510f97ace05093ae9f2f710d9cbe6215 ]

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
 fs/iomap/seek.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index dab1b02eba5b..50b8f1418f26 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -83,27 +83,23 @@ loff_t
 iomap_seek_data(struct inode *inode, loff_t offset, const struct iomap_ops *ops)
 {
 	loff_t size = i_size_read(inode);
-	loff_t length = size - offset;
 	loff_t ret;
 
 	/* Nothing to be found before or beyond the end of the file. */
 	if (offset < 0 || offset >= size)
 		return -ENXIO;
 
-	while (length > 0) {
-		ret = iomap_apply(inode, offset, length, IOMAP_REPORT, ops,
-				  &offset, iomap_seek_data_actor);
+	while (offset < size) {
+		ret = iomap_apply(inode, offset, size - offset, IOMAP_REPORT,
+				  ops, &offset, iomap_seek_data_actor);
 		if (ret < 0)
 			return ret;
 		if (ret == 0)
-			break;
-
+			return offset;
 		offset += ret;
-		length -= ret;
 	}
 
-	if (length <= 0)
-		return -ENXIO;
-	return offset;
+	/* We've reached the end of the file without finding data */
+	return -ENXIO;
 }
 EXPORT_SYMBOL_GPL(iomap_seek_data);
-- 
2.30.2

