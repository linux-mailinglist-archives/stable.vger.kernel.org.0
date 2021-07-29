Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E083DA519
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbhG2N6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237932AbhG2N5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4E6F60F42;
        Thu, 29 Jul 2021 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567061;
        bh=4ONx8zleb/J/EZvZr8o+gLi87G4j7rh8wL10QVPWXRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpLPImrFkSrr82o/Yhs8Z8VvTWPxvq1bZ15G5q/tSBCpfuiNTKuTunejNNckjXCEY
         D5n49nT2ph919A//d/3lYg0zxhtxzOp4ePN0cAJ/wiMaz7dAdDLP7gYkG1sz3K04wn
         uwsLZildK4KuOKhRm9m9IhPssK6WhZYQHjE4Gpew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/21] iomap: remove the length variable in iomap_seek_data
Date:   Thu, 29 Jul 2021 15:54:25 +0200
Message-Id: <20210729135143.490445612@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
References: <20210729135142.920143237@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



