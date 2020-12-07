Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F672D0A89
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 07:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgLGGIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 01:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgLGGIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 01:08:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04DBC0613D0;
        Sun,  6 Dec 2020 22:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jJe1mZNNS4VmFa6XZxq6kbSRFlAAblrXazBVNO87E0U=; b=uN5tH5kZw1K13G/E9Ga8+uktt3
        ts6DuozVOImyfrqe7ZbFH9UIlsJ1pOWlNLmrfTeRnEvHZrwdJcrNh7Oh2fbBfXo/kqBubai81Zygb
        01SmeyQ8aSyfKdmdaNBBu30vhz3qGRnVhkCbZghBVObne4ohs37JkIwLXT7zbgZtyfKLJ0AVxaFer
        8wdPVS+bjhAqd33n8qu5AeaEm75yyFxB9ypSW0I8Xl12VL2qTeHUxSPov3u94X/ZPNeue5C5V7rKl
        ZFiwsvECSXsn5c3XE9lpXgYiaUPa7rI3g2G7XR18Qoqzp0Lo87vqhrqwehz3Tnx8XCN39AFoeFSmt
        sDAI8h6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1km9gZ-0004NJ-05; Mon, 07 Dec 2020 06:07:47 +0000
Date:   Mon, 7 Dec 2020 06:07:46 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, rcu@vger.kernel.org,
        lkft-triage@lists.linaro.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: WARNING: bad unlock balance detected! - mkfs.ext4/426 is trying
 to release lock (rcu_read_lock)
Message-ID: <20201207060746.GT11935@casper.infradead.org>
References: <CA+G9fYs=nR-d0n8kV4=OWD+v=GR2ufOEWU9S4oG1_fZRxhGouQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs=nR-d0n8kV4=OWD+v=GR2ufOEWU9S4oG1_fZRxhGouQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 11:17:29AM +0530, Naresh Kamboju wrote:
> While running "mkfs -t ext4" on arm64 juno-r2 device connected with SSD drive
> the following kernel warning reported on stable rc 5.9.13-rc1 kernel.
> 
> Steps to reproduce:
> ------------------
> # boot arm64 Juno-r2 device with stable-rc 5.9.13-rc1.
> # Connect SSD drive
> # Format the file system ext4 type
>  mkfs -t ext4 <SSD-drive>
> # you will notice this warning

Does it happen easily?  Can you bisect?

> Crash log:
> --------------
> Writing superblocks and filesystem accounting information:   0/895
> [   86.131095]
> [   86.132592] =====================================
> [   86.137300] WARNING: bad unlock balance detected!
> [   86.142012] 5.9.13-rc1 #1 Not tainted
> [   86.145675] -------------------------------------
> [   86.150384] mkfs.ext4/426 is trying to release lock (rcu_read_lock) at:
> [   86.157020] [<ffff80001063478c>] blk_queue_exit+0xcc/0x1b0
> [   86.162511] but there are no more locks to release!

This really doesn't make much sense.  blk_queue_exit() in 5.9.12 does:

        percpu_ref_put(&q->q_usage_counter);
(literally, that's the entire function)

percpu_ref_put() does:

       rcu_read_lock();

        if (__ref_is_percpu(ref, &percpu_count))
                this_cpu_sub(*percpu_count, nr);
        else if (unlikely(atomic_long_sub_and_test(nr, &ref->count)))
                ref->release(ref);

        rcu_read_unlock();

Unless ->release() has an unbalanced rcu_read_unlock(), there definitely
is a lock to release!  Some archaeology says that ->release is
blk_queue_usage_counter_release(), which calls
        wake_up_all(&q->mq_freeze_wq);

which doesn't appear to use RCU at all.  So this trace makes no sense,
and all I can do is ask you to bisect it.

