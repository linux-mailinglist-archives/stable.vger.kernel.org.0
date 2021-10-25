Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EAF4390D7
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhJYIJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:09:29 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:44706 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhJYIJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 04:09:26 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 19P86KPj023417;
        Mon, 25 Oct 2021 10:06:20 +0200
Date:   Mon, 25 Oct 2021 10:06:20 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Peter Cordes <peter@cordes.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/3] tools/nolibc: i386: fix initial stack alignment
Message-ID: <20211025080620.GA23398@1wt.eu>
References: <20211024172816.17993-1-w@1wt.eu>
 <20211024172816.17993-3-w@1wt.eu>
 <7e5ed287476042388779ca3c84483a92@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e5ed287476042388779ca3c84483a92@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 07:46:11AM +0000, David Laight wrote:
> From: Willy Tarreau
> > Sent: 24 October 2021 18:28
> > 
> > After re-checking in the spec and comparing stack offsets with glibc,
> > The last pushed argument must be 16-byte aligned (i.e. aligned before the
> > call) so that in the callee esp+4 is multiple of 16, so the principle is
> > the 32-bit equivalent to what Ammar fixed for x86_64. It's possible that
> > 32-bit code using SSE2 or MMX could have been affected. In addition the
> > frame pointer ought to be zero at the deepest level.
> > 
> ...
> >  /* startup code */
> > +/*
> > + * i386 System V ABI mandates:
> > + * 1) last pushed argument must be 16-byte aligned.
> > + * 2) The deepest stack frame should be set to zero
> 
> I'm pretty sure that the historic SYSV i386 ABI only every required
> 4-byte alignment for the stack.
> 
> At some point it got 'randomly' changed to 16-byte.
> I don't think this happened until after compiler support for SSE2
> intrinsics was added.

It's very possible because I've done a number of tests and noticed
that in some cases the called functions' stack doesn't seem to be
more than 4-aligned. However the deepest function in the stack starts
with an aligned stack so I prefer to follow this same rule.

Willy
