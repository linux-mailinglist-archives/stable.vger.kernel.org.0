Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AAC3D32CD
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhGWDST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234194AbhGWDR5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C521F60F4D;
        Fri, 23 Jul 2021 03:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012711;
        bh=4ONx8zleb/J/EZvZr8o+gLi87G4j7rh8wL10QVPWXRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3qQxoy9wtPDv8gNzlnNGpV1lIYLbx1Og66PmbdwoS8UwP4i8F9dxvaeyyc23O4bn
         +fEZZRv1mRz7qoU3KOEIR5gGNtd16bQb4yyuasuU+NcNTTO1VAqXpvPinpVr0+FFvL
         mUoutmkJiCc+wdCWrcRCOvDx3DHFeNHllj+XLjX7C/d6CXfxaoULj3FisJ9oKKdwFl
         GvrGL23mK4rUGpTP3yhLD+UFU/WqQonMFTHQo9M0Bq55aZ5iVIcy2HCiPOMe4UPShN
         uZhMsltyE4psinCWoDF73QV9n4MAN4efNtf2+Dib8bbifRZRjS95eCVgzwzbZ4YpGb
         PIpRVsn5PHRcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Leizhen <thunder.leizhen@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/14] iomap: remove the length variable in iomap_seek_data
Date:   Thu, 22 Jul 2021 23:58:11 -0400
Message-Id: <20210723035813.531837-12-sashal@kernel.org>
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
index c04bad4b2b43..c61b889235b3 100644
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

