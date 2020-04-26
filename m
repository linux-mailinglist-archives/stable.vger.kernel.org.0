Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0501A1B9497
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 01:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgDZXO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 19:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgDZXO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Apr 2020 19:14:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BAB920700;
        Sun, 26 Apr 2020 23:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587942867;
        bh=htmfK5LrnAgNejOxSRo69JhXRiDUTld1Bfn3UjhbRHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HtzXD/iv8ChpjBodHIffRZP1DHDhy/bHfbKvqqQEfk3B9IPjSV9TSCBIrF48X//sX
         ms7/jRZS12g9GTjTlcD7So1XSjrQ01mYIXn5vsksr3iOOpLAMZADJx4fnAAwkPamxE
         n+I5bkvB89k4TyZlqdWMFI2lArhLXGh8tmJeaNI0=
Date:   Sun, 26 Apr 2020 19:14:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.14] mm, slub: restore the original intention of
 prefetch_freepointer()
Message-ID: <20200426231426.GM13035@sasha-vm>
References: <20200426070617.14575-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200426070617.14575-1-sven@narfation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 26, 2020 at 09:06:17AM +0200, Sven Eckelmann wrote:
>From: Vlastimil Babka <vbabka@suse.cz>
>
>commit 0882ff9190e3bc51e2d78c3aadd7c690eeaa91d5 upstream.
>
>In SLUB, prefetch_freepointer() is used when allocating an object from
>cache's freelist, to make sure the next object in the list is cache-hot,
>since it's probable it will be allocated soon.
>
>Commit 2482ddec670f ("mm: add SLUB free list pointer obfuscation") has
>unintentionally changed the prefetch in a way where the prefetch is
>turned to a real fetch, and only the next->next pointer is prefetched.
>In case there is not a stream of allocations that would benefit from
>prefetching, the extra real fetch might add a useless cache miss to the
>allocation.  Restore the previous behavior.
>
>Link: http://lkml.kernel.org/r/20180809085245.22448-1-vbabka@suse.cz
>Fixes: 2482ddec670f ("mm: add SLUB free list pointer obfuscation")
>Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>Acked-by: Kees Cook <keescook@chromium.org>
>Cc: Daniel Micay <danielmicay@gmail.com>
>Cc: Eric Dumazet <edumazet@google.com>
>Cc: Christoph Lameter <cl@linux.com>
>Cc: Pekka Enberg <penberg@kernel.org>
>Cc: David Rientjes <rientjes@google.com>
>Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>Cc: Matthias Schiffer <mschiffer@universe-factory.net>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>Signed-off-by: Sven Eckelmann <sven@narfation.org>
>---
>The original problem is explained in the patch description as
>performance problem. And maybe this could also be one reason why it was
>never submitted for a stable kernel.
>
>But tests on mips ath79 (OpenWrt ar71xx target) showed that it most likely
>related to "random" data bus errors. At least applying this patch seemed to
>have solved it for Matthias Schiffer <mschiffer@universe-factory.net> and
>some other persons who where debugging/testing this problem with him.
>
>More details about it can be found in
>https://github.com/freifunk-gluon/gluon/issues/1982

Interesting... I wonder why this issue has started only now.

I've queued it up for 4.14, thanks!

-- 
Thanks,
Sasha
