Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C3236D2C4
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 09:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhD1HHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 03:07:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:37062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230504AbhD1HHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 03:07:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619593592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5EnWeViouCWxoehMxDephqDSVUFaig7yM6l3zP3EZdI=;
        b=Vbui47+aVujGz4x3CCbh7GWCA2TAjB08+lnkZY4xHKs8YK878oKq2TRod0qpQviSPvmPqv
        fPtD1tjOMuHfqxgk3EzRXXTujb61PYdSLCI8udA9bIChcRefxF1/0YPYErFlbZw6/TyE0y
        0qPloRFei8zqcbHyeKNEbPk9n8th3iA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1BBCDAEA6;
        Wed, 28 Apr 2021 07:06:32 +0000 (UTC)
Message-ID: <e11706e498a583b764ff9e9b1b7de409f996ad07.camel@suse.com>
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
From:   Martin Wilck <mwilck@suse.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Date:   Wed, 28 Apr 2021 09:06:31 +0200
In-Reply-To: <CAFL455=m_4tLZwbh1qRGPgE8ufBfKuq84zKkZmCntX56A17kog@mail.gmail.com>
References: <20210427085246.13728-1-mwilck@suse.com>
         <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
         <20210427162521.GA26528@lst.de>
         <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
         <3a0b10f45ac75df3f744dd04ac874021488f42b1.camel@suse.com>
         <CAFL455=m_4tLZwbh1qRGPgE8ufBfKuq84zKkZmCntX56A17kog@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-04-28 at 08:39 +0200, Maurizio Lombardi wrote:
> út 27. 4. 2021 v 22:02 odesílatel Martin Wilck <mwilck@suse.com>
> napsal:
> > The code doesn't use add_timer(), only mod_timer() and
> > del_timer_sync(). And we didn't observe a crash upon add_timer().
> > What
> > we observed was that a timer had been enqueued multiple times, and
> > the
> > kernel crashes in expire_timers()->detach_timer(), when it encounters
> > an already detached entry in the timer list.
> 
> How can a timer end up enqueued multiple times?

I observed in a dump that this can happen. More precisely, I observed
the following:

[ 4389.978732] nvme nvme36: Successfully reconnected (1 attempt)
...
[ 4441.445655] nvme nvme36: Successfully reconnected (1 attempt)
...
[ 4510.891400] nvme nvme36: ANATT timeout, resetting controller.
...
[ 4517.035411] general protection fault: 0000 [#1] SMP PTI (kernel crash)

In the crash dump, I could see a anatt_timer belonging to nvme36 being
pending in the timer list, with a remaining expiry time of 44s,
suggesting it had been created around time 4441.4s. That means that at
the time the ANATT timeout was seen (which corresponds to a timer added
around 4389.9s), the timer must have been pending twice. (*)

> It's safe to call mod_timer() against both an active or an inactive
> timer
> and mod_timer() is thread-safe also.
> 
> IMO the problem is due to the fact that timer_setup() could end up
> being called against
> an active, pending timer.
> timer_setup() doesn't take any lock and modifies the pprev pointer
> and
> the timer's flags

Yes, that's what I think has happened. timer_setup() doesn't clear any
pointers in the list of pending timers pointing to this entry. If the
newly-initialized timer is then added with mod_timer(), it becomes
linked in a second timer list. When the first one expires, the timer
will be detached, but only from one of the lists it's pending in. In a
scenario like the one we faced, this could actually happen multiple
times. If the detached timer remains linked into a timer list, once
that list is traversed, the kernel dereferences a pointer with value
LIST_POISON2, and crashes.

Anybody: correct me if this is nonsense.

Best,
Martin

(*) Note that the crash had been caused by another wrongly linked anatt
timer, not this one.

