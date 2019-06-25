Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D66F55AF0
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 00:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFYWTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 18:19:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFYWTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 18:19:12 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134F82086D;
        Tue, 25 Jun 2019 22:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561501151;
        bh=deD41QlBISMSsDZLAuAmfAJys8abDd3FhF8Afoi0BZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y/t1GgM8oUjlkPNRXnYCG9Shssu6jEYN6oIhqvrBQI7/Ida9sCdvhTnpSZtLUCIaC
         TQ0nuF5W7JzpD31vdJT7RcK3uXzXeFAAX6H3FN3Czft2qOk+vPqr8eCceFtU5/TM2o
         oFZgJg1iJZ8N8v144urIRgD4HqSOvfIrzwQWyJKE=
Date:   Wed, 26 Jun 2019 06:18:21 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Josh Hunt <johunt@akamai.com>
Cc:     Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
Message-ID: <20190625221821.GA17994@kroah.com>
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
 <20190625202626.GD7898@sasha-vm>
 <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 01:29:35PM -0700, Josh Hunt wrote:
> On 6/25/19 1:26 PM, Sasha Levin wrote:
> > On Tue, Jun 25, 2019 at 01:19:37PM -0400, Josh Hunt wrote:
> > > Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:
> > 
> > You probably meant b6653b3629e5b88202be3c9abc44713973f5c4b4 here.
> 
> I wasn't sure if I should reference the upstream commit or stable commit.

The upstream commit please.

> dad3a9314 is the version of the commit from linux-4.14.y. There may be a
> similar issue with the Fixes tag below since that also references the 4.14
> vers of the change.
> 
> > 
> > > tcp_fragment() might be called for skbs in the write queue.
> > > 
> > > Memory limits might have been exceeded because tcp_sendmsg() only
> > > checks limits at full skb (64KB) boundaries.
> > > 
> > > Therefore, we need to make sure tcp_fragment() wont punish applications
> > > that might have setup very low SO_SNDBUF values.
> > > 
> > > Backport notes:
> > > Initial version used tcp_queue type which is not present in older
> > > kernels,
> > > so added a new arg to tcp_fragment() to determine whether this is a
> > > retransmit or not.
> > > 
> > > Fixes: 9daf226ff926 ("tcp: tcp_fragment() should apply sane memory
> > > limits")
> > > Signed-off-by: Josh Hunt <johunt@akamai.com>
> > > Reviewed-by: Jason Baron <jbaron@akamai.com>
> > > ---
> > > 
> > > Eric/Greg - This applies on top of v4.14.130. I did not see anything come
> > > through for the older (<4.19) stable kernels yet. Without this change
> > > Christoph Paasch's packetrill script (https://lore.kernel.org/netdev/CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com/)
> > > 
> > > will fail on 4.14 stable kernels, but passes with this change.
> > 
> > Eric, it would be great if you could Ack this, it's very different from
> > your original patch.
> 
> Yes, that would be great.

I would prefer if this looks a bit more like the upstream fix, perhaps a
backport of the function that added the "direction" of the packet first,
and then Eric's patch?  As it is, this patch adds a different parameter
to the function than what is in Linus's tree, and I bet will cause
problems at some later point in time.

thanks,

greg k-h
