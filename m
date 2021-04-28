Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE3636D259
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 08:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhD1Gmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 02:42:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:54166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhD1Gmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 02:42:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619592112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F4FdOvCubsbTBu0KqUq1Ap6WR++r5iCZVkQWHkrgDOA=;
        b=UV+kK7XOCBtVHI03BLSjo05mgzHXeN3AyB+HoLxIYLQ7XS9hPW8Y8qgWhAaWdz+/Y/+k+I
        RhbYYoITRNflKs8WuzdPxupwQes3MZh2NrVGSg/210J+1pNiNyJaO+4H8bnQw12bf8HkRb
        BzQBYb3c5K8uB9B9H01j2t4YfNsHE7Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 45208B0B6;
        Wed, 28 Apr 2021 06:41:52 +0000 (UTC)
Message-ID: <cc1236b8edab5010ef214cd59753907604302109.camel@suse.com>
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Date:   Wed, 28 Apr 2021 08:41:51 +0200
In-Reply-To: <8b61d0f8-f47f-8e03-5385-c48b0e7be187@suse.de>
References: <20210427085246.13728-1-mwilck@suse.com>
         <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
         <20210427162521.GA26528@lst.de>
         <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
         <3a0b10f45ac75df3f744dd04ac874021488f42b1.camel@suse.com>
         <8b61d0f8-f47f-8e03-5385-c48b0e7be187@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-04-28 at 08:35 +0200, Hannes Reinecke wrote:
> On 4/27/21 9:54 PM, Martin Wilck wrote:
> > On Tue, 2021-04-27 at 20:05 +0200, Hannes Reinecke wrote:
> > > On 4/27/21 6:25 PM, Christoph Hellwig wrote:
> > > > On Tue, Apr 27, 2021 at 11:33:04AM +0200, Hannes Reinecke
> > > > wrote:
> > > > > As indicated in my previous mail, please change the
> > > > > description.
> > > > > We have
> > > > > since established a actual reason (duplicate calls to
> > > > > add_timer()), so
> > > > > please list it here.
> > > > 
> > > > So what happens if the offending add_timer is changed to
> > > > mod_timer?
> > > > 
> > > I guess that should be fine, as the boilerplate said it can act
> > > as a safe version of add_timer.
> > > 
> > > But that would just solve the crash upon add_timer().
> > 
> > The code doesn't use add_timer(), only mod_timer() and
> > del_timer_sync(). And we didn't observe a crash upon add_timer().
> > What
> > we observed was that a timer had been enqueued multiple times, and
> > the
> > kernel crashes in expire_timers()->detach_timer(), when it
> > encounters
> > an already detached entry in the timer list.
> > 
> nvme_mpath_init() doesn't use add_timer, but it uses timer_setup().

Yes. The notion that this is wrong was the idea behind my patch.

> And
> calling that on an already pending timer is even worse :-)
> 
> And my point is that the anatt timer is not stopped at the end of
> nvme_init_identify() if any of the calls to
> 
> nvme_configure_apst()
> nvme_configure_timestamp()
> nvme_configure_directives()
> nvme_configure_acre()
> 
> returns with an error. If they do the controller is reset, causing
> eg nvme_tcp_configure_admin_queue() to be called, which will be
> calling timer_setup() with the original timer still running.
> If the (original) timer triggers _after_ that time we have the crash.

You are right. But afaics the problem doesn't have to originate in
these 4 function calls. The same applies even after
nvme_init_identify() has returned. Any error that would trigger the
error recovery work after the anatt timer has started would have this
effect.

Regards,
Martin


