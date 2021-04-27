Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1AC36CC04
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 21:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbhD0Tys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 15:54:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:42094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235719AbhD0Tys (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 15:54:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619553244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UU+HHD1NBGz6r7F+2OcKRwBgdkVaYixMO3Nrir0+ZUA=;
        b=DUYGCi2Pl2LipOe6CCm3LEmroKkFMxHWQe2BuVTJAlQBad2Hcnqgx2CFmbN06wdfDF65it
        +rgVGwXd2l+7P6jHrsXV0/QQwJ2ndyrQhoo34Fe5nkQDPNxQ0+A4t23/WdlRSPd0jW8IW+
        eQxlgMf1wM7OdaF+omS+rOwjwMC5b2k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 37B47AD22;
        Tue, 27 Apr 2021 19:54:04 +0000 (UTC)
Message-ID: <3a0b10f45ac75df3f744dd04ac874021488f42b1.camel@suse.com>
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Date:   Tue, 27 Apr 2021 21:54:02 +0200
In-Reply-To: <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
References: <20210427085246.13728-1-mwilck@suse.com>
         <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
         <20210427162521.GA26528@lst.de>
         <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-04-27 at 20:05 +0200, Hannes Reinecke wrote:
> On 4/27/21 6:25 PM, Christoph Hellwig wrote:
> > On Tue, Apr 27, 2021 at 11:33:04AM +0200, Hannes Reinecke wrote:
> > > As indicated in my previous mail, please change the description.
> > > We have
> > > since established a actual reason (duplicate calls to
> > > add_timer()), so
> > > please list it here.
> > 
> > So what happens if the offending add_timer is changed to mod_timer?
> > 
> I guess that should be fine, as the boilerplate said it can act
> as a safe version of add_timer.
> 
> But that would just solve the crash upon add_timer().

The code doesn't use add_timer(), only mod_timer() and
del_timer_sync(). And we didn't observe a crash upon add_timer(). What
we observed was that a timer had been enqueued multiple times, and the
kernel crashes in expire_timers()->detach_timer(), when it encounters
an already detached entry in the timer list.

Regards,
Martin



