Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AC24C76F3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiB1SKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbiB1SHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:07:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B725C860;
        Mon, 28 Feb 2022 09:48:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD26ECE17E0;
        Mon, 28 Feb 2022 17:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF72C340E7;
        Mon, 28 Feb 2022 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070486;
        bh=2PUzstzbc4uQGtrmaIFCYCO0Mwn0zemi4VU9SaGRTc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnsk3L+a1gvrDOOfSy+wk1Seswo53ph9C1ImxYAybxbG0h75pE0wjtZVJBqUkBg1C
         OVLmZ3DwsLjdqavpOw+7hD6Ynhke/sE1TWjN1hrDgn0ffLZ1G6i+Vk6zEIMlm7cfeg
         +LAESh20qStKDJm0ceOnWt14XiQQbvxJM9ulqdcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.16 126/164] tracefs: Set the group ownership in apply_options() not parse_options()
Date:   Mon, 28 Feb 2022 18:24:48 +0100
Message-Id: <20220228172411.580687405@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
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
@@ -264,7 +264,6 @@ static int tracefs_parse_options(char *d
 			if (!gid_valid(gid))
 				return -EINVAL;
 			opts->gid = gid;
-			set_gid(tracefs_mount->mnt_root, gid);
 			break;
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
@@ -291,7 +290,9 @@ static int tracefs_apply_options(struct
 	inode->i_mode |= opts->mode;
 
 	inode->i_uid = opts->uid;
-	inode->i_gid = opts->gid;
+
+	/* Set all the group ids to the mount option */
+	set_gid(sb->s_root, opts->gid);
 
 	return 0;
 }


