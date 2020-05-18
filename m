Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62361D8259
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbgERRzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:32982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbgERRzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E87520674;
        Mon, 18 May 2020 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824537;
        bh=K9sOYabv7aBb7ZHiBg2GiocuIAbCVTcXXK9GiqX+y08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z76dSyrW5hp5xsdmi40Qd+Vjpul9l5KJphVSbBGvqXkAbZ4fTnafoBINg1sxywoCb
         3dJbwOxQN4W6n+oQnO163GWlo5Yl2O/lNUYBvq1KGaILBmxr6dVL5aMNO6r97BWsBj
         jBhZdqB6INP2VuLRYJR/5EByjZfd3maFTwJsLEvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/147] gfs2: Another gfs2_walk_metadata fix
Date:   Mon, 18 May 2020 19:36:15 +0200
Message-Id: <20200518173520.446979306@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 566a2ab3c9005f62e784bd39022d58d34ef4365c ]

Make sure we don't walk past the end of the metadata in gfs2_walk_metadata: the
inode holds fewer pointers than indirect blocks.

Slightly clean up gfs2_iomap_get.

Fixes: a27a0c9b6a20 ("gfs2: gfs2_walk_metadata fix")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index f63df54a08c6c..adbb8fef22162 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -528,10 +528,12 @@ static int gfs2_walk_metadata(struct inode *inode, struct metapath *mp,
 
 		/* Advance in metadata tree. */
 		(mp->mp_list[hgt])++;
-		if (mp->mp_list[hgt] >= sdp->sd_inptrs) {
-			if (!hgt)
+		if (hgt) {
+			if (mp->mp_list[hgt] >= sdp->sd_inptrs)
+				goto lower_metapath;
+		} else {
+			if (mp->mp_list[hgt] >= sdp->sd_diptrs)
 				break;
-			goto lower_metapath;
 		}
 
 fill_up_metapath:
@@ -876,10 +878,9 @@ static int gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 					ret = -ENOENT;
 					goto unlock;
 				} else {
-					/* report a hole */
 					iomap->offset = pos;
 					iomap->length = length;
-					goto do_alloc;
+					goto hole_found;
 				}
 			}
 			iomap->length = size;
@@ -933,8 +934,6 @@ static int gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 	return ret;
 
 do_alloc:
-	iomap->addr = IOMAP_NULL_ADDR;
-	iomap->type = IOMAP_HOLE;
 	if (flags & IOMAP_REPORT) {
 		if (pos >= size)
 			ret = -ENOENT;
@@ -956,6 +955,9 @@ static int gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 		if (pos < size && height == ip->i_height)
 			ret = gfs2_hole_size(inode, lblock, len, mp, iomap);
 	}
+hole_found:
+	iomap->addr = IOMAP_NULL_ADDR;
+	iomap->type = IOMAP_HOLE;
 	goto out;
 }
 
-- 
2.20.1



