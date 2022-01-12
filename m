Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CC348C1EC
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 11:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbiALKEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 05:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239196AbiALKEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 05:04:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209BAC06173F;
        Wed, 12 Jan 2022 02:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Kh/HKj3/o1WOFn9L3CDxPNGxXJ5OR1S9mBMFhWz9mXY=; b=Inj4tqlAk9DWNVe9v6+4CQ6Xhe
        FWOdQX8JvqI/7oePa/z66spHCoPa/5xqHj8tZpSjqJDFIOojup1PaO+6R0MCymfVsXdCJ9TNPlgrA
        hm8GM1IbQTs2nENXPRwRIEu+309+J20VXtvD5kcHstRRhDWDasaCeN0NzuiLZ+WEzOTNC9fRAweYZ
        1zVnbBBN1HKqMueamY1H0hFVgEBiUm9bsrZYfsKmxj0DVhptvsT8upBEWoPzJjuvZEdLvz2EdrDTW
        gqUctnWJpjoo1SPh6JlMNKLAe8Zr5+PXmvk92vCrUFCTGiZ2GKzC5J7r3IyTagGVf6AjVFOHIlMeC
        9cpQyi2Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7aTz-0040I5-6b; Wed, 12 Jan 2022 10:03:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D7F08300222;
        Wed, 12 Jan 2022 11:03:52 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B578920139FF2; Wed, 12 Jan 2022 11:03:52 +0100 (CET)
Date:   Wed, 12 Jan 2022 11:03:52 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     hannes@cmpxchg.org, torvalds@linux-foundation.org,
        ebiggers@kernel.org, tj@kernel.org, lizefan.x@bytedance.com,
        mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@android.com,
        syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Message-ID: <Yd6niK1gzKc5lIJ8@hirez.programming.kicks-ass.net>
References: <20220111232309.1786347-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111232309.1786347-1-surenb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 03:23:09PM -0800, Suren Baghdasaryan wrote:
> With write operation on psi files replacing old trigger with a new one,
> the lifetime of its waitqueue is totally arbitrary. Overwriting an
> existing trigger causes its waitqueue to be freed and pending poll()
> will stumble on trigger->event_wait which was destroyed.
> Fix this by disallowing to redefine an existing psi trigger. If a write
> operation is used on a file descriptor with an already existing psi
> trigger, the operation will fail with EBUSY error.
> Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> flag can be flipped after the trigger is created, leading to a memory
> leak.
> 
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
> Analyzed-by: Eric Biggers <ebiggers@kernel.org>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

Thanks, I'll go stick this in sched/urgent unless Linus picks it up
himself.
