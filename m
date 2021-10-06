Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3794E4248AD
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 23:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbhJFVRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 17:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239547AbhJFVRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 17:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7806C61177;
        Wed,  6 Oct 2021 21:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633554961;
        bh=d1ydGKbgRYte60NsablLkoqw6nuD33vqUg6Hkbz6qPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6JKHo3UfDf6EZN08ID/hzvMfVpdeMhuAATIxAjhNlUqzum3FYaguWM8rxAtSJxBz
         crakWpnqKAxcAZgSutghrkrgXMIwLm1WRkYINRF5O+fT4mNlkyKLALKJph2DxnUzKx
         B4wgXypWer67HUFEnjJOvpz/vTMjrHDLsWVg9l/j3PkHrMzcc9ReVlT33wfrx64LCm
         bnnxPi18Fm+/T5U+32bBl3o/TRaiAqnYhZ/Sv2pLW07RS5LcSdcAZ601xaunFOoXWy
         pAal9ieo1d+IjeBwATlscnHfcndsZk9U96A54wjGnowldvGRHNv4U/sUseyeh2T9LR
         CCBkaBrOXAhhg==
Date:   Wed, 6 Oct 2021 14:16:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ramji Jiyani <ramjiyani@google.com>
Cc:     arnd@arndb.de, viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@lst.de,
        kernel-team@android.com, linux-aio@kvack.org,
        linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        oleg@redhat.com, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] aio: Add support for the POLLFREE
Message-ID: <YV4SELcjE7EfBiLI@gmail.com>
References: <20211006195029.532034-1-ramjiyani@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006195029.532034-1-ramjiyani@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 07:50:29PM +0000, Ramji Jiyani wrote:
> Commit f5cb779ba163 ("ANDROID: binder: remove waitqueue when thread
> exits.") fixed the use-after-free in eventpoll but aio still has the
> same issue because it doesn't honor the POLLFREE flag.
> 
> Add support for the POLLFREE flag to force complete iocb inline in
> aio_poll_wake(). A thread may use it to signal it's exit and/or request
> to cleanup while pending poll request. In this case, aio_poll_wake()
> needs to make sure it doesn't keep any reference to the queue entry
> before returning from wake to avoid possible use after free via
> poll_cancel() path.
> 
> The POLLFREE flag is no more exclusive to the epoll and is being
> shared with the aio. Remove comment from poll.h to avoid confusion.
> 
> This fixes a use after free issue between binder thread and aio
> interactions in certain sequence of events [1].
> 
> [1] https://lore.kernel.org/all/CAKUd0B_TCXRY4h1hTztfwWbNSFQqsudDLn2S_28csgWZmZAG3Q@mail.gmail.com/
> 
> Signed-off-by: Ramji Jiyani <ramjiyani@google.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Can you add Fixes and Cc stable tags to ensure that this fix gets backported?
Please refer to Documentation/process/submitting-patches.rst.

- Eric
