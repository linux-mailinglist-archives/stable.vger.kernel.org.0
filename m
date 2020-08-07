Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C6423F4B6
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 00:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgHGWCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 18:02:02 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47482 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726038AbgHGWCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 18:02:02 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 077M1l0R024214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Aug 2020 18:01:48 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 7AE6B420263; Fri,  7 Aug 2020 18:01:47 -0400 (EDT)
Date:   Fri, 7 Aug 2020 18:01:47 -0400
From:   tytso@mit.edu
To:     Lazar Beloica <lazarbeloica@gmail.com>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        lazar.beloica@nutanix.com, boyu.mt@taobao.com,
        adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix marking group trimmed if all blocks not trimmed
Message-ID: <20200807220147.GA7657@mit.edu>
References: <1596471464-198715-1-git-send-email-lazar.beloica@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596471464-198715-1-git-send-email-lazar.beloica@nutanix.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 04:17:44PM +0000, Lazar Beloica wrote:
> When FTRIM is issued on a group, ext4 marks it as trimmed so another FTRIM
> on the same group has no effect. Ext4 marks group as trimmed if at least
> one block is trimmed, therefore it is possible that a group is marked as
> trimmed even if there are blocks in that group left untrimmed.
> 
> This patch marks group as trimmed only if there are no more blocks
> in that group to be trimmed.

This patch makes no sense; first of all, the changes below are *not*
in the function ext4_trim_extent(), but rather ext4_trim_all_free().
It appears that the diff is based off of v5.8-rc2, based on the index
c0a331e, but then I'm not sure how you generated the diff?

Secondly, ext4_trim_all_free(), which is where these two patch hunks
appear:

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index c0a331e..130936b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -5346,6 +5346,7 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
>  {
>  	void *bitmap;
>  	ext4_grpblk_t next, count = 0, free_count = 0;
> +	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
>  	struct ext4_buddy e4b;
>  	int ret = 0;
>  
> @@ -5401,7 +5402,9 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
>  
>  	if (!ret) {
>  		ret = count;
> -		EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
> +		next = mb_find_next_bit(bitmap, max_blks, max + 1);
> +		if (next == max_blks)
> +			EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
>  	}
>  out:
>  	ext4_unlock_group(sb, group);

The function send discards for blocks in a block group which are
freed.  So setting max_blks to be ext4_blocks_count() and then using
it as the limit to mb_find_next_bit() makes no sense.  First of all
next will never be equal to max_blks, since next is an offset relative
to the beginning of the block group, and max_blks is set number of
blocks in the entire file system.

Secondly, mb_find_next_bit is searching a bitmap, which is a single
file system block (e.g., 4k in a 4k block file system).  So if
max_blks is the the number of blocks in (for example) a 10TB file
system, this is going to potentially cause a kernel oops.

How, exactly did you test this patch?

	     	      	 	     	   - Ted
