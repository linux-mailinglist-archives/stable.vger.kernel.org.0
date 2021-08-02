Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FE83DD4BA
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 13:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhHBLhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 07:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233255AbhHBLhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 07:37:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 252D060F4B;
        Mon,  2 Aug 2021 11:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627904247;
        bh=aIODNLyimMurh3rZSZ3kal7It5jhD1KsNeQcM7A8pJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DWPPnVO4xhpesVVzXsmwc0Vwq8ENEox2IuHMCOkeTAzhLGVx7OExk+vBMbbo+mBsM
         Y5D5H/AvnH6EmdHYcag92b9BQlp76qeTyuhLFJfTeba4inTQHRuaVJYw1Co0gN14M0
         GnfI8ewQ5ZyOy37VEf8bzlp16+RSPbPJVZCw4hxo=
Date:   Mon, 2 Aug 2021 13:37:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     forza@tnonline.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: fix race in unified task_work
 running" failed to apply to 5.13-stable tree
Message-ID: <YQfY9Uh0wfIWqwcE@kroah.com>
References: <162771380065153@kroah.com>
 <e3a7acb2-41ad-8c7b-c3d2-8f8d5b40f250@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3a7acb2-41ad-8c7b-c3d2-8f8d5b40f250@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 31, 2021 at 08:44:33AM -0600, Jens Axboe wrote:
> On 7/31/21 12:43 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.13-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's a tested 5.13-stable port.
> 
> From: Jens Axboe <axboe@kernel.dk>
> Subject: io_uring: fix race in unified task_work running
> 
> commit 110aa25c3ce417a44e35990cf8ed22383277933a upstream.
> 
> We use a bit to manage if we need to add the shared task_work, but
> a list + lock for the pending work. Before aborting a current run
> of the task_work we check if the list is empty, but we do so without
> grabbing the lock that protects it. This can lead to races where
> we think we have nothing left to run, where in practice we could be
> racing with a task adding new work to the list. If we do hit that
> race condition, we could be left with work items that need processing,
> but the shared task_work is not active.
> 
> Ensure that we grab the lock before checking if the list is empty,
> so we know if it's safe to exit the run or not.
> 
> Link: https://lore.kernel.org/io-uring/c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net/
> Cc: stable@vger.kernel.org # 5.11+
> Reported-by: Forza <forza@tnonline.net>
> Tested-by: Forza <forza@tnonline.net>

Now queued up, thanks!

greg k-h
