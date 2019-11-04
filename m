Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB33EE916
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 20:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfKDT72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 14:59:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:48400 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728556AbfKDT71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 14:59:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 329B6AFE3;
        Mon,  4 Nov 2019 19:59:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 28F86DB6FC; Mon,  4 Nov 2019 20:59:33 +0100 (CET)
Date:   Mon, 4 Nov 2019 20:59:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: save i_size in compress_file_range
Message-ID: <20191104195933.GG3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <20191011130354.8232-1-josef@toxicpanda.com>
 <20191023165102.GC3001@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023165102.GC3001@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 06:51:02PM +0200, David Sterba wrote:
> On Fri, Oct 11, 2019 at 09:03:54AM -0400, Josef Bacik wrote:
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -474,6 +474,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
> >  	u64 start = async_chunk->start;
> >  	u64 end = async_chunk->end;
> >  	u64 actual_end;
> > +	loff_t i_size = i_size_read(inode);
> >  	int ret = 0;
> >  	struct page **pages = NULL;
> >  	unsigned long nr_pages;
> > @@ -488,7 +489,13 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
> >  	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
> >  			SZ_16K);
> >  
> > -	actual_end = min_t(u64, i_size_read(inode), end + 1);
> > +	/*
> > +	 * We need to save i_size before now because it could change in between
> > +	 * us evaluating the size and assigning it.  This is because we lock and
> > +	 * unlock the page in truncate and fallocate, and then modify the i_size
> > +	 * later on.
> > +	 */
> > +	actual_end = min_t(u64, i_size, end + 1);
> 
> Ping. This is not a future proof fix, please update the changelog and
> code according to the reply I sent.

The vfs i_size_read patch is being ignored so I guess we're on our own.
I have postponed last weeks pull request so I'll add this patch on top
and send in a day or two. The READ_ONCE will be simulated by barrier()s,
I've verified the assembly and actually that's alwo what read once does
among other things.
