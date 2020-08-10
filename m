Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C58324057C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 13:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJLzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 07:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHJLzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 07:55:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DC7206C3;
        Mon, 10 Aug 2020 11:55:36 +0000 (UTC)
Date:   Mon, 10 Aug 2020 13:55:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org, maco@android.com, tkjos@google.com
Subject: Re: [PATCH 4.4+4.9] binder: Prevent context manager from
 incrementing ref 0
Message-ID: <20200810115548.GA2931116@kroah.com>
References: <20200807184500.3711845-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807184500.3711845-1-jannh@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 08:45:00PM +0200, Jann Horn wrote:
> commit 4b836a1426cb0f1ef2a6e211d7e553221594f8fc upstream.
> 
> Binder is designed such that a binder_proc never has references to
> itself. If this rule is violated, memory corruption can occur when a
> process sends a transaction to itself; see e.g.
> <https://syzkaller.appspot.com/bug?extid=09e05aba06723a94d43d>.
> 
> There is a remaining edgecase through which such a transaction-to-self
> can still occur from the context of a task with BINDER_SET_CONTEXT_MGR
> access:
> 
>  - task A opens /dev/binder twice, creating binder_proc instances P1
>    and P2
>  - P1 becomes context manager
>  - P2 calls ACQUIRE on the magic handle 0, allocating index 0 in its
>    handle table
>  - P1 dies (by closing the /dev/binder fd and waiting a bit)
>  - P2 becomes context manager
>  - P2 calls ACQUIRE on the magic handle 0, allocating index 1 in its
>    handle table
>    [this triggers a warning: "binder: 1974:1974 tried to acquire
>    reference to desc 0, got 1 instead"]
>  - task B opens /dev/binder once, creating binder_proc instance P3
>  - P3 calls P2 (via magic handle 0) with (void*)1 as argument (two-way
>    transaction)
>  - P2 receives the handle and uses it to call P3 (two-way transaction)
>  - P3 calls P2 (via magic handle 0) (two-way transaction)
>  - P2 calls P2 (via handle 1) (two-way transaction)
> 
> And then, if P2 does *NOT* accept the incoming transaction work, but
> instead closes the binder fd, we get a crash.
> 
> Solve it by preventing the context manager from using ACQUIRE on ref 0.
> There shouldn't be any legitimate reason for the context manager to do
> that.
> 
> Additionally, print a warning if someone manages to find another way to
> trigger a transaction-to-self bug in the future.
> 
> Cc: stable@vger.kernel.org
> Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
> Acked-by: Todd Kjos <tkjos@google.com>
> Signed-off-by: Jann Horn <jannh@google.com>
> Reviewed-by: Martijn Coenen <maco@android.com>
> Link: https://lore.kernel.org/r/20200727120424.1627555-1-jannh@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [manual backport: remove fine-grained locking and error reporting that
>                   don't exist in <=4.9]
> Signed-off-by: Jann Horn <jannh@google.com>

Thanks for the backport, now queued up.

greg k-h
