Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C8440CEAA
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 23:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhIOVQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 17:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhIOVQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 17:16:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E9A60FBF;
        Wed, 15 Sep 2021 21:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631740507;
        bh=v7eGTkfRn/2Whx56GpAI3P7Hwmk4UsoQj1ldMoGBMGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYIgJxCQN5JSa085+FL+lmnDjYLO/EhgmTtrkxWwETWkSWFHBJrMcnNouWM9/VtEU
         +Bjxptd8alSPi+yW4KrTPTb/CJe7PCsSEMO+TUulV46HPh2AWUD7/XayeQBVDYTdbu
         WfDvg4Ffmh/ybCPN5Z5FcfB3xZGl60+8JIqtsN/Kw4g00iMF2dJ6aUzW/8mD+l3hzl
         z2ZzNEVe1DGT2VwBxceWIrpcsfAokyPc+CiSRLXuUt6l/TyAS/nwG+z/wHAaG2aSsU
         E4hiCmylQnqBncgKM8B1Pq/RsWHM7Vg7pBZEPELLMscRnG3ryVOtVq/HBnQdU57sUN
         7SrumwVxJoHcQ==
Date:   Wed, 15 Sep 2021 23:15:04 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Alan J. Wylie" <alan@wylie.me.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Regression in posix-cpu-timers.c (was Re: Linux 5.14.4)
Message-ID: <20210915211504.GB22415@lothringen>
References: <1631693373201133@kroah.com>
 <87ilz1pwaq.fsf@wylie.me.uk>
 <20210915183152.GA22415@lothringen>
 <CAHk-=wgiiqmy1jE0i9EYkCiE+KNHDTJQVktczZgyJwqL-okRgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgiiqmy1jE0i9EYkCiE+KNHDTJQVktczZgyJwqL-okRgA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 11:41:42AM -0700, Linus Torvalds wrote:
> On Wed, Sep 15, 2021 at 11:31 AM Frederic Weisbecker
> <frederic@kernel.org> wrote:
> >
> > Right, this should fix the issue: https://lore.kernel.org/lkml/20210913145332.232023-1-frederic@kernel.org/
> 
> Hmm.
> 
> Can you explain why the fix isn't just to revert that original commit?
> 
> It looks like the only real difference is that now it does *extra
> work* with all that tick_nohz_dep_set_signal().
> 
> Isn't it easier to just leave any old timer ticking, and not do the
> extra work until it expires and you notice "ok, it's not important"?
> 
> IOW, that original commit explicitly broke the only case it changed -
> the timer being disabled.  So why isn't it just reverted? What is it
> that kleeps us wanting to do the extra work for the disabled timer
> case?
> 
> As long as it's fixed, I'm all ok with this, but I'm looking at the
> commit message for that broken commit, and I'm looking at the commit
> message for the fix, and I'm not seeing an actual _explanation_ for
> this churn.

The commit indeed failed to explain correctly the actual issue.

When a process wide posix cpu timer (eg: itimer) is elapsing, all the
threads inside that process contend on their cputime updates
(account_group_user_time() and account_group_system_time())


The overhead just consists in concurrent atomic64_add() calls on
every tick but still... And this can remain for a very long while,
until the previous value of the timer expiry is reached.

The other symptom, more of a corner case for most, is that the CPUs
running any thread of that process won't be able to enter in nohz_full
mode, again until the old timer expiry is reached.
