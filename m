Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C654182727
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 03:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387501AbgCLC6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 22:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387396AbgCLC6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 22:58:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAB4920755;
        Thu, 12 Mar 2020 02:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583981891;
        bh=wJdKQS6Gj9xiXn1BGxhMdcyOYuYKUt5sQjTbx3jinXE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K8pZg/PKbre08qAnpKHYtRQEa3Y8eHQgSJ3fgLwtnqltex4FaiU8ZEIREHiNxjpb9
         qxfNUXGPXjA4gqUzprHjQcLRywJGzvrNEi9TTFQuebfkJWWooV/O8sPMetTVryirIh
         b+RYwrkYLKzVIQ3DjUV5cnyC5qOPAdbW/iiKlw60=
Date:   Wed, 11 Mar 2020 19:58:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     paulmck@kernel.org
Cc:     David Laight <David.Laight@ACULAB.COM>,
        "'Marco Elver'" <elver@google.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] list: Prevent compiler reloads inside 'safe' list
 iteration
Message-Id: <20200311195810.959d4f40d6013ee59a238cf3@linux-foundation.org>
In-Reply-To: <20200310154749.GZ2935@paulmck-ThinkPad-P72>
References: <20200310092119.14965-1-chris@chris-wilson.co.uk>
        <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com>
        <158384100886.16414.15741589015363013386@build.alporthouse.com>
        <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
        <20200310125031.GY2935@paulmck-ThinkPad-P72>
        <CANpmjNNT3HY7i9TywX0cAFqBtx2J3qOGOUG5nHzxAZ4bk_qgtg@mail.gmail.com>
        <77ff4da6b0a7448c947af6de4fb43cdb@AcuMS.aculab.com>
        <20200310154749.GZ2935@paulmck-ThinkPad-P72>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Mar 2020 08:47:49 -0700 "Paul E. McKenney" <paulmck@kernel.org> wrote:

> On Tue, Mar 10, 2020 at 03:05:57PM +0000, David Laight wrote:
> > From: Marco Elver
> > > Sent: 10 March 2020 14:10
> > ...
> > > FWIW, for writes we're already being quite generous, in that plain
> > > aligned writes up to word-size are assumed to be "atomic" with the
> > > default (conservative) config, i.e. marking such writes is optional.
> > > Although, that's a generous assumption that is not always guaranteed
> > > to hold (https://lore.kernel.org/lkml/20190821103200.kpufwtviqhpbuv2n@willie-the-truck/).
> > 
> > Remind me to start writing everything in assembler.
> 
> Been there, done that.  :-/
> 
> > That and to mark all structure members 'volatile'.
> 
> Indeed.  READ_ONCE() and WRITE_ONCE() get this same effect, but without
> pessimizing non-concurrent accesses to those same members.  Plus KCSAN
> knows about READ_ONCE(), WRITE_ONCE(), and also volatile members.
> 

So I take it from all the above that we should do this.

Did anyone actually review the code? :)
