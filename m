Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B65847B2A4
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240388AbhLTSLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:11:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40550 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240368AbhLTSLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 13:11:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D1A0B80E4F;
        Mon, 20 Dec 2021 18:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D017FC36AEA;
        Mon, 20 Dec 2021 18:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640023875;
        bh=tEPmTDL4AttPFhO9OdyUWkKX2oZMfoIsTqVVbMyvsso=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=L4TbCOntkXIQOmvOm61F5uEkVoFdjjN2RJjQC0XO5z8FS2UIBQbB0zXpPQIJ6ZnOC
         wOL41PmtHsIi8AIkbQM57sVpycXCB4oiQROxd76gqT4evf4132+WFn/pARvzuLGUs3
         I+eNu2lv/UDyL5OPSOQlPH1Tguv5WXyAEa44mJBWgacTkr5Ne04yZ7J9lhjFScJbyS
         nxnLDiwSppR72QRpg0IkBNhecIL+jODwQab9lO7S8mLeeK+MaZgd3nuRh5qFH5zDoQ
         mhDXPhXqzpp8g86Sjybjl3QvJHamQoMsdL2MhsJuFEw4WSwl5dKu9Nbjte2ZLfcyqQ
         HP/x772+nRT0w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 904335C100E; Mon, 20 Dec 2021 10:11:15 -0800 (PST)
Date:   Mon, 20 Dec 2021 10:11:15 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for
 crng_node_pool
Message-ID: <20211220181115.GZ641268@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211219025139.31085-1-ebiggers@kernel.org>
 <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 04:07:28PM +0100, Jason A. Donenfeld wrote:
> Hi Eric,
> 
> This patch seems fine to me, and I'll apply it in a few days after
> sitting on the list for comments, but:
> 
> > Note: READ_ONCE() could be used instead of smp_load_acquire(), but it is
> > harder to verify that it is correct, so I'd prefer not to use it here.
> > (https://lore.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org/T/#u),
> > and though it's a correct fix, it was derailed by a debate about whether
> > it's safe to use READ_ONCE() instead of smp_load_acquire() or not.
> 
> But holy smokes... I chuckled at your, "please explain in English." :)
> 
> Paul - if you'd like to look at this patch and confirm that this
> specific patch and usage is fine to be changed into READ_ONCE()
> instead of smp_load_acquire(), please pipe up here. And I really do
> mean this specific patch and usage, not to be confused with any other
> usage elsewhere in the kernel or question about general things, which
> doubtlessly involve larger discussions like the one Eric linked to
> above. If you're certain this patch here is READ_ONCE()able, I'd
> appreciate your saying so with a simple, "it is safe; go for it",
> since I'd definitely like the optimization if it's safe. If I don't
> hear from you, I'll apply this as-is from Eric, as I'd rather be safe
> than sorry.

First I would want to see some evidence that READ_ONCE() was really
providing measurable performance benefit.  Such evidence would be
easiest to obtain by running on a weakly ordered system such as ARM,
ARMv8, or PowerPC.

If this does provide a measurable benefit, why not the following?

static inline struct crng_state *select_crng(void)
{
	struct crng_state **pool;
	struct crng_state *pooln;
	int nid = numa_node_id();

	/* pairs with cmpxchg_release() in do_numa_crng_init() */
	pool = rcu_dereference(&crng_node_pool);
	if (pool) {
		pooln = rcu_dereference(pool[nid]);
		if (pooln)
			return pooln;
	}

	return &primary_crng;
}

This is in ignorance of the kfree() side of this code.  So another
question is "Suppose that there was a long delay (vCPU preemption, for
example) just before the 'return pooln'.  What prevents a use-after-free
bug?"

Of course, this question applies equally to the smp_load_acquire()
version.

							Thanx, Paul
