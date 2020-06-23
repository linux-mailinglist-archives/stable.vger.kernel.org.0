Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45E4205402
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 15:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732735AbgFWN6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 09:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732674AbgFWN6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 09:58:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8AEC20724;
        Tue, 23 Jun 2020 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592920692;
        bh=Ci6wqSehVsCQ+MtuJXLlLiS0T8MJ2N/2hp5uaah1DFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YkfHfTUCcLeC5yQjx7D+3msi0WHKGNFbCBX7ZGuIZJtuIY+gaCnhd//eXncS4DtGU
         pH1crIp0dVTfFkz+i5+cvQTIdLDXOlazv7De2ZR/hJSiIcQrWmYd0daF19nUWumMrw
         ArxcN40rE3pLNhvovbdGtltAXdI188dlZnOEnm48=
Date:   Tue, 23 Jun 2020 09:58:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     a.darwish@linutronix.de, bigeasy@linutronix.de,
        dan.carpenter@oracle.com, davem@davemloft.net, lkp@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: core: device_rename: Use rwsem
 instead of a seqcount" failed to apply to 5.4-stable tree
Message-ID: <20200623135810.GA1931@sasha-vm>
References: <159291361435200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159291361435200@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 02:00:14PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 11d6011c2cf29f7c8181ebde6c8bc0c4d83adcd7 Mon Sep 17 00:00:00 2001
>From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>Date: Wed, 3 Jun 2020 16:49:44 +0200
>Subject: [PATCH] net: core: device_rename: Use rwsem instead of a seqcount
>
>Sequence counters write paths are critical sections that must never be
>preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.
>
>Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
>netdev name retrieval.") handled a deadlock, observed with
>CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
>infinitely spinning: it got scheduled after the seqcount write side
>blocked inside its own critical section.
>
>To fix that deadlock, among other issues, the commit added a
>cond_resched() inside the read side section. While this will get the
>non-preemptible kernel eventually unstuck, the seqcount reader is fully
>exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.
>
>The fix is also still broken: if the seqcount reader belongs to a
>real-time scheduling policy, it can spin forever and the kernel will
>livelock.
>
>Disabling preemption over the seqcount write side critical section will
>not work: inside it are a number of GFP_KERNEL allocations and mutex
>locking through the drivers/base/ :: device_rename() call chain.
>
>>From all the above, replace the seqcount with a rwsem.
>
>Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
>Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
>Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
>Cc: <stable@vger.kernel.org>
>Reported-by: kbuild test robot <lkp@intel.com> [ v1 missing up_read() on error exit ]
>Reported-by: Dan Carpenter <dan.carpenter@oracle.com> [ v1 missing up_read() on error exit ]
>Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
>Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>Signed-off-by: David S. Miller <davem@davemloft.net>

The conflict was due to a change in comments in commit 2da2b32fd934
("sched/rt, net: Use CONFIG_PREEMPTION.patch"). I've just grabbed
2da2b32fd934 along and queued both of these for 5.4-4.4.

-- 
Thanks,
Sasha
