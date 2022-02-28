Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA58A4C72D2
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiB1R3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiB1R2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:28:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15170BC0A;
        Mon, 28 Feb 2022 09:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B743CB815B1;
        Mon, 28 Feb 2022 17:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2151CC340E7;
        Mon, 28 Feb 2022 17:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069261;
        bh=917T7g5NADCLUB+jfAC4t5c2Tgf/uZE24UZy1cRKwXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmbvwY00k3UnKt3VypvttQblpINafLUjc4hggCD38JXjLhl/+bLxpKj5kyGiFh9of
         7PFWZxdoPQvb8AY8Tmi1GiFsiPNNaEr02vTWHIScXqnOD2Ttv0C3QfBGvskCbB4oGU
         v7coOtsmS+wvD1pPzTAJcO6eDtG/ePXKBHSDdoQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 21/31] tracefs: Set the group ownership in apply_options() not parse_options()
Date:   Mon, 28 Feb 2022 18:24:17 +0100
Message-Id: <20220228172201.786955916@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 851e99ebeec3f4a672bb5010cf1ece095acee447 upstream.

Al Viro brought it to my attention that the dentries may not be filled
when the parse_options() is called, causing the call to set_gid() to
possibly crash. It should only be called if parse_options() succeeds
totally anyway.

He suggested the logical place to do the update is in apply_options().

Link: https://lore.kernel.org/all/20220225165219.737025658@goodmis.org/
Link: https://lkml.kernel.org/r/20220225153426.1c4cab6b@gandalf.local.home

Cc: stable@vger.kernel.org
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: 48b27b6b5191 ("tracefs: Set all files to the same group ownership as the mount option")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -265,7 +265,6 @@ static int tracefs_parse_options(char *d
 			if (!gid_valid(gid))
 				return -EINVAL;
 			opts->gid = gid;
-			set_gid(tracefs_mount->mnt_root, gid);
 			break;
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
@@ -292,7 +291,9 @@ static int tracefs_apply_options(struct
 	inode->i_mode |= opts->mode;
 
 	inode->i_uid = opts->uid;
-	inode->i_gid = opts->gid;
+
+	/* Set all the group ids to the mount option */
+	set_gid(sb->s_root, opts->gid);
 
 	return 0;
 }


