Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A55F45ACD3
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 20:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239567AbhKWTxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 14:53:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232735AbhKWTxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 14:53:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2A3C60F45;
        Tue, 23 Nov 2021 19:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637696996;
        bh=ssffmWy9JtYFUpADiyNa7TiRUR5UVxOfPmHgUAdzls4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCT77HuqUzfHVld/Yd0cAYpR2SD36MlJx4N3z1uMi0wkPk4yzfwtdRos7SImlfk1/
         sGol0jpKWMYvw+wtyC4a2Y89it7BkAKs1L+zYV82wQQ46olqUsArNgL1sDLHqgk3rJ
         gAPdBOLrl6w2bAd9IE3wK56drx/GlXXt7ZUFu9XBzNuRiSBrcgmj8OX1jKAGkm07CR
         nYp1atrG2K8paaDz5T+ApUWS1LiKePBECViLT0VivGZJ21ecMozFQ1rF7ExgMDcu8j
         Xi/yDnDOBeEdoC4Mdc+JnTzbzA9L3wiNEtfQdLkbgJF5jhcc+qBkXWon9qRaLjvMW0
         PQAhbIHk82HOQ==
Date:   Tue, 23 Nov 2021 11:49:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Ramji Jiyani <ramjiyani@google.com>, arnd@arndb.de, hch@lst.de,
        kernel-team@android.com, linux-aio@kvack.org,
        linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] aio: Add support for the POLLFREE
Message-ID: <YZ1F4qmBJ42VpZp3@gmail.com>
References: <20211027011834.2497484-1-ramjiyani@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027011834.2497484-1-ramjiyani@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 01:18:34AM +0000, Ramji Jiyani wrote:
> Add support for the POLLFREE flag to force complete iocb inline in
> aio_poll_wake(). A thread may use it to signal it's exit and/or request
> to cleanup while pending poll request. In this case, aio_poll_wake()
> needs to make sure it doesn't keep any reference to the queue entry
> before returning from wake to avoid possible use after free via
> poll_cancel() path.
> 
> UAF issue was found during binder and aio interactions in certain
> sequence of events [1].
> 
> The POLLFREE flag is no more exclusive to the epoll and is being
> shared with the aio. Remove comment from poll.h to avoid confusion.
> 
> [1] https://lore.kernel.org/r/CAKUd0B_TCXRY4h1hTztfwWbNSFQqsudDLn2S_28csgWZmZAG3Q@mail.gmail.com/
> 
> Fixes: af5c72b1fc7a ("Fix aio_poll() races")
> Signed-off-by: Ramji Jiyani <ramjiyani@google.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org # 4.19+
> ---

Looks good, feel free to add:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

I'm still not 100% happy with the commit message, but it's good enough.
The actual code looks correct.

Who is going to take this patch?  This is an important fix; it shouldn't be
sitting ignored for months.  get_maintainer.pl shows:

$ ./scripts/get_maintainer.pl fs/aio.c
Benjamin LaHaise <bcrl@kvack.org> (supporter:AIO)
Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS and infrastructure))
linux-aio@kvack.org (open list:AIO)
linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure))
linux-kernel@vger.kernel.org (open list)

- Eric
