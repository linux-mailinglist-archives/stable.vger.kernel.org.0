Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2519644C02E
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 12:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhKJLiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 06:38:25 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41992 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhKJLiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 06:38:21 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 567991FD43;
        Wed, 10 Nov 2021 11:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636544133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6srsL7vTMG8eDCjtld9gs4O/t8JoHE+gnO+/i9FChDY=;
        b=lQIK2LYdIk/xK50a4cmJdF/JVAbtW1VIwmF6kfpcQLz6Heiv4aAqx5Pk5d0dLWuq3UlpJn
        TqjTitQmR3+HXkT0mhPQrBBLrWwEaQ4xAurmoXjeAkxnbeWccwC6wjuiYSCZqsCZTleD+c
        3VtA9tfrs8otZJiT55OEM3HPDvRXC+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636544133;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6srsL7vTMG8eDCjtld9gs4O/t8JoHE+gnO+/i9FChDY=;
        b=9b9jX5qwGRPIY5rXsVSFLvb8IjyMj6HVjSMIfZesMRnBOMoXRoTUmuNJq7p0eceQMV7L+w
        /roIvghhQ0CZ5pBA==
Received: from quack2.suse.cz (unknown [10.100.200.198])
        by relay2.suse.de (Postfix) with ESMTP id 48125A3B81;
        Wed, 10 Nov 2021 11:35:33 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 6560E1E1649; Wed, 10 Nov 2021 12:35:30 +0100 (CET)
Date:   Wed, 10 Nov 2021 12:35:30 +0100
From:   Jan Kara <jack@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        Nathan Wilson <nate@chickenbrittle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] udf: Fix crash after seekdir
Message-ID: <20211110113530.GB4048@quack2.suse.cz>
References: <20211109114841.30310-1-jack@suse.cz>
 <YYqhRmm/+XHrCgxP@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYqhRmm/+XHrCgxP@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 09-11-21 16:26:46, Matthew Wilcox wrote:
> On Tue, Nov 09, 2021 at 12:48:41PM +0100, Jan Kara wrote:
> > udf_readdir() didn't validate the directory position it should start
> > reading from. Thus when user uses lseek(2) on directory file descriptor
> > it can trick udf_readdir() into reading from a position in the middle of
> > directory entry which then upsets directory parsing code resulting in
> > errors or even possible kernel crashes. Similarly when the directory is
> > modified between two readdir calls, the directory position need not be
> > valid anymore.
> 
> ... We don't have an xfstest for this already?  Actually, two.  One for
> lseek() and one for modifying the directory as it's being read.

Good question which I also wanted to investigate. We do have generic/310
which tests the seek + readdir case (but for some reason it does not hit
any problem with udf). Also tests using fsstress can in principle hit the
readdir + dir modification case although because glibc implementation of
readdir(3) does a lot of caching (directories smaller than 32k worth of dir
entries are read in one go), hiting some problematic cornercase is rare I
guess. So I guess the coverage needs some expansion.  I'll have a look into
it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
