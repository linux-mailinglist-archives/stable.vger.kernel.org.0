Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89CD4983B1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238887AbiAXPja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:39:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32898 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbiAXPja (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:39:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8DC16149A
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8B9C340E1;
        Mon, 24 Jan 2022 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643038769;
        bh=SnQ+jWZvxdAuxKIQFMo20Lyk8m8bdQ1oW42zVJ9oLZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vKcQuQu1VdFF1DSVEFuS3xVbEhop3Pg4VSGze9MhV7UNk0HDtOaeJC+Soc00WFFWr
         a+laRV2QOQzGIfvXOfBpZA8C8dj9uHXiOkOk+uX5wmuMr/V+XEF1gG5boRD0BvfMP9
         CKmR/2DwrHEyG9xAOopjCY/R9Vup8eWxPFNnbcK8=
Date:   Mon, 24 Jan 2022 16:39:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 4.9,4.14] drm/ttm/nouveau: don't call tt destroy callback
 on alloc failure.
Message-ID: <Ye7ILinO8nBVjy/9@kroah.com>
References: <Ye7HB4Zsdbdwgt4T@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ye7HB4Zsdbdwgt4T@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 04:34:31PM +0100, Ben Hutchings wrote:
> From: Dave Airlie <airlied@redhat.com>
> 
> commit 5de5b6ecf97a021f29403aa272cb4e03318ef586 upstream.
> 
> This is confusing, and from my reading of all the drivers only
> nouveau got this right.
> 
> Just make the API act under driver control of it's own allocation
> failing, and don't call destroy, if the page table fails to
> create there is nothing to cleanup here.
> 
> (I'm willing to believe I've missed something here, so please
> review deeply).
> 
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20200728041736.20689-1-airlied@gmail.com
> [bwh: Backported to 4.14:
>  - Drop change in ttm_sg_tt_init()
>  - Adjust context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/gpu/drm/nouveau/nouveau_sgdma.c | 9 +++------
>  drivers/gpu/drm/ttm/ttm_tt.c            | 2 --
>  2 files changed, 3 insertions(+), 8 deletions(-)

Now queued up, thanks for the backport!

greg k-h
