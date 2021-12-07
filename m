Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8175E46C361
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 20:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbhLGTPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 14:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhLGTP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 14:15:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580C7C061574;
        Tue,  7 Dec 2021 11:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA18AB81E4B;
        Tue,  7 Dec 2021 19:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12821C341C3;
        Tue,  7 Dec 2021 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638904316;
        bh=EOV0HlHQu40AHhd+/98DsU8v8eJSq+kbdStFu2m6m0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jdJ3PgkFTR00tXFzoVBpukMC5X5SSYQJX8AHW9QSnRyWqYmgdYhZtEs51UKJeyUoy
         Xl5e1jLG/0+pAhNmQv3W6cJRv9xAKWIpFroNoWyDNyB3CaQJlUTb2MPgnbvY3tCtRM
         0ExyYMcyO4gIM9u7C3oucCP0IYhLaHuQos7sXmUHib8WuHzMcQ11lW0NZnr7C457eR
         EUX0Kw8Bx3aVLQrNQmPhQjkueDb0zZK/sOiOeCz8MBVPj2TGgw7kCR7gtQsVWojzXH
         35lZ1mY2U4vF6iTXL29gTOKovD5sVoy/vr9MmmJ2p4ETxDQtHN710UfI+d7Cx43elv
         AmXgLZzUNbtPA==
Date:   Tue, 7 Dec 2021 11:11:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/5] binder: use wake_up_pollfree()
Message-ID: <Ya+x+p3YR1PtbD7O@sol.localdomain>
References: <20211207095726.169766-1-ebiggers@kernel.org>
 <20211207095726.169766-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207095726.169766-3-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 01:57:23AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> wake_up_poll() uses nr_exclusive=1, so it's not guaranteed to wake up
> all non-exclusive waiters.  Yet, POLLFREE *must* wake up all waiters.

This is supposed to say "all exclusive waiters".  Same in patch 3.

- Eric
