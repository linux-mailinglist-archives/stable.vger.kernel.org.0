Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CE117F6B1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgCJLuP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 10 Mar 2020 07:50:15 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:53369 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726211AbgCJLuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 07:50:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20507742-1500050 
        for multiple; Tue, 10 Mar 2020 11:50:09 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com>
References: <20200310092119.14965-1-chris@chris-wilson.co.uk> <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] list: Prevent compiler reloads inside 'safe' list iteration
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <158384100886.16414.15741589015363013386@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 10 Mar 2020 11:50:08 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting David Laight (2020-03-10 11:36:41)
> From: Chris Wilson
> > Sent: 10 March 2020 09:21
> > Instruct the compiler to read the next element in the list iteration
> > once, and that it is not allowed to reload the value from the stale
> > element later. This is important as during the course of the safe
> > iteration, the stale element may be poisoned (unbeknownst to the
> > compiler).
> 
> Eh?
> I thought any function call will stop the compiler being allowed
> to reload the value.
> The 'safe' loop iterators are only 'safe' against called
> code removing the current item from the list.
> 
> > This helps prevent kcsan warnings over 'unsafe' conduct in releasing the
> > list elements during list_for_each_entry_safe() and friends.
> 
> Sounds like kcsan is buggy ????

The warning kcsan gave made sense (a strange case where the emptying the
list from inside the safe iterator would allow that list to be taken
under a global mutex and have one extra request added to it. The
list_for_each_entry_safe() should be ok in this scenario, so long as the
next element is read before this element is dropped, and the compiler is
instructed not to reload the element. kcsan is a little more insistent
on having that annotation :)

In this instance I would say it was a false positive from kcsan, but I
can see why it would complain and suspect that given a sufficiently
aggressive compiler, we may be caught out by a late reload of the next
element.

That's my conjecture, but I leave it to the lkmm experts to decide :)
-Chris
