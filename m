Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3094D36CAEC
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 20:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhD0SLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 14:11:43 -0400
Received: from verein.lst.de ([213.95.11.211]:46358 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235505AbhD0SLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 14:11:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id ADCB468C7B; Tue, 27 Apr 2021 20:10:56 +0200 (CEST)
Date:   Tue, 27 Apr 2021 20:10:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, mwilck@suse.com,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
Message-ID: <20210427181056.GA1975@lst.de>
References: <20210427085246.13728-1-mwilck@suse.com> <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de> <20210427162521.GA26528@lst.de> <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f82b7f7c-ef12-27bb-1349-d23ea22e50a9@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 27, 2021 at 08:05:41PM +0200, Hannes Reinecke wrote:
> On 4/27/21 6:25 PM, Christoph Hellwig wrote:
> > On Tue, Apr 27, 2021 at 11:33:04AM +0200, Hannes Reinecke wrote:
> >> As indicated in my previous mail, please change the description. We have
> >> since established a actual reason (duplicate calls to add_timer()), so
> >> please list it here.
> > 
> > So what happens if the offending add_timer is changed to mod_timer?
> > 
> I guess that should be fine, as the boilerplate said it can act
> as a safe version of add_timer.
> 
> But that would just solve the crash upon add_timer(). We still have the
> problem that the anatt timer might trigger just _after_ eg
> nvme_tcp_teardown_admin_queue(), causing it to hit an invalid admin queue.

Yeah.  nvme_mpath_init isn't really suitable for being called on an
already initialized controller for a few reasons.  I have an idea how
to fix it, let me give it a spin.
