Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9F1558B9
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 22:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfFYU03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 16:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfFYU02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 16:26:28 -0400
Received: from localhost (unknown [167.220.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 924D7208CB;
        Tue, 25 Jun 2019 20:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561494387;
        bh=JEk0cxAG6r1WJfLtwJzcLC3OYbXH4I30rZFCgMvfzOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6LhoQ9njyM4a6Dx1/KzClC8sw6LYkj5vvXLE1lf133Zr/P7eYNuZRv6Zk4qyeRGL
         CpHLrFtPYA5H2B4rhsx0NNwYiqdLjS5Ee/k6WCJGFkQ9NtJ/FdlVsbU4ondJRFvtuu
         7kL3QH2vL9kcWSR0AcOjk7/Jv03n117GNTTZTHr8=
Date:   Tue, 25 Jun 2019 16:26:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Josh Hunt <johunt@akamai.com>
Cc:     gregkh@linuxfoundation.org, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
Message-ID: <20190625202626.GD7898@sasha-vm>
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1561483177-30254-1-git-send-email-johunt@akamai.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 01:19:37PM -0400, Josh Hunt wrote:
>Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:

You probably meant b6653b3629e5b88202be3c9abc44713973f5c4b4 here.

>tcp_fragment() might be called for skbs in the write queue.
>
>Memory limits might have been exceeded because tcp_sendmsg() only
>checks limits at full skb (64KB) boundaries.
>
>Therefore, we need to make sure tcp_fragment() wont punish applications
>that might have setup very low SO_SNDBUF values.
>
>Backport notes:
>Initial version used tcp_queue type which is not present in older kernels,
>so added a new arg to tcp_fragment() to determine whether this is a
>retransmit or not.
>
>Fixes: 9daf226ff926 ("tcp: tcp_fragment() should apply sane memory limits")
>Signed-off-by: Josh Hunt <johunt@akamai.com>
>Reviewed-by: Jason Baron <jbaron@akamai.com>
>---
>
>Eric/Greg - This applies on top of v4.14.130. I did not see anything come
>through for the older (<4.19) stable kernels yet. Without this change
>Christoph Paasch's packetrill script (https://lore.kernel.org/netdev/CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com/)
>will fail on 4.14 stable kernels, but passes with this change.

Eric, it would be great if you could Ack this, it's very different from
your original patch.

--
Thanks,
Sasha
