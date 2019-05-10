Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7767E1A28A
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 19:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfEJRnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 13:43:13 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:52514 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbfEJRnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 13:43:13 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2019 13:43:12 EDT
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 1BF7DA0692;
        Fri, 10 May 2019 17:36:45 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Dp0a1D6s0PIr; Fri, 10 May 2019 17:36:44 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 4B05EA067D;
        Fri, 10 May 2019 17:36:44 +0000 (UTC)
Date:   Fri, 10 May 2019 17:36:32 +0000 (UTC)
From:   Eric Wheeler <drbd-dev@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Lars Ellenberg <lars.ellenberg@linbit.com>
cc:     Christoph Hellwig <hch@infradead.org>, drbd-dev@lists.linbit.com,
        stable@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drbd: fix discard_zeroes_if_aligned regression
In-Reply-To: <20180116094907.GD4107@soda.linbit>
Message-ID: <alpine.LRH.2.11.1905101728280.1835@mx.ewheeler.net>
References: <15124635.GA4107@soda.linbit> <1516057231-21756-1-git-send-email-drbd-dev@lists.ewheeler.net> <20180116072615.GA3940@infradead.org> <20180116094907.GD4107@soda.linbit>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Jan 2018, Lars Ellenberg wrote:

> On Mon, Jan 15, 2018 at 11:26:15PM -0800, Christoph Hellwig wrote:
> > NAK.  Calling a discard and expecting zeroing is simply buggy.
> 
> What he said.
> 
> The bug/misunderstanding was that we now use zeroout even for discards,
> with the assumption that it would try to do discards where it can.
> 
> Which is even true.
> 
> But our expectations of when zeroout "should" use unmap,
> and where it actually can do that safely
> based on the information it has,
> don't really match:
> our expectations where wrong, we assumed too much.
> (in the general case).
> 
> Which means in DRBD we have to stop use zeroout for discards,
> and again pass down normal discard for discards.
> 
> In the specific case where the backend to DRBD is lvm-thin,
> AND it does de-alloc blocks on discard,
> AND it does NOT have skip_block_zeroing set or it's backend
> does zero on discard and it does discard passdown, and we tell
> DRBD about all of that (using the discard_zeroes_if_aligned flag)
> then we can do this "zero head and tail, discard full blocks",
> and expect them to be zero.
> 
> If skip_block_zeroing is set however, and there is no discard
> passdown in thin, or the backend of thin does not zero on discard,
> DRBD can still pass down discards to thin, and expect them do be
> de-allocated, but can not expect discarded ranges to remain
> "zero", any later partial write to an unallocated area could pull
> in different "undefined" garbage on different replicas for the
> not-written-to part of a new allocated block.
> 
> The end result is that you have areas of the block device
> that return different data depending on which replica you
> read from.
> 
> But that is the case even eithout discard in that setup,
> don't do that then or live with it.
> 
> "undefined data" is undefined, you have that directly on thin
> in that setup already, with DRBD on top you now have several
> versions of "undefined".
> 
> Anything on top of such a setup must not do "read-modify-write"
> of "undefined" data and expect a defined result, adding DRBD
> on top does not change that.
> 
> DRBD can deal with that just fine, but our "online verify" will
> report loads of boring "mismatches" for those areas.
> 
> TL;DR: we'll stop doing "discard-is-zeroout"
> (our assumptions were wrong).
> We still won't do exactly "discard-is-discard", but re-enable our
> "discard-is-discard plus zeroout on head and tail", because in
> some relevant setups, this gives us the best result, and avoids
> the false positives in our online-verify.
> 
>     Lars
> 

Hi Lars,

We just tried 4.19.x and this bugs still exists. We applied the patch 
which was originally submitted to this thread and it still applies cleanly 
and seems to work for our use case. You mentioned that you had some older 
code which zeroed out unaligned discard requests (or perhaps it was for a 
different purpose) that you may be able to use to patch this. Could you 
dig those up and see if we can get this solved?

It would be nice to be able to use drbd with thin backing volumes from the 
vanilla kernel. If this has already been fixed in something newer than 
4.19, then please point me to the commit.

Thank you for your help!

 
--
Eric Wheeler


