Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC611D8A13
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 23:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgERVhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 17:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgERVhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 17:37:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A40E0205CB;
        Mon, 18 May 2020 21:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589837844;
        bh=EUyWXexSsbz75cYmX07WWKXWXKLhqB/4DeEQtFnWqlw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qclqy01Zzf4awU5/li0KjuAMvhHjWCiNdgctP3bwqEBf4vQJFfodBIGCpmPtFzRls
         Rvpj8Pp410HK9Dr1ImCBroRyEMQB6QHNwINSZ+RfX6901h45KISoZbKZC2f78tJ4Ww
         l3VS3req8WcMjQPEhnHcvBAcxvSoxI6iGRfJDQeQ=
Date:   Mon, 18 May 2020 14:37:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-media@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] rapidio: fix an error in get_user_pages_fast()
 error handling
Message-Id: <20200518143723.2c3159ddd53345b9cde5d869@linux-foundation.org>
In-Reply-To: <20200517235620.205225-2-jhubbard@nvidia.com>
References: <20200517235620.205225-1-jhubbard@nvidia.com>
        <20200517235620.205225-2-jhubbard@nvidia.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 17 May 2020 16:56:19 -0700 John Hubbard <jhubbard@nvidia.com> wrote:

> In the case of get_user_pages_fast() returning fewer pages than
> requested, rio_dma_transfer() does not quite do the right thing.
> It attempts to release all the pages that were requested, rather
> than just the pages that were pinned.
> 
> Fix the error handling so that only the pages that were successfully
> pinned are released.
> 
> ...
>
> --- a/drivers/rapidio/devices/rio_mport_cdev.c
> +++ b/drivers/rapidio/devices/rio_mport_cdev.c
> @@ -877,6 +877,11 @@ rio_dma_transfer(struct file *filp, u32 transfer_mode,
>  				rmcd_error("pinned %ld out of %ld pages",
>  					   pinned, nr_pages);
>  			ret = -EFAULT;
> +			/*
> +			 * Set nr_pages up to mean "how many pages to unpin, in
> +			 * the error handler:
> +			 */
> +			nr_pages = pinned;
>  			goto err_pg;
>  		}

The code is a bit odd.  If (xfer->loc_addr == 0) then we do the `else'
stuff then fall through to

err_pg:
	if (!req->page_list) {
		for (i = 0; i < nr_pages; i++)
			put_page(page_list[i]);
		kfree(page_list);
	}

all of which is a big no-op because nr_pages==0 and page_list==NULL,
but it could all be easily avoided.

Oh well.  Reviewed-by:me.
