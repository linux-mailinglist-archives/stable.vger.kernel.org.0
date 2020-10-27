Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF97F29C027
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817003AbgJ0RMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:12:01 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:45974 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1786275AbgJ0RMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 13:12:01 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09RHB2Ch015504;
        Tue, 27 Oct 2020 18:11:02 +0100
Date:   Tue, 27 Oct 2020 18:11:02 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        George Spelvin <lkml@sdf.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.9 639/757] random32: make prandom_u32() output
 unpredictable
Message-ID: <20201027171102.GA15452@1wt.eu>
References: <20201027135450.497324313@linuxfoundation.org>
 <20201027135520.535662993@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027135520.535662993@linuxfoundation.org>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Oct 27, 2020 at 02:54:49PM +0100, Greg Kroah-Hartman wrote:
> From: George Spelvin <lkml@sdf.org>
> 
> [ Upstream commit c51f8f88d705e06bd696d7510aff22b33eb8e638 ]
> 
> Non-cryptographic PRNGs may have great statistical properties, but
> are usually trivially predictable to someone who knows the algorithm,
> given a small sample of their output.  An LFSR like prandom_u32() is
> particularly simple, even if the sample is widely scattered bits.
(...)

I'd have let it cook a bit longer into mainline before backporting it,
first it's not small (a bit border line by stable rules), and second,
considering how long we've been with the previous solution, there's no
emergency anymore. The risks are essentially at the build level though
(e.g.  include hell on exotic architectures, or obscure driver trying
to make use of one of the removed functions maybe).

On the other hand, given the amount of tests that run on the stable
queue, we'll quickly know! So we can probably keep it for now, but do
not hesitate to drop and postpone it if it causes any trouble so that
we have time to investigate. I'd rather not go through the previous
one's repeated breakage again!

Thanks,
Willy
