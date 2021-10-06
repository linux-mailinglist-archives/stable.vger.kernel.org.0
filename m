Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD324423DB9
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 14:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbhJFM3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 08:29:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57972 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbhJFM3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 08:29:41 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AA8511FEB6;
        Wed,  6 Oct 2021 12:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633523268;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A162/OPHuBbWjyH/G7i3N4n/NAJwLjc/UiHnbfmAtjY=;
        b=fbbIntASufSkoTssOH0km+FvepKdzXAgoTB57IgNV9aXvvqTvFDI4VujLzry6CBl0mMvte
        GYlV/u3z6JqgrgL4JVCblX3DPJV5ZxO+tXkRCxeK2UZSCS/lJVwepc8C05Ry6lkeEwwMeQ
        SPJf9M/t6kDY31GX4paR8wb3ScBqAao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633523268;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A162/OPHuBbWjyH/G7i3N4n/NAJwLjc/UiHnbfmAtjY=;
        b=GV5GfxpXrAKXxazYOI/G72BgeO6fPFZOyZjjwRb/VMMk1+xnRMTNjq0vto7lLHdbTWpUIN
        3aj7g3iVZNMnIhDA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id A3E6DA3B99;
        Wed,  6 Oct 2021 12:27:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 76F4ADA7F3; Wed,  6 Oct 2021 14:27:28 +0200 (CEST)
Date:   Wed, 6 Oct 2021 14:27:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: update refs for any root except tree log roots
Message-ID: <20211006122728.GO9286@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <3b6169b5a9b7bda03e14bcc7e10f8dcda5e92374.1633111027.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b6169b5a9b7bda03e14bcc7e10f8dcda5e92374.1633111027.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 01, 2021 at 01:57:18PM -0400, Josef Bacik wrote:
> I hit a stuck relocation on btrfs/061 during my overnight testing.  This
> turned out to be because we had left over extent entries in our extent
> root for a data reloc inode that no longer existed.  This happened
> because in btrfs_drop_extents() we only update refs if we have SHAREABLE
> set or we are the tree_root.  This regression was introduced by
> aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
> where we stopped setting SHAREABLE for the data reloc tree.
> 
> The problem here is we actually do want to update extent references for
> data extents in the data reloc tree, in fact we only don't want to
> update extent references if the file extents are in the log tree.
> Update this check to only skip updating references in the case of the
> log tree.
> 
> This is relatively rare, because you have to be running scrub at the
> same time, which is what btrfs/061 does.  The data reloc inode has its
> extents pre-allcated, and then we copy the extent into the pre-allocated
> chunks.  We theoretically should never be calling btrfs_drop_extents()
> on a data reloc inode.  The exception of course is with scrub, if our
> pre-allocated extent falls inside of the block group we are scrubbing,
> then the block group will be marked read only and we will be forced to
> cow that extent.  This means we will call btrfs_drop_extents() on that
> range when we cow that file extent.
> 
> This isn't really problematic if we do this, the data reloc inode
> requires that our extent lengths match exactly with the extent we are
> copying, thankfully we validate the extent is correct with
> get_new_location(), so if we happen to cow only part of the extent we
> won't link it in when we do the relocation, so we are safe from any
> other shenanigans that arise because of this interaction with scrub.
> 
> cc: stable@vger.kernel.org
> Fixes: aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
