Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02D96B429B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjCJOE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjCJOEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:04:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E281091D7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62E1260D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE8CC4339E;
        Fri, 10 Mar 2023 14:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457080;
        bh=8ghZjGPY7u+3R5WbdEOWGAi4bKIDBJgWj9lAqmtjbDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWSTKO+aHSbiH9TVQS5hL2Wci91ds+v9k+uHns5sfTgE5n/btJ4+O5z1ntgjgtqUY
         erBBi88aAKi2VZDD8uHIn3oFhjMXIqUa0lH6jE707pNhdHb9deJh0agqa2X5hPV26U
         oMeEIZCDCTI4a9i+uCTDglQfrX6UqMXdyQKoi1XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/200] f2fs: introduce trace_f2fs_replace_atomic_write_block
Date:   Fri, 10 Mar 2023 14:37:01 +0100
Message-Id: <20230310133717.483050995@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2f3a9ae990a7881c9a57a073bb52ebe34fdc3160 ]

Commit 3db1de0e582c ("f2fs: change the current atomic write way")
removed old tracepoints, but it missed to add new one, this patch
fixes to introduce trace_f2fs_replace_atomic_write_block to trace
atomic_write commit flow.

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c           |  3 +++
 include/trace/events/f2fs.h | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c1d0713666ee5..af9a3b7996b4d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -250,6 +250,9 @@ static int __replace_atomic_write_block(struct inode *inode, pgoff_t index,
 	}
 
 	f2fs_put_dnode(&dn);
+
+	trace_f2fs_replace_atomic_write_block(inode, F2FS_I(inode)->cow_inode,
+					index, *old_addr, new_addr, recover);
 	return 0;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index ff57e7f9914cc..e57f867191ef1 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -1286,6 +1286,43 @@ DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
 	TP_ARGS(page, type)
 );
 
+TRACE_EVENT(f2fs_replace_atomic_write_block,
+
+	TP_PROTO(struct inode *inode, struct inode *cow_inode, pgoff_t index,
+			block_t old_addr, block_t new_addr, bool recovery),
+
+	TP_ARGS(inode, cow_inode, index, old_addr, new_addr, recovery),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(ino_t,	cow_ino)
+		__field(pgoff_t, index)
+		__field(block_t, old_addr)
+		__field(block_t, new_addr)
+		__field(bool, recovery)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->cow_ino	= cow_inode->i_ino;
+		__entry->index		= index;
+		__entry->old_addr	= old_addr;
+		__entry->new_addr	= new_addr;
+		__entry->recovery	= recovery;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, cow_ino = %lu, index = %lu, "
+			"old_addr = 0x%llx, new_addr = 0x%llx, recovery = %d",
+		show_dev_ino(__entry),
+		__entry->cow_ino,
+		(unsigned long)__entry->index,
+		(unsigned long long)__entry->old_addr,
+		(unsigned long long)__entry->new_addr,
+		__entry->recovery)
+);
+
 TRACE_EVENT(f2fs_filemap_fault,
 
 	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long ret),
-- 
2.39.2



