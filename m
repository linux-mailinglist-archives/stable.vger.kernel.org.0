Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A6D4C4BAC
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 18:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiBYRLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 12:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbiBYRLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 12:11:37 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B922028A6;
        Fri, 25 Feb 2022 09:11:01 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNe7Q-004ugA-NP; Fri, 25 Feb 2022 17:11:00 +0000
Date:   Fri, 25 Feb 2022 17:11:00 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [for-linus][PATCH 09/13] tracefs: Set the group ownership in
 apply_options() not parse_options()
Message-ID: <YhkNpNpnWD0YM/2J@zeniv-ca.linux.org.uk>
References: <20220225165151.824659113@goodmis.org>
 <20220225165219.737025658@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225165219.737025658@goodmis.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 11:52:00AM -0500, Steven Rostedt wrote:

> @@ -293,6 +292,9 @@ static int tracefs_apply_options(struct super_block *sb)
>  	inode->i_uid = opts->uid;
>  	inode->i_gid = opts->gid;
>  
> +	if (tracefs_mount && tracefs_mount->mnt_root)
> +		set_gid(tracefs_mount->mnt_root, opts->gid);
> +

Umm...  Why bother with tracefs_mount here in the first place?
You have the superblock the operation is applied for - right in the
arguments.

Just make that
	set_gid(sb->s_root, opts->gid);
and be done with that.  Same place in tracefs_apply_options()...

Incidentally, I'm not sure you need to keep ->i_gid assignment - set_gid()
won't miss that inode, so...
