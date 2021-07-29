Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8423DA583
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbhG2OCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238114AbhG2N7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D363E60EE2;
        Thu, 29 Jul 2021 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567163;
        bh=+tUf8UsEFsnhIbkN1zSKvp4omNtzqg1OVxJOYm4VOpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeUhMtWm4f/1TQw5cOVFaxN/lUNa5+82R1mEK4cSoyey28a+I8jxodNJsGsOVZ7Pw
         m/AjTaQKLfrYySmhllicqkqbF6usOX8IfUkZ7IGCen2kbaJVaruwt9PzzTMpfnMnA5
         o9cKQCCn1Hwgu7c0aSLsUJQ+dqIsAvsqLi319aHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 20/22] iomap: remove the length variable in iomap_seek_hole
Date:   Thu, 29 Jul 2021 15:54:51 +0200
Message-Id: <20210729135137.962725840@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
References: <20210729135137.336097792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



