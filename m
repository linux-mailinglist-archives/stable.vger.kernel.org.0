Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0BB21E7E4
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 08:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgGNGIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 02:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgGNGIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 02:08:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64EBF20890;
        Tue, 14 Jul 2020 06:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594706895;
        bh=+jF4wJzWGOkFcxEN3+EVfYYFbyhA0fxkfk7jHwiYYUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fyred2ckNXe78RZ4Q/Bixp2eohl9dQWhMKBLHKpDg0NwcXW7UotFwtMEIK8qEPqwx
         4QTrOmlX5g/rl149x43MlmoDfDLPPojqxEPttufcCSuP8J5j/BqIcBeTnW3eqKh5PM
         uQ54pTAhUb5fvdXb7frT0BN7Ye6dOCkL9lRxL3D8=
Date:   Tue, 14 Jul 2020 08:08:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org, dledford@redhat.com,
        jgg@ziepe.ca
Subject: Re: [PATCH 4.19] IB/umem: fix reference count leak in
 ib_umem_odp_get()
Message-ID: <20200714060813.GD657428@kroah.com>
References: <20200714105748.1151138-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714105748.1151138-1-yangyingliang@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 10:57:48AM +0000, Yang Yingliang wrote:
> Add missing mmput() on error path to avoid ref-count leak.
> 
> This problem has already been resolved in mainline by
> f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").
> 
> Fixes: 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

$ ./scripts/get_maintainer.pl --file drivers/infiniband/core/umem_odp.c
Doug Ledford <dledford@redhat.com> (supporter:INFINIBAND SUBSYSTEM)
Jason Gunthorpe <jgg@ziepe.ca> (supporter:INFINIBAND SUBSYSTEM,commit_signer:28/25=100%,authored:17/25=68%,added_lines:453/481=94%,removed_lines:662/722=92%)
Leon Romanovsky <leon@kernel.org> (commit_signer:16/25=64%)
Artemy Kovalyov <artemyko@mellanox.com> (commit_signer:4/25=16%)
Yishai Hadas <yishaih@mellanox.com> (commit_signer:3/25=12%,authored:3/25=12%)
Andrew Morton <akpm@linux-foundation.org> (commit_signer:2/25=8%)
Moni Shoua <monis@mellanox.com> (authored:2/25=8%)
linux-rdma@vger.kernel.org (open list:INFINIBAND SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

Any reason you ignored the mailing list for the whole IB developer
community?

And you need to make this REALLY obvious that this is a stable-tree-only
patch, for a specific kernel version (and why only that one version),
and a whole lot more description to allow everyone to know what is going
on, and what you expect them to review this for.

thanks,

greg k-h
