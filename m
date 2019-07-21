Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E0A6F453
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 19:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfGUR1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 13:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfGUR1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 13:27:17 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB4320578;
        Sun, 21 Jul 2019 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563730036;
        bh=+UiPDYtkHRTWbty+sAOnSmMguCB2WGQPTjyFBuojhMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=znv4LoeGaAPaZvSU/lq+SGhO1S6KvgslHjEJ43whRA6oxj3a+m3Bf3YSGiypArGZE
         Cakp7ecFMYSAcxJ9bIZ/KBJOxdlDvLz/Q0R5mOl2KEWjfxVVhQz3vP0OjS23O6U+bx
         Pngd/ZvVXg4dnwJZ0WlajuXNbowfi6mF1WpZceAA=
Date:   Sun, 21 Jul 2019 18:27:02 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Young Xiao <92siuyang@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 19/60] iio:core: Fix bug in length of event
 info_mask and catch unhandled bits set in masks.
Message-ID: <20190721182643.3fd0515b@archlinux>
In-Reply-To: <20190719041109.18262-19-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
        <20190719041109.18262-19-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Jul 2019 00:10:28 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Young Xiao <92siuyang@gmail.com>
> 
> [ Upstream commit 936d3e536dcf88ce80d27bdb637009b13dba6d8c ]
> 
> The incorrect limit for the for_each_set_bit loop was noticed whilst fixing
> this other case.  Note that as we only have 3 possible entries a the moment
> and the value was set to 4, the bug would not have any effect currently.
> It will bite fairly soon though, so best fix it now.
> 
> See commit ef4b4856593f ("iio:core: Fix bug in length of event info_mask and
> catch unhandled bits set in masks.") for details.
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

As the patch states, this bug doesn't have any impact.  It would only
be triggered by a buggy driver setting a bit in that mask that makes no
sense.

So it's good to fix in upstream, but debatable if it's worth porting back
to stable.

I don't have a strong opinion on this one and again, it should do no
harm.

Jonathan

> ---
>  drivers/iio/industrialio-core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 97b7266ee0ff..b0f952984983 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -1116,6 +1116,8 @@ static int iio_device_add_info_mask_type_avail(struct iio_dev *indio_dev,
>  	char *avail_postfix;
>  
>  	for_each_set_bit(i, infomask, sizeof(*infomask) * 8) {
> +		if (i >= ARRAY_SIZE(iio_chan_info_postfix))
> +			return -EINVAL;
>  		avail_postfix = kasprintf(GFP_KERNEL,
>  					  "%s_available",
>  					  iio_chan_info_postfix[i]);

