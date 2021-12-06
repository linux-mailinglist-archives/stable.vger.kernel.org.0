Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CBC469BEA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347198AbhLFPRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47452 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356809AbhLFPPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:15:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A83DBB810E7;
        Mon,  6 Dec 2021 15:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0869C341C2;
        Mon,  6 Dec 2021 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803535;
        bh=5TwPh6Xbe+N736CO1QPweO1XgFLhSjELyl+FGv8OlDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpCque7GUIr3BS5MUHr/p+nAd2jePEvHbJDii9x9lK1G/VCYAMToclX5xysQfuF2K
         cmAzA3PBbBrwAf7dGzOBxyy6z++QGa8XDOP7mgK3k4SXe3OesvnIl2ufVfKwiIAJt1
         tHT3PmPeOwtetmgaHKTknDPXsCeHYbj0rpkhmTfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/70] gfs2: Fix length of holes reported at end-of-file
Date:   Mon,  6 Dec 2021 15:56:09 +0100
Message-Id: <20211206145552.093880966@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit f3506eee81d1f700d9ee2d2f4a88fddb669ec032 ]

Fix the length of holes reported at the end of a file: the length is
relative to the beginning of the extent, not the seek position which is
rounded down to the filesystem block size.

This bug went unnoticed for some time, but is now caught by the
following assertion in iomap_iter_done():

  WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index aaec3c5b02028..dec5285a02e9d 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -940,7 +940,7 @@ static int gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 		else if (height == ip->i_height)
 			ret = gfs2_hole_size(inode, lblock, len, mp, iomap);
 		else
-			iomap->length = size - pos;
+			iomap->length = size - iomap->offset;
 	} else if (flags & IOMAP_WRITE) {
 		u64 alloc_size;
 
-- 
2.33.0



