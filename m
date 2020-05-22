Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CF31DDDE4
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 05:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgEVDek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 23:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgEVDek (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 23:34:40 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C4320748;
        Fri, 22 May 2020 03:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590118480;
        bh=JBPLaWjo53DhA9B9DI56M80/v3fmf+CtbFIZ45maUg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UFBMKCoQiGKuc51QZHKu/7VNHcoKthXg1Ww5qXA76VKl1HRbLZnvL3Ll1rTsOQTWs
         RvmQLpyMt8oDQtE4XRBye29lIdrjqXS/vN1/h2pDXgiqybkAxtza+91teEdcz8yyRs
         n+UDWA8p5cf1830R/Hl/SVYWa6UPrqtG0tvNEwWU=
Date:   Thu, 21 May 2020 20:34:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix race between ext4_sync_parent() and rename()
Message-ID: <20200522033437.GA895@sol.localdomain>
References: <20200506183140.541194-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506183140.541194-1-ebiggers@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 06, 2020 at 11:31:40AM -0700, Eric Biggers wrote:
>  		/*
>  		 * The directory inode may have gone through rmdir by now. But
>  		 * the inode itself and its blocks are still allocated (we hold
> -		 * a reference to the inode so it didn't go through
> -		 * ext4_evict_inode()) and so we are safe to flush metadata
> -		 * blocks and the inode.
> +		 * a reference to the inode via its dentry), so it didn't go
> +		 * through ext4_evict_inode()) and so we are safe to flush
> +		 * metadata blocks and the inode.
>  		 */
>  		ret = sync_mapping_buffers(inode->i_mapping);

Just realized that in this comment, the closing parenthesis I added after
"dentry" shouldn't be there.  Ted, feel free to fix this if you're so inclined.

- Eric
