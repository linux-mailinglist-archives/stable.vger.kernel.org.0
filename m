Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F9F113634
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 21:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfLDUN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 15:13:56 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33164 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfLDUNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 15:13:55 -0500
Received: by mail-pf1-f194.google.com with SMTP id y206so393267pfb.0
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 12:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=3zk+9EuwtP/TEcaUvDRjs2KkCq02bbfAlF0C6axszSM=;
        b=q+WjHYq9suXJovGF2YTbpLrowWIVa3JvWVGBWdIC3fOvvLwi8Vg3KTSq8hu86uXao/
         U3UDQ8Th1si54T4ix7lZj4IxsuS5xhrxjS6pFpD4tLEFeIO1fgrFCtcPjhBtLzBrFX27
         p8N5r0NVIQV0I2gON8irhceS5cNG03qVvckg2vf+CikqIjxPKm4HwV7Ok8T24QgVvLZf
         xCxRCB+epb+PyCr5pDiy+of5XngdLTlSnSDBh23amlSd87lRWQS05xfyUfFR7wfqIoor
         Aywpe5XdSitlp94rGqCjWT3rz1zImJoqOvrfyMnOFqLtdxXKuU6echXXWgZYQHtc8xry
         Ow9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=3zk+9EuwtP/TEcaUvDRjs2KkCq02bbfAlF0C6axszSM=;
        b=VfqfSH0Q1L4+G0W7OgS3RZhCJY08FdoFqfeGzhlKjh2cjhaGSlO+J6QGpNaqqwIldx
         r3jUviW1tqTYnzKftb359HuJ21jLBRcZ6nmFhR3ZzOg+ho7h4vakNvvhE9sEVPsSQFWS
         Z5s6HGknnKjyVAt8AfRfoZ1DDz/sScxh5kNysRGgXRAhy6Yv77v8uCN+j4MYoCs9fAZB
         gSJ+h5fxJi3fjvBrJpT/ayD/BlmKsTXdCKNgD+dwyjEoRVzBovbX+7nEkOws6FbMEvjs
         WG+p1PZSCtSJPyVNvI4cD7g2ROVX+0EQkqkRliyF71KqFzSHNTHBWoWsViiElePRn27x
         E3Wg==
X-Gm-Message-State: APjAAAUBNEI9+y1iFYghjSwBJ5M+w7kQpRqZo/GF5OP3dnpEchQko5D3
        /pdMec4Un+eat1eBZY03ouFjFA==
X-Google-Smtp-Source: APXvYqwS0q4freIZSFyAYcPlXL+3H53J78M1iu94UUoLPbF6q2dXfDVAEbOEQmxnyMgHW51awIoVnw==
X-Received: by 2002:a63:6e0e:: with SMTP id j14mr5298446pgc.361.1575490434655;
        Wed, 04 Dec 2019 12:13:54 -0800 (PST)
Received: from [100.112.92.218] ([104.133.9.106])
        by smtp.gmail.com with ESMTPSA id u26sm8507528pfn.46.2019.12.04.12.13.53
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Dec 2019 12:13:54 -0800 (PST)
Date:   Wed, 4 Dec 2019 12:13:39 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     yu kuai <yukuai3@huawei.com>, stable@vger.kernel.org,
        hughd@google.com, viro@zeniv.linux.org.uk, yi.zhang@huawei.com,
        zhengbin13@huawei.com, houtao1@huawei.com
Subject: Re: [4.19.y PATCH] tmpfs: fix unable to remount nr_inodes from
 limited to unlimited
In-Reply-To: <20191204173334.GB3630950@kroah.com>
Message-ID: <alpine.LSU.2.11.1912041142060.1591@eggly.anvils>
References: <20191204131137.10388-1-yukuai3@huawei.com> <20191204173334.GB3630950@kroah.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Dec 2019, Greg KH wrote:
> On Wed, Dec 04, 2019 at 09:11:37PM +0800, yu kuai wrote:
> > tmpfs support 'size', 'nr_blocks' and 'nr_inodes' mount options. mount or
> > remount them to zero means unlimited. 'size' and 'br_blocks' can remount
> > from limited to unlimited, while 'nr_inodes' can't.
> > 
> > The problem is fixed since upstream commit 0b5071dd323d ("
> > shmem_parse_options(): use a separate structure to keep the results"). But
> > in order to backport it, the amount of related patches need to backport is
> > huge. 
> > 
> > So, I made some local changes to fix the problem.
> > 
> > Signed-off-by: yu kuai <yukuai3@huawei.com>
> > ---
> >  mm/shmem.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 3c8742655756..966fc69ee8fb 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -3444,7 +3444,7 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
> >  	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
> >  	if (percpu_counter_compare(&sbinfo->used_blocks, config.max_blocks) > 0)
> >  		goto out;
> > -	if (config.max_inodes < inodes)
> > +	if (config.max_inodes && config.max_inodes < inodes)
> >  		goto out;
> >  	/*
> >  	 * Those tests disallow limited->unlimited while any are in use;
> > @@ -3460,7 +3460,10 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
> >  	sbinfo->huge = config.huge;
> >  	sbinfo->max_blocks  = config.max_blocks;
> >  	sbinfo->max_inodes  = config.max_inodes;
> > -	sbinfo->free_inodes = config.max_inodes - inodes;
> > +	if (!config.max_inodes)
> > +		sbinfo->free_inodes = 0;
> > +	else
> > +		sbinfo->free_inodes = config.max_inodes - inodes;
> >  
> >  	/*
> >  	 * Preserve previous mempolicy unless mpol remount option was specified.
> > -- 
> > 2.17.2
> > 
> 
> Hm, sorry about my bot, this looked like an odd one-off patch.
> 
> What about 5.3.y, should this patch also go there as well?
> 
> But is it really an issue as this is a new "feature" that 5.4 now has,
> can't you just use 5.4.y if you need this type of thing?  It's never
> worked in the past, right?

Yes, please ignore this for stable, Greg: it appears to be a new feature
in 5.4: one that I should have noticed when testing, but failed to do so
(and it may even be something that I foisted unthinkingly on Al when
suggesting mods to his and David's originals).

Yu Kuai: many thanks for noticing and reporting this, I was unconscious
of changing behavior here.  Notice how the 5.4 shmem_reconfigure() still
has a comment above it saying "we disallow change from limited->unlimited
blocks/inodes while any are in use" - and root inode is always in use.
Notice how your 4.19 patch does nothing for max_blocks, so remounting
with nr_blocks=0 will still fail, once a non-empty file has been created.

I agree that it's not obvious why limited->unlimited needs to fail,
and perhaps a nice (worthwhile?) little enhancement to allow that;
but it was unintentional, and now (but not today) I have to go back
to remind myself why 2.6.13 implemented it with that restriction,
and whether there are any fixes needed to the new behavior in 5.4
(at the least, we ought to fix that comment in 5.5).

Hugh
