Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC59C4F3AC1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243715AbiDELrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355220AbiDEKSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:18:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9857DFAF;
        Tue,  5 Apr 2022 03:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C9D6B81BC0;
        Tue,  5 Apr 2022 10:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDE2C385A2;
        Tue,  5 Apr 2022 10:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153065;
        bh=5PuHhTgGRWjN2ZSLN0sTtYu1icC2v3HqNQf4rFfQXxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fs4r4icO8d0tOTWWZyoODCs5fA+HwVuntBnM+V8xyfg7XJT6fJxYuzLn2YvRi+YhV
         Jlw/ck3nsf/1Ol7ApGgqyWtao39FO9xWwu3RwNTHmrltBavWVlVxJ7k//ykQognsuQ
         Rte6WuKY09cEq8xIZGYnj5oZiGXlNWfqulGm2o8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 090/599] ext4: fix ext4_fc_stats trace point
Date:   Tue,  5 Apr 2022 09:26:24 +0200
Message-Id: <20220405070301.508624107@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit 7af1974af0a9ba8a8ed2e3e947d87dd4d9a78d27 upstream.

ftrace's __print_symbolic() requires that any enum values used in the
symbol to string translation table be wrapped in a TRACE_DEFINE_ENUM
so that the enum value can be decoded from the ftrace ring buffer by
user space tooling.

This patch also fixes few other problems found in this trace point.
e.g. dereferencing structures in TP_printk which should not be done
at any cost.

Also to avoid checkpatch warnings, this patch removes those
whitespaces/tab stops issues.

Cc: stable@kernel.org
Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/b4b9691414c35c62e570b723e661c80674169f9a.1647057583.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/ext4.h |   80 +++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 30 deletions(-)

--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -95,6 +95,17 @@ TRACE_DEFINE_ENUM(ES_REFERENCED_B);
 	{ FALLOC_FL_COLLAPSE_RANGE,	"COLLAPSE_RANGE"},	\
 	{ FALLOC_FL_ZERO_RANGE,		"ZERO_RANGE"})
 
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_XATTR);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_CROSS_RENAME);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_JOURNAL_FLAG_CHANGE);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_NOMEM);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_SWAP_BOOT);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_RESIZE);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_RENAME_DIR);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_FALLOC_RANGE);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_INODE_JOURNAL_DATA);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
+
 #define show_fc_reason(reason)						\
 	__print_symbolic(reason,					\
 		{ EXT4_FC_REASON_XATTR,		"XATTR"},		\
@@ -2899,41 +2910,50 @@ TRACE_EVENT(ext4_fc_commit_stop,
 
 #define FC_REASON_NAME_STAT(reason)					\
 	show_fc_reason(reason),						\
-	__entry->sbi->s_fc_stats.fc_ineligible_reason_count[reason]
+	__entry->fc_ineligible_rc[reason]
 
 TRACE_EVENT(ext4_fc_stats,
-	    TP_PROTO(struct super_block *sb),
+	TP_PROTO(struct super_block *sb),
+
+	TP_ARGS(sb),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__array(unsigned int, fc_ineligible_rc, EXT4_FC_REASON_MAX)
+		__field(unsigned long, fc_commits)
+		__field(unsigned long, fc_ineligible_commits)
+		__field(unsigned long, fc_numblks)
+	),
 
-	    TP_ARGS(sb),
+	TP_fast_assign(
+		int i;
 
-	    TP_STRUCT__entry(
-		    __field(dev_t, dev)
-		    __field(struct ext4_sb_info *, sbi)
-		    __field(int, count)
-		    ),
-
-	    TP_fast_assign(
-		    __entry->dev = sb->s_dev;
-		    __entry->sbi = EXT4_SB(sb);
-		    ),
-
-	    TP_printk("dev %d:%d fc ineligible reasons:\n"
-		      "%s:%d, %s:%d, %s:%d, %s:%d, %s:%d, %s:%d, %s:%d, %s:%d, %s:%d; "
-		      "num_commits:%ld, ineligible: %ld, numblks: %ld",
-		      MAJOR(__entry->dev), MINOR(__entry->dev),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_XATTR),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_CROSS_RENAME),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_JOURNAL_FLAG_CHANGE),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_NOMEM),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_SWAP_BOOT),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_RESIZE),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_RENAME_DIR),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_FALLOC_RANGE),
-		      FC_REASON_NAME_STAT(EXT4_FC_REASON_INODE_JOURNAL_DATA),
-		      __entry->sbi->s_fc_stats.fc_num_commits,
-		      __entry->sbi->s_fc_stats.fc_ineligible_commits,
-		      __entry->sbi->s_fc_stats.fc_numblks)
+		__entry->dev = sb->s_dev;
+		for (i = 0; i < EXT4_FC_REASON_MAX; i++) {
+			__entry->fc_ineligible_rc[i] =
+				EXT4_SB(sb)->s_fc_stats.fc_ineligible_reason_count[i];
+		}
+		__entry->fc_commits = EXT4_SB(sb)->s_fc_stats.fc_num_commits;
+		__entry->fc_ineligible_commits =
+			EXT4_SB(sb)->s_fc_stats.fc_ineligible_commits;
+		__entry->fc_numblks = EXT4_SB(sb)->s_fc_stats.fc_numblks;
+	),
 
+	TP_printk("dev %d,%d fc ineligible reasons:\n"
+		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u "
+		  "num_commits:%lu, ineligible: %lu, numblks: %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_XATTR),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_CROSS_RENAME),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_JOURNAL_FLAG_CHANGE),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_NOMEM),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_SWAP_BOOT),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_RESIZE),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_RENAME_DIR),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_FALLOC_RANGE),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_INODE_JOURNAL_DATA),
+		  __entry->fc_commits, __entry->fc_ineligible_commits,
+		  __entry->fc_numblks)
 );
 
 #define DEFINE_TRACE_DENTRY_EVENT(__type)				\


