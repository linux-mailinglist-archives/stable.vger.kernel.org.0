Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C175406F4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343980AbiFGRl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347574AbiFGRjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:39:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD2E3DA6B;
        Tue,  7 Jun 2022 10:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8053B820C3;
        Tue,  7 Jun 2022 17:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8CDC385A5;
        Tue,  7 Jun 2022 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623169;
        bh=803noPpmdd8jcZeDK1neNJXSR//7indM5D5x87bTTiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y96/sb43bLojXtogTkp3nvQqm/pF1saeiaI2ikEmkAklJgeOJTOzrLn/5uY7gjyF9
         BSaH/LHHZYT8NlW66m+wstbP+mh4ubOHcVyG7qwYD4ToDcVZ00uMkOUCXwTiv5gnvG
         g+0xGp/6xPHUsVy/IYsEYYLoJPHCwzxxwCEt4BNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakob Koschel <jakobkoschel@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/452] f2fs: fix dereference of stale list iterator after loop body
Date:   Tue,  7 Jun 2022 19:02:56 +0200
Message-Id: <20220607164918.063298905@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit 2aaf51dd39afb6d01d13f1e6fe20b684733b37d5 ]

The list iterator variable will be a bogus pointer if no break was hit.
Dereferencing it (cur->page in this case) could load an out-of-bounds/undefined
value making it unsafe to use that in the comparision to determine if the
specific element was found.

Since 'cur->page' *can* be out-ouf-bounds it cannot be guaranteed that
by chance (or intention of an attacker) it matches the value of 'page'
even though the correct element was not found.

This is fixed by using a separate list iterator variable for the loop
and only setting the original variable if a suitable element was found.
Then determing if the element was found is simply checking if the
variable is set.

Fixes: 8c242db9b8c0 ("f2fs: fix stale ATOMIC_WRITTEN_PAGE private pointer")
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 49f5cb532738..736fb57423a6 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -356,16 +356,19 @@ void f2fs_drop_inmem_page(struct inode *inode, struct page *page)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct list_head *head = &fi->inmem_pages;
 	struct inmem_pages *cur = NULL;
+	struct inmem_pages *tmp;
 
 	f2fs_bug_on(sbi, !IS_ATOMIC_WRITTEN_PAGE(page));
 
 	mutex_lock(&fi->inmem_lock);
-	list_for_each_entry(cur, head, list) {
-		if (cur->page == page)
+	list_for_each_entry(tmp, head, list) {
+		if (tmp->page == page) {
+			cur = tmp;
 			break;
+		}
 	}
 
-	f2fs_bug_on(sbi, list_empty(head) || cur->page != page);
+	f2fs_bug_on(sbi, !cur);
 	list_del(&cur->list);
 	mutex_unlock(&fi->inmem_lock);
 
-- 
2.35.1



