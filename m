Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A624C4B5E
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 17:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242828AbiBYQxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 11:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243224AbiBYQwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 11:52:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D590C22322B;
        Fri, 25 Feb 2022 08:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D81661D07;
        Fri, 25 Feb 2022 16:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA770C340F4;
        Fri, 25 Feb 2022 16:52:20 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nNdpL-00B8N1-TD;
        Fri, 25 Feb 2022 11:52:19 -0500
Message-ID: <20220225165219.737025658@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 25 Feb 2022 11:52:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [for-linus][PATCH 09/13] tracefs: Set the group ownership in apply_options() not
 parse_options()
References: <20220225165151.824659113@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Al Viro brought it to my attention that the dentries may not be filled
when the parse_options() is called, causing the call to set_gid() to
possibly crash. It should only be called if parse_options() succeeds
totally anyway.

He suggested the logical place to do the update is in apply_options().

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: 48b27b6b5191 ("tracefs: Set all files to the same group ownership as the mount option")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/tracefs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index bafc02bf8220..3638d330ff5a 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -264,7 +264,6 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 			if (!gid_valid(gid))
 				return -EINVAL;
 			opts->gid = gid;
-			set_gid(tracefs_mount->mnt_root, gid);
 			break;
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
@@ -293,6 +292,9 @@ static int tracefs_apply_options(struct super_block *sb)
 	inode->i_uid = opts->uid;
 	inode->i_gid = opts->gid;
 
+	if (tracefs_mount && tracefs_mount->mnt_root)
+		set_gid(tracefs_mount->mnt_root, opts->gid);
+
 	return 0;
 }
 
-- 
2.34.1
