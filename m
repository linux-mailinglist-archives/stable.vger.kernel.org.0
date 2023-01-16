Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C3266C90D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbjAPQp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbjAPQp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C050A3018D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:32:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74F53B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A1CC433EF;
        Mon, 16 Jan 2023 16:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886775;
        bh=2OGW+8QsRzBKRGRdCPmgVzw0jO0ZVCNtcmAC9dX2OzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6SMoqBdUwgW9uFMdFiyDYM82hYz1bbUkgAsmcbTuQ3Kv6Nnb7pHi4/31UZ8t/4UC
         QtqBVGTqe7xUcdFfnznSis5xL6cloENBojG2QOMz4mEyX3i4PLAmJRvQBP6p3j3RJS
         1ZIpWvjJURMe1Xh6eGzZPXPEH6CAUW/uiSx/TZVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 558/658] ext4: use memcpy_to_page() in pagecache_write()
Date:   Mon, 16 Jan 2023 16:50:46 +0100
Message-Id: <20230116154935.030748636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit bd256fda92efe97b692dc72e246d35fa724d42d8 ]

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Link: https://lore.kernel.org/r/20210207190425.38107-7-chaitanya.kulkarni@wdc.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 956510c0c743 ("fs: ext4: initialize fsdata in pagecache_write()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/verity.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 6a30e54c1128..0c67b7060eb4 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -80,7 +80,6 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
 		void *fsdata;
-		void *addr;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
@@ -88,9 +87,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		if (res)
 			return res;
 
-		addr = kmap_atomic(page);
-		memcpy(addr + offset_in_page(pos), buf, n);
-		kunmap_atomic(addr);
+		memcpy_to_page(page, offset_in_page(pos), buf, n);
 
 		res = pagecache_write_end(NULL, inode->i_mapping, pos, n, n,
 					  page, fsdata);
-- 
2.35.1



