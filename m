Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB14347FCAC
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 13:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhL0Mg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 07:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbhL0Mg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 07:36:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35137C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 04:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA04860FE4
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D771C36AEA;
        Mon, 27 Dec 2021 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640608585;
        bh=ITfzj1LO0ygcCY1CtNef6k3OVW8DLR3sNb5K5lGTgDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PDtPePvpq53Hq8x1AhYiod+dtz9TRIcSMkZS6OUV2T6RUo69b+nZTicctHyxgdGby
         932MGyRw+DmUjxxfP5uQGbQLIxH/U6uslaCHjuguqkKFb+zF81ACqutOz+RLqz8KrY
         dFWKmUSmMuItPrskECgNWGn8HjiAN2mRMPsQ1am8=
Date:   Mon, 27 Dec 2021 13:36:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     stable@vger.kernel.org, jens.wiklander@linaro.org,
        patrik.lantz@axis.com, tyhicks@linux.microsoft.com
Subject: Re: [PATCH backport for 5.4/5.10/5.15] tee: optee: Fix incorrect
 page free bug
Message-ID: <YcmzRuKwe4CY0EdG@kroah.com>
References: <20211227121432.2694129-1-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227121432.2694129-1-sumit.garg@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 05:44:32PM +0530, Sumit Garg wrote:
> commit 18549bf4b21c739a9def39f27dcac53e27286ab5 upstream.
> 
> Pointer to the allocated pages (struct page *page) has already
> progressed towards the end of allocation. It is incorrect to perform
> __free_pages(page, order) using this pointer as we would free any
> arbitrary pages. Fix this by stop modifying the page pointer.
> 
> Fixes: ec185dd3ab25 ("optee: Fix memory leak when failing to register shm pages")
> Cc: stable@vger.kernel.org
> Reported-by: Patrik Lantz <patrik.lantz@axis.com>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> [SG: Backport for stable kernels]
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  drivers/tee/optee/shm_pool.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Now queued up, thanks.

greg k-h
