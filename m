Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F153015CCC9
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 22:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgBMVB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 16:01:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:42708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgBMVBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 16:01:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 18BC8ADE4;
        Thu, 13 Feb 2020 21:01:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CAE2BDA703; Thu, 13 Feb 2020 22:01:09 +0100 (CET)
Date:   Thu, 13 Feb 2020 22:01:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 089/116] btrfs: flush write bio if we loop in
 extent_write_cache_pages
Message-ID: <20200213210109.GS2902@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
References: <20200213151842.259660170@linuxfoundation.org>
 <20200213151917.511897953@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151917.511897953@linuxfoundation.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:20:33AM -0800, Greg Kroah-Hartman wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> [ Upstream commit 96bf313ecb33567af4cb53928b0c951254a02759 ]

This commit does not exist in my tree, the correct upstream commit of
the backported patch should be 42ffb0bf584ae5b6b38f72259af1e0ee417ac77f.

> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4060,6 +4060,14 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
>  		 */
>  		scanned = 1;
>  		index = 0;
> +
> +		/*
> +		 * If we're looping we could run into a page that is locked by a
> +		 * writer and that writer could be waiting on writeback for a
> +		 * page in our current bio, and thus deadlock, so flush the
> +		 * write bio here.
> +		 */
> +		flush_write_bio(data);

This has been modified to apply, flush_write_bio does not return a value
in 4.9, perhaps this led to the different commit id.
