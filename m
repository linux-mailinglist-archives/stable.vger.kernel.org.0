Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074EF15F8A0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgBNVSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:18:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgBNVSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:18:33 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDD05217F4;
        Fri, 14 Feb 2020 21:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581715113;
        bh=ig2NjpTUXj6zIXreiL9OrWWT2JOn4xKGSwQ8cZgt/m8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KmTQNCgJw9ScKsu5Eje8pr4d0zFr0vJeFmFbIn8OEFeqSnqtTQV52o6CSRRIFTZ/y
         1OrBufmlczk4QAvEmgvyj/FftBAUvH2y220FEUNN4CDhLAGC+WXWrrgo/NRytQswGA
         KBXq0+AB6xIonBrDSg3gzbtd66vnDfDZ1sVwLQIw=
Date:   Fri, 14 Feb 2020 16:17:18 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH for 4.19-stable] padata: fix null pointer deref of
 pd->pinst
Message-ID: <20200214211718.GD4087988@kroah.com>
References: <20200214182821.337706-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214182821.337706-1-daniel.m.jordan@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 01:28:21PM -0500, Daniel Jordan wrote:
> The 4.19 backport dc34710a7aba ("padata: Remove broken queue flushing")
> removed padata_alloc_pd()'s assignment to pd->pinst, resulting in:
> 
>     Unable to handle kernel NULL pointer dereference ...
>     ...
>     pc : padata_reorder+0x144/0x2e0
>     ...
>     Call trace:
>      padata_reorder+0x144/0x2e0
>      padata_do_serial+0xc8/0x128
>      pcrypt_aead_enc+0x60/0x70 [pcrypt]
>      padata_parallel_worker+0xd8/0x138
>      process_one_work+0x1bc/0x4b8
>      worker_thread+0x164/0x580
>      kthread+0x134/0x138
>      ret_from_fork+0x10/0x18
> 
> This happened because the backport was based on an enhancement that
> moved this assignment but isn't in 4.19:
> 
>   bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")
> 
> Simply restore the assignment to fix the crash.
> 
> Fixes: dc34710a7aba ("padata: Remove broken queue flushing")
> Reported-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  kernel/padata.c | 1 +
>  1 file changed, 1 insertion(+)

Thanks for this, now queued up.

greg k-h
