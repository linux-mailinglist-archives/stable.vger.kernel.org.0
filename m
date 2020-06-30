Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAFC20F5D4
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 15:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgF3NgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 09:36:13 -0400
Received: from verein.lst.de ([213.95.11.211]:36002 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgF3NgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 09:36:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 019CF68B05; Tue, 30 Jun 2020 15:36:09 +0200 (CEST)
Date:   Tue, 30 Jun 2020 15:36:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Maximilian Heyne <mheyne@amazon.de>
Cc:     Amit Shah <aams@amazon.de>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvme: validate cntlid's only for nvme >= 1.1.0
Message-ID: <20200630133609.GA20809@lst.de>
References: <20200630122923.70282-1-mheyne@amazon.de> <20200630133358.GA20602@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630133358.GA20602@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 03:33:58PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 30, 2020 at 12:29:23PM +0000, Maximilian Heyne wrote:
> > Controller ID's (cntlid) for NVMe devices were introduced in version
> > 1.1.0 of the specification. Controllers that follow the older 1.0.0 spec
> > don't set this field so it doesn't make sense to validate it. On the
> > contrary, when using SR-IOV this check breaks VFs as they are all part
> > of the same NVMe subsystem.
> > 
> > Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
> > Cc: <stable@vger.kernel.org> # 5.4+
> 
> The first hunk looks ok, the second doesn't make sense as fabrics
> was only added with NVMe 1.2.2.  I can fix it up when applying if you
> are ok with that.
> 
> But you guys really shouldn't be doing SR-IOV with 1.0 controllers
> independent of this..

And actually - 1.0 did not have the concept of a subsystem.  So having
a duplicate serial number for a 1.0 controller actually is a pretty
nasty bug.  Can you point me to this broken controller?  Do you think
the OEM could fix it up to report a proper version number and controller
ID?
