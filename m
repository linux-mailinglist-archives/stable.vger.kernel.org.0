Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B403C528EB6
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiEPToG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346014AbiEPTnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:43:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAF03FD8D;
        Mon, 16 May 2022 12:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87DB261553;
        Mon, 16 May 2022 19:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F99C385AA;
        Mon, 16 May 2022 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730155;
        bh=BO0DyT3J8Z8jJIztXuh6s6+Ts0kppFb2DcBZxBghirE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqgRdcMm63O5XhRNGCMDITAYW27c2PvkRwesoBJGwIpFM/nSvfS2tTJyofWWSoiAY
         3R3Yaz1iPjTuj8palvfrxquCvQfKxaPN2f/7YMKGJrTPMIcE7TSCvZf5sNvAmWEaD1
         7tm/EOvtZAnz8JU4RPpHxenCv7Br6xPrGHcNrcdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/43] gfs2: Fix filesystem block deallocation for short writes
Date:   Mon, 16 May 2022 21:36:28 +0200
Message-Id: <20220516193615.226395080@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit d031a8866e709c9d1ee5537a321b6192b4d2dc5b ]

When a write cannot be carried out in full, gfs2_iomap_end() releases
blocks that have been allocated for this write but haven't been used.

To compute the end of the allocation, gfs2_iomap_end() incorrectly
rounded the end of the attempted write down to the next block boundary
to arrive at the end of the allocation.  It would have to round up, but
the end of the allocation is also available as iomap->offset +
iomap->length, so just use that instead.

In addition, use round_up() for computing the start of the unused range.

Fixes: 64bc06bb32ee ("gfs2: iomap buffered write support")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index dec5285a02e9..77a497a4b236 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1233,13 +1233,12 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 	if (length != written && (iomap->flags & IOMAP_F_NEW)) {
 		/* Deallocate blocks that were just allocated. */
-		loff_t blockmask = i_blocksize(inode) - 1;
-		loff_t end = (pos + length) & ~blockmask;
+		loff_t hstart = round_up(pos + written, i_blocksize(inode));
+		loff_t hend = iomap->offset + iomap->length;
 
-		pos = (pos + written + blockmask) & ~blockmask;
-		if (pos < end) {
-			truncate_pagecache_range(inode, pos, end - 1);
-			punch_hole(ip, pos, end - pos);
+		if (hstart < hend) {
+			truncate_pagecache_range(inode, hstart, hend - 1);
+			punch_hole(ip, hstart, hend - hstart);
 		}
 	}
 
-- 
2.35.1



