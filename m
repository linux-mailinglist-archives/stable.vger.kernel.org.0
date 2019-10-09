Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31495D1B69
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 00:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbfJIWKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 18:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbfJIWKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 18:10:43 -0400
Received: from washi1.fujisawa.hgst.com (unknown [199.255.47.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C11220B7C;
        Wed,  9 Oct 2019 22:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570659042;
        bh=FQuEaTociCoUgYX9UFpVgH54MWKMMymSTxWUZxJ3XnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fibYmpksKxqucYFycti50RMvVKSZpgpVeNGsXVejp7ozcybU6EPbMZJj/TesW1zp/
         rLinlU5KdG5NhfECZx5qasQhFPVkQYKAWUEbSyQfs+497PpuxN2fwXGcP1Gix+UsIA
         bP91b+3hQqm55EMjmOaxmbZNr2wq4nhMRlga8JQY=
Date:   Thu, 10 Oct 2019 07:10:38 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        Minwoo Im <minwoo.im@samsung.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 4.19] nvme: Assign subsys instance from first ctrl
Message-ID: <20191009221038.GA3009@washi1.fujisawa.hgst.com>
References: <20191009162910.1801-1-kbusch@kernel.org>
 <20191009215504.GW1396@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009215504.GW1396@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 05:55:04PM -0400, Sasha Levin wrote:
> On Thu, Oct 10, 2019 at 01:29:10AM +0900, Keith Busch wrote:
> > commit 733e4b69d508d03c20adfdcf4bd27abc60fae9cc upstream
> > 
> > The namespace disk names must be unique for the lifetime of the
> > subsystem. This was accomplished by using their parent subsystems'
> > instances which were allocated independently from the controllers
> > connected to that subsystem. This allowed name prefixes assigned to
> > namespaces to match a controller from an unrelated subsystem, and has
> > created confusion among users examining device nodes.
> > 
> > Ensure a namespace's subsystem instance never clashes with a controller
> > instance of another subsystem by transferring the instance ownership
> > to the parent subsystem from the first controller discovered in that
> > subsystem.
> > 
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Minwoo Im <minwoo.im@samsung.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.com>
> > Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> 
> What are your thoughts about taking the following for 4.19 instead?
> 
> 733e4b69d508d nvme: Assign subsys instance from first ctrl
> e654dfd38c1ec nvme: fix memory leak caused by incorrect subsystem free
> 32fd90c407680 nvme: change locking for the per-subsystem controller list
> 092ff0520070f nvme: fix kernel paging oops
> cb5b7262b011c nvme: provide fallback for discard alloc failure

Thank you for the suggestion. I have reviewed the proposed sequence, and
I would prefer to use this for stable instead of this back-ported patch.
 
> --
> Thanks,
> Sasha
