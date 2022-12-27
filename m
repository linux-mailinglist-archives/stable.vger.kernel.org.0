Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54408656F07
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiL0UiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiL0Ug5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:36:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC18DFB4;
        Tue, 27 Dec 2022 12:34:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD33EB8109A;
        Tue, 27 Dec 2022 20:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B969AC433D2;
        Tue, 27 Dec 2022 20:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173249;
        bh=c3iKx+RfcNp6qCbZVsPpJZuhKsmkzbIh4o6nBe6FbgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XP+eq90kKTYe0xNUQZ132DYxf0tSkGVxgRqaxdYq8oGPZuu8kSYr5My3+8Ubk8w4M
         QDC7mdjY6mdRqdn7nr0S1+/KcH8v18ehdnr8YjjlW2rQtpItuMWbsT4hx4vjg5RUoJ
         B5oR7Ibpr6iN+fqSeAzfyTkerjtG6HdGrH/uI9iKT0NF/7oMj6NQNkskgeMtXYlXFE
         TcypbBhoTfYCZXvSptav13yjrUTnSfc8tAr12ROv3vaWI+ViYJgRyJiLsVMoePGPhQ
         kmEx5r4dhQgnR1OocXTfORhBIA2Un7ld2ZJNdj/EhJSQybrq/iaR4fHFIw9fPk6jSp
         hnxozn5yuphgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yin Xiujiang <yinxiujiang@kylinos.cn>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 18/27] fs/ntfs3: Fix slab-out-of-bounds in r_page
Date:   Tue, 27 Dec 2022 15:33:33 -0500
Message-Id: <20221227203342.1213918-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203342.1213918-1-sashal@kernel.org>
References: <20221227203342.1213918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yin Xiujiang <yinxiujiang@kylinos.cn>

[ Upstream commit ecfbd57cf9c5ca225184ae266ce44ae473792132 ]

When PAGE_SIZE is 64K, if read_log_page is called by log_read_rst for
the first time, the size of *buffer would be equal to
DefaultLogPageSize(4K).But for *buffer operations like memcpy,
if the memory area size(n) which being assigned to buffer is larger
than 4K (log->page_size(64K) or bytes(64K-page_off)), it will cause
an out of boundary error.
 Call trace:
  [...]
  kasan_report+0x44/0x130
  check_memory_region+0xf8/0x1a0
  memcpy+0xc8/0x100
  ntfs_read_run_nb+0x20c/0x460
  read_log_page+0xd0/0x1f4
  log_read_rst+0x110/0x75c
  log_replay+0x1e8/0x4aa0
  ntfs_loadlog_and_replay+0x290/0x2d0
  ntfs_fill_super+0x508/0xec0
  get_tree_bdev+0x1fc/0x34c
  [...]

Fix this by setting variable r_page to NULL in log_read_rst.

Signed-off-by: Yin Xiujiang <yinxiujiang@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 138050b1aa93..4236194af35e 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1132,7 +1132,7 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 		return -EINVAL;
 
 	if (!*buffer) {
-		to_free = kmalloc(bytes, GFP_NOFS);
+		to_free = kmalloc(log->page_size, GFP_NOFS);
 		if (!to_free)
 			return -ENOMEM;
 		*buffer = to_free;
@@ -1180,10 +1180,7 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 			struct restart_info *info)
 {
 	u32 skip, vbo;
-	struct RESTART_HDR *r_page = kmalloc(DefaultLogPageSize, GFP_NOFS);
-
-	if (!r_page)
-		return -ENOMEM;
+	struct RESTART_HDR *r_page = NULL;
 
 	/* Determine which restart area we are looking for. */
 	if (first) {
@@ -1197,7 +1194,6 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 	/* Loop continuously until we succeed. */
 	for (; vbo < l_size; vbo = 2 * vbo + skip, skip = 0) {
 		bool usa_error;
-		u32 sys_page_size;
 		bool brst, bchk;
 		struct RESTART_AREA *ra;
 
@@ -1251,24 +1247,6 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 			goto check_result;
 		}
 
-		/* Read the entire restart area. */
-		sys_page_size = le32_to_cpu(r_page->sys_page_size);
-		if (DefaultLogPageSize != sys_page_size) {
-			kfree(r_page);
-			r_page = kzalloc(sys_page_size, GFP_NOFS);
-			if (!r_page)
-				return -ENOMEM;
-
-			if (read_log_page(log, vbo,
-					  (struct RECORD_PAGE_HDR **)&r_page,
-					  &usa_error)) {
-				/* Ignore any errors. */
-				kfree(r_page);
-				r_page = NULL;
-				continue;
-			}
-		}
-
 		if (is_client_area_valid(r_page, usa_error)) {
 			info->valid_page = true;
 			ra = Add2Ptr(r_page, le16_to_cpu(r_page->ra_off));
-- 
2.35.1

