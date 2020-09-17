Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAC426E172
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 18:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgIQQ6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 12:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgIQQ6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:58:04 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D1F2064B;
        Thu, 17 Sep 2020 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600361883;
        bh=NwlAyiLjTJ0j5yg6SRwHpbvNMgyHQjkW5kmX6FoEcgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nEYszSBMEO+r1s7Q87HA5vDqSVUEgn1nbrHeN3LgU3NS8JFTSIsva3kppWcAcRj0g
         LTACDMsv+T1mWYlEp+0ocMXZRXn49KPZf+8ARo80x7g4liUsUpkbluubWAYIIIzbxf
         MeRfBXm6tWLug0LspHw7xYAr4R+FJNpU//N/jAB8=
Date:   Thu, 17 Sep 2020 09:58:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200917165802.GC855@sol.localdomain>
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917072644.GA5311@gondor.apana.org.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 05:26:44PM +1000, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > When a CPU selects which CRNG to use, it accesses crng_node_pool without
> > a memory barrier.  That's wrong, because crng_node_pool can be set by
> > another CPU concurrently.  Without a memory barrier, the crng_state that
> > is used might not appear to be fully initialized.
> 
> The only architecture that requires a barrier for data dependency
> is Alpha.  The correct primitive to ensure that barrier is present
> is smp_barrier_depends, or you could just use READ_ONCE.
> 

smp_load_acquire() is obviously correct, whereas READ_ONCE() is an optimization
that is difficult to tell whether it's correct or not.  For trivial data
structures it's "easy" to tell.  But whenever there is a->b where b is an
internal implementation detail of another kernel subsystem, the use of which
could involve accesses to global or static data (for example, spin_lock()
accessing lockdep stuff), a control dependency can slip in.

The last time I tried to use READ_ONCE(), it started a big controversy
(https://lkml.kernel.org/linux-fsdevel/20200713033330.205104-1-ebiggers@kernel.org/T/#u,
https://lkml.kernel.org/linux-fsdevel/20200717044427.68747-1-ebiggers@kernel.org/T/#u,
https://lwn.net/Articles/827180/).  In the end, people refused to even allow the
READ_ONCE() optimization to be documented, because they felt that
smp_load_acquire() should just be used instead.

So I think we should just go with smp_load_acquire()...

- Eric
