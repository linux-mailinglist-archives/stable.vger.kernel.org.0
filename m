Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925B54C4BE2
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 18:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243547AbiBYRSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 12:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiBYRSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 12:18:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E9548E53;
        Fri, 25 Feb 2022 09:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59DE2B832AF;
        Fri, 25 Feb 2022 17:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBF5C340E7;
        Fri, 25 Feb 2022 17:18:05 +0000 (UTC)
Date:   Fri, 25 Feb 2022 12:18:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [for-linus][PATCH 09/13] tracefs: Set the group ownership in
 apply_options() not parse_options()
Message-ID: <20220225121804.535d300b@gandalf.local.home>
In-Reply-To: <YhkNpNpnWD0YM/2J@zeniv-ca.linux.org.uk>
References: <20220225165151.824659113@goodmis.org>
        <20220225165219.737025658@goodmis.org>
        <YhkNpNpnWD0YM/2J@zeniv-ca.linux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Feb 2022 17:11:00 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Fri, Feb 25, 2022 at 11:52:00AM -0500, Steven Rostedt wrote:
> 
> > @@ -293,6 +292,9 @@ static int tracefs_apply_options(struct super_block *sb)
> >  	inode->i_uid = opts->uid;
> >  	inode->i_gid = opts->gid;
> >  
> > +	if (tracefs_mount && tracefs_mount->mnt_root)
> > +		set_gid(tracefs_mount->mnt_root, opts->gid);
> > +  
> 
> Umm...  Why bother with tracefs_mount here in the first place?
> You have the superblock the operation is applied for - right in the
> arguments.

Ah, because I didn't realize they were one and the same ;-)

> 
> Just make that
> 	set_gid(sb->s_root, opts->gid);
> and be done with that.  Same place in tracefs_apply_options()...
> 
> Incidentally, I'm not sure you need to keep ->i_gid assignment - set_gid()
> won't miss that inode, so...

Makes sense. Thanks.

I guess I wont be sending my pull request to Linus now :-/

-- Steve

