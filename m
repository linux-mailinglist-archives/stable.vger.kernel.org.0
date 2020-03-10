Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803AC18024D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCJPru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgCJPru (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 11:47:50 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C0320866;
        Tue, 10 Mar 2020 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583855269;
        bh=fxXBC6mLqLhF630XcKwvNoA3xYL1Mgjsv4/cnzDW8FE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=t6BwwWyfltp0cLV9XE4wIgEp201EDrtvpsCABAtdCg+fbpp7EdL6PG2iWnkxtPkQd
         Ik604FbqVyTy4wadVmpZAsXt2e7bm7XDJ3DIRBnb1ZhLVa1qlnYu0lMu71TBYTjzys
         EuahFLGqKgSz2Vm3dRqAs7NvA4Js9NZR3HqrOCFE=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id ACDAD35226CF; Tue, 10 Mar 2020 08:47:49 -0700 (PDT)
Date:   Tue, 10 Mar 2020 08:47:49 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Marco Elver' <elver@google.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] list: Prevent compiler reloads inside 'safe' list
 iteration
Message-ID: <20200310154749.GZ2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200310092119.14965-1-chris@chris-wilson.co.uk>
 <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com>
 <158384100886.16414.15741589015363013386@build.alporthouse.com>
 <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
 <20200310125031.GY2935@paulmck-ThinkPad-P72>
 <CANpmjNNT3HY7i9TywX0cAFqBtx2J3qOGOUG5nHzxAZ4bk_qgtg@mail.gmail.com>
 <77ff4da6b0a7448c947af6de4fb43cdb@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77ff4da6b0a7448c947af6de4fb43cdb@AcuMS.aculab.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 03:05:57PM +0000, David Laight wrote:
> From: Marco Elver
> > Sent: 10 March 2020 14:10
> ...
> > FWIW, for writes we're already being quite generous, in that plain
> > aligned writes up to word-size are assumed to be "atomic" with the
> > default (conservative) config, i.e. marking such writes is optional.
> > Although, that's a generous assumption that is not always guaranteed
> > to hold (https://lore.kernel.org/lkml/20190821103200.kpufwtviqhpbuv2n@willie-the-truck/).
> 
> Remind me to start writing everything in assembler.

Been there, done that.  :-/

> That and to mark all structure members 'volatile'.

Indeed.  READ_ONCE() and WRITE_ONCE() get this same effect, but without
pessimizing non-concurrent accesses to those same members.  Plus KCSAN
knows about READ_ONCE(), WRITE_ONCE(), and also volatile members.

							Thanx, Paul
