Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4271547B2EE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240454AbhLTSfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:35:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48974 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbhLTSfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 13:35:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57FFEB8107D;
        Mon, 20 Dec 2021 18:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890F7C36AE2;
        Mon, 20 Dec 2021 18:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640025308;
        bh=aGT6VJwp7juMll29rc2UMHesMInGQhBsInKsVt+pZtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZouLs5mlcrcEAv/5rd5gnF+3cU9Twn4ip++jLgXDblncw6/FoXS503mt4el5bIZVs
         j1D6SvIJuCqsJF9mdUbhSv52U0r1wLlt98ovYCYtegPk8NBhiUiWpg5OXFkNlJ20pr
         +QbMHhLYy/mQPqq+LIpQCkvCqM6ZM/k7nzHkh0tJZfcpvr1D010OpPxT1bwEitlshO
         AuWDmUcYLFece0QGXTLh5amQJDIh5a2nF01k9OPy8EeCctBFXBghX8hcjSZmSSKHxm
         ApDv5wVhqZg7rAJV1urPB+s0g5BdtpVopPihaGWzdfMLZNmz8Zp30IGJ9lIpmjm0QN
         0ryK9TpL2Lrfw==
Date:   Mon, 20 Dec 2021 12:35:05 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for
 crng_node_pool
Message-ID: <YcDM2cpwiGCb56Gp@quark>
References: <20211219025139.31085-1-ebiggers@kernel.org>
 <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
 <20211220181115.GZ641268@paulmck-ThinkPad-P17-Gen-1>
 <CAHmME9qZDNz2uxPa13ZtBMT2RR+sP1OU=b73tcZ9BTD1T_MJOg@mail.gmail.com>
 <20211220183140.GC641268@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220183140.GC641268@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 10:31:40AM -0800, Paul E. McKenney wrote:
> On Mon, Dec 20, 2021 at 07:16:48PM +0100, Jason A. Donenfeld wrote:
> > On Mon, Dec 20, 2021 at 7:11 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > First I would want
> > 
> > It looks like you've answered my question with four other questions,
> > which seem certainly technically warranted, but also indicates we're
> > probably not going to get to the nice easy resting place of, "it is
> > safe; go for it" that I was hoping for. In light of that, it seems
> > like merging Eric's patch is reasonable.
> 
> My hope would be that the questions can be quickly answered by the
> developers and maintainers.  But yes, hope springs eternal.
> 
> 							Thanx, Paul

I wouldn't expect READ_ONCE() to provide a noticable performance improvement
here, as it would be lost in the noise of the other work done, especially
chacha20_block().

The data structures in question are never freed, so your other questions are
irrelevant, if I understand correctly.

- Eric
