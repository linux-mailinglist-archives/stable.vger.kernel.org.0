Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D22471CC7
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 20:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhLLTqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 14:46:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50314 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhLLTqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 14:46:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1C46B80D49;
        Sun, 12 Dec 2021 19:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C16BC341C5;
        Sun, 12 Dec 2021 19:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639338402;
        bh=asMbxW6eSGt6dFEETWhAuzKkqjZvYAPwUw8vwWjRH00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nEu/qpKzRNfYv7XiBgdfOa/3HZYILnqLpPgh6pVCnaG0CONMGhthSpyU97M7wI47B
         Sao26oEbijQZOMOCynjCO1ojrKQmlY0HYzZzf8XRllDdbzKaxWHDDMcZRUfoHxrJxw
         qV7R2J7wVNN0KLloK/4FryuZhIc1Hkmf6QNJjbjWKebfUW2TSKbfRO9raSTrMD+oWy
         vBQKar/svIgT3TVpU0DT1eVwoVbuxJjkun8MQ4JtIANgIvprqMP2epkTrwE9EP4+4w
         30HGD/T0Ixqk9eayimMuB1WlX/wh7vjjLza4nXuukItUP9JgulrESVs8ylw0UAw0BH
         V90M82Scisr8g==
Date:   Sun, 12 Dec 2021 11:46:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 0/5] aio poll fixes for 5.10
Message-ID: <YbZRe5163BRzb2Vx@sol.localdomain>
References: <20211210234805.39861-1-ebiggers@kernel.org>
 <YbX/JVz768WuoiXd@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbX/JVz768WuoiXd@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 12, 2021 at 02:54:45PM +0100, Greg KH wrote:
> On Fri, Dec 10, 2021 at 03:48:00PM -0800, Eric Biggers wrote:
> > Backport the aio poll fixes to 5.10.  This resolves a conflict in
> > aio_poll_wake() in patch 4.  It's a "trivial" conflict, but I'm sending
> > this to make sure it doesn't get dropped.
> > 
> > Eric Biggers (5):
> >   wait: add wake_up_pollfree()
> >   binder: use wake_up_pollfree()
> >   signalfd: use wake_up_pollfree()
> >   aio: keep poll requests on waitqueue until completed
> >   aio: fix use-after-free due to missing POLLFREE handling
> > 
> >  drivers/android/binder.c        |  21 ++--
> >  fs/aio.c                        | 184 ++++++++++++++++++++++++++------
> >  fs/signalfd.c                   |  12 +--
> >  include/linux/wait.h            |  26 +++++
> >  include/uapi/asm-generic/poll.h |   2 +-
> >  kernel/sched/wait.c             |   7 ++
> >  6 files changed, 195 insertions(+), 57 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 
> 
> Thanks for all of the backports, much appreciated and now queued up.
> 
> greg k-h

Thanks!  Can you apply the following commit to 5.15-stable too?  I missed that
it's needed in 5.15:

	commit 4b3749865374899e115aa8c48681709b086fe6d3
	Author: Xie Yongji <xieyongji@bytedance.com>
	Date:   Mon Sep 13 19:19:28 2021 +0800

	    aio: Fix incorrect usage of eventfd_signal_allowed()
