Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA0254249D
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379457AbiFHBO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843611AbiFHALO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:11:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0EB261456;
        Tue,  7 Jun 2022 12:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0741F61958;
        Tue,  7 Jun 2022 19:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C19C3411F;
        Tue,  7 Jun 2022 19:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629568;
        bh=bKUN2+E+Dv8ATPBTdx9gpcnZRoVDzAKDm0kb339TEzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBct09irEMnJGWMEgPd+j481/6JLX+8iZuqzSawojLt/Qwho2uhyn68GhzybtdJz0
         ek9YOSU4C6zsvgFNP8yhCq8ftghSp2IcDYxvNz9PyqotYqeJUiFLbqe4ZRsVVh7Ing
         UQeIyTA15fpzJfNISubKvl4QcI22S2lycSvfaVQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.18 738/879] ext4: fix journal_ioprio mount option handling
Date:   Tue,  7 Jun 2022 19:04:16 +0200
Message-Id: <20220607165024.277088287@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit e4e58e5df309d695799c494958962100a4c25039 upstream.

In __ext4_super() we always overwrote the user specified journal_ioprio
value with a default value, expecting parse_apply_sb_mount_options() to
later correctly set ctx->journal_ioprio to the user specified value.
However, if parse_apply_sb_mount_options() returned early because of
empty sbi->es_s->s_mount_opts, the correct journal_ioprio value was
never set.

This patch fixes __ext4_super() to only use the default value if the
user has not specified any value for journal_ioprio.

Similarly, the remount behavior was to either use journal_ioprio
value specified during initial mount, or use the default value
irrespective of the journal_ioprio value specified during remount.
This patch modifies this to first check if a new value for ioprio
has been passed during remount and apply it.  If no new value is
passed, use the value specified during initial mount.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Tested-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20220418083545.45778-1-ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4410,7 +4410,8 @@ static int __ext4_fill_super(struct fs_c
 	int silent = fc->sb_flags & SB_SILENT;
 
 	/* Set defaults for the variables that will be set during parsing */
-	ctx->journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
+	if (!(ctx->spec & EXT4_SPEC_JOURNAL_IOPRIO))
+		ctx->journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 
 	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
 	sbi->s_sectors_written_start =
@@ -6277,7 +6278,6 @@ static int __ext4_remount(struct fs_cont
 	char *to_free[EXT4_MAXQUOTAS];
 #endif
 
-	ctx->journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 
 	/* Store the original options */
 	old_sb_flags = sb->s_flags;
@@ -6303,9 +6303,14 @@ static int __ext4_remount(struct fs_cont
 		} else
 			old_opts.s_qf_names[i] = NULL;
 #endif
-	if (sbi->s_journal && sbi->s_journal->j_task->io_context)
-		ctx->journal_ioprio =
-			sbi->s_journal->j_task->io_context->ioprio;
+	if (!(ctx->spec & EXT4_SPEC_JOURNAL_IOPRIO)) {
+		if (sbi->s_journal && sbi->s_journal->j_task->io_context)
+			ctx->journal_ioprio =
+				sbi->s_journal->j_task->io_context->ioprio;
+		else
+			ctx->journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
+
+	}
 
 	ext4_apply_options(fc, sb);
 


