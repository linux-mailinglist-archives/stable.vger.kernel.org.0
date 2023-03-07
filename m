Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F0E6AEF65
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbjCGSXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjCGSXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009FAA5D7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:17:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E078614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AABC433D2;
        Tue,  7 Mar 2023 18:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213055;
        bh=magvKc9oqzhBIkVOZeadV4RVHiBsvGCswlVrCNyeDcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjDNx+JfFIkaAzKH1TJ+OfHNIm1nsIJKqqlcFF+j/DFnKLrldobImVZfe0S31YYll
         mTdU8xmTOytcTZQBEEZnCKSa2iYoz1fuzrAOyyro5+QS1Lf6s38uMpLNXu2FXMEb+b
         JlXf/u68k9LE1o0GhPvcCe/OY642KG+1E2llvpDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 384/885] gfs2: jdata writepage fix
Date:   Tue,  7 Mar 2023 17:55:18 +0100
Message-Id: <20230307170019.026980581@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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



