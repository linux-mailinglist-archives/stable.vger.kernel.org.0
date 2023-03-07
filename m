Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F466AEAA1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjCGRfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjCGRfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:35:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03695A676F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9260AB819A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC41AC433D2;
        Tue,  7 Mar 2023 17:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210276;
        bh=magvKc9oqzhBIkVOZeadV4RVHiBsvGCswlVrCNyeDcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EerPGRg3iJHqROTOoja++VwlmeR0sBZW650XHJEdDFt7Gk/w+Zj/9G3P2+J41XWaD
         yBJFGExNh9gVlWsBOoxnzVD/jDzcQJARTxbOJixePiJmN4ZV4EKLBB0pzFWRyNO2M/
         qUb4y0pLhYomzPGkT9h5bPU5QuJZr8YypD7l0ges=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0460/1001] gfs2: jdata writepage fix
Date:   Tue,  7 Mar 2023 17:53:52 +0100
Message-Id: <20230307170041.352618068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit cbb60951ce18c9b6e91d2eb97deb41d8ff616622 ]

The ->writepage() and ->writepages() operations are supposed to write
entire pages.  However, on filesystems with a block size smaller than
PAGE_SIZE, __gfs2_jdata_writepage() only adds the first block to the
current transaction instead of adding the entire page.  Fix that.

Fixes: 18ec7d5c3f43 ("[GFS2] Make journaled data files identical to normal files on disk")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/aops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index e782b4f1d1043..2f04c0ff7470b 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -127,7 +127,6 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
 	if (PageChecked(page)) {
 		ClearPageChecked(page);
@@ -135,7 +134,7 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 			create_empty_buffers(page, inode->i_sb->s_blocksize,
 					     BIT(BH_Dirty)|BIT(BH_Uptodate));
 		}
-		gfs2_page_add_databufs(ip, page, 0, sdp->sd_vfs->s_blocksize);
+		gfs2_page_add_databufs(ip, page, 0, PAGE_SIZE);
 	}
 	return gfs2_write_jdata_page(page, wbc);
 }
-- 
2.39.2



