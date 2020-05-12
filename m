Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC161CECCA
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 08:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgELGCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 02:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgELGCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 02:02:32 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A017F2072B;
        Tue, 12 May 2020 06:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589263352;
        bh=ZM6NpbvOfmNNVIasGwwWmLWrwf50JY2C08LxJCgUMH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R2Habxsh1A7W2vVdTlgZm4eUPJOukvTeexNtzGOfdWD4JQ22BxYHmQGZtGD6cpkCc
         8oXKyc7iXorwuqAeD2fCHgqHjAtPu/QsN4qWq7oC4+HrZqd6cTdh5xJNXh47SPRayF
         aHyXQcR2zYmThaEb/usTwmfQiHXg7YhOiXGokL1M=
Date:   Tue, 12 May 2020 09:02:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc or next 3/3] IB/qib: Call kobject_put() when
 kobject_init_and_add() fails
Message-ID: <20200512060228.GC4814@unreal>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031328.189865.48627.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512031328.189865.48627.stgit@awfm-01.aw.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 11:13:28PM -0400, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
>
> When kobject_init_and_add() returns an error in the function
> qib_create_port_files(), the function kobject_put() is not called for
> the corresponding kobject, which potentially leads to memory leak.
>
> This patch fixes the issue by calling kobject_put() even if
> kobject_init_and_add() fails. In addition, the ppd->diagc_kobj is
> released along with other kobjects when the sysfs is unregistered.
>
> Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Lin Yi <teroincn@gmail.com>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> ---
>  drivers/infiniband/hw/qib/qib_sysfs.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>

It is not "even if", the kobject_put() must be called if kobject_init_and_add() fails.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
