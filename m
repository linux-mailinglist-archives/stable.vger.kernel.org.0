Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29CA1303BA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 23:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE3VDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 17:03:20 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:57428 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfE3VDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 17:03:20 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 1567A1F462;
        Thu, 30 May 2019 21:03:19 +0000 (UTC)
Date:   Thu, 30 May 2019 21:03:18 +0000
From:   Eric Wong <e@80x24.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        arnd@arndb.de, dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net,
        jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: pselect/etc semantics
Message-ID: <20190530210318.dbappo23kdcysraw@dcvr>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <87woi8rt96.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87woi8rt96.fsf@xmission.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Eric W. Biederman" <ebiederm@xmission.com> wrote:
> Frankly the only reason this appears to be worth touching is that we
> have a userspace regression.  Otherwise I would call the current
> behavior more correct and desirable than ignoring the signal longer.
> 
> If I am reading sitaution properly I suggest we go back to resoring the
> sigmask by hand in epoll_pwait, and put in a big fat comment about a
> silly userspace program depending on that behavior.
> 
> That will be easier to backport and it will just fix the regression and
> not overfix the problem for reasonable applications.

Fwiw, the cmogstored (userspace program which regressed) only
hit this regression in an obscure code path for tuning; that
code path probably sees no use outside of the test suite.

Add to that, cmogstored is an unofficial and optional component
to the obscure, largely-forgotten MogileFS.

Finally, the main users of cmogstored are on FreeBSD.  They
hit the kqueue+self-pipe code path instead of epoll_pwait.

I only used epoll_pwait on Linux since I figured I could save a
few bytes of memory by skipping eventfd/self-pipe...

Anyways, I updated cmogstored a few weeks back to call `note_run'
(the signal dispatcher) if epoll_pwait (wrapped by `mog_idleq_wait_intr')
returns 0 instead of -1 (EINTR) to workaround this kernel change:

https://bogomips.org/cmogstored-public/20190511075630.17811-1-e@80x24.org/

I could easily make a change to call `note_run' unconditionally
when `mog_idleq_wait_intr' returns, too.

But that said, there could be other users hitting the same
problem I did.  So maybe cmogstored's primary use on Linux these
days is finding regressions :>
