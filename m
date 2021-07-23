Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC003D32B8
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhGWDSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234040AbhGWDRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A3D860ED4;
        Fri, 23 Jul 2021 03:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012689;
        bh=EN23vqeUyFQKL/fSjyJOpav1qRy5l+MKE1zie0Pd8QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDlEiNnXj8fqqtK4r1kjx7jV04NNvUhEHeYW+Jn3G172c+9hNMGebiY16PmvCWE4i
         lxhtOg6+rZJMtAE8F5V9GQbaru/7m2RsidRvpo8SgV4SsAfi6Z4wOQM9Jt4H6jdjIa
         jTgHOY1/YgnpEhjHZrrJBnPZZRIzkhsCuW5YHNciA2lI7kjAporlrvqCq7anP756/k
         0qVTb5v2lXR9G9eNcn2bbire//kxfbAhpV+kRUe1rpAxGS7e+BahHQ600cKxO3316M
         UlGyKqSkmPF8O81UfQbrsV8WtRkhf8RCbqf8JAxjMFVZodn7enYCdbI/soG4VjJV9n
         LlHYtARltl+dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Leizhen <thunder.leizhen@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/17] iomap: remove the length variable in iomap_seek_data
Date:   Thu, 22 Jul 2021 23:57:46 -0400
Message-Id: <20210723035748.531594-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035748.531594-1-sashal@kernel.org>
References: <20210723035748.531594-1-sashal@kernel.org>
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
index 107ee80c3568..271edcc84a28 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -186,27 +186,23 @@ loff_t
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

