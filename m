Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35A7389FE9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhETIgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230102AbhETIgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 04:36:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3286D60FF1;
        Thu, 20 May 2021 08:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621499728;
        bh=q+8wduanb4Jo4JMb/D1qBxfnNcKebB9UnUXN7kyOgQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xPTf54uFzMmW3XjRP2RQ04pxVBJVc/XfYCAHUClEKv98yrrFDGQj5zqBTUsqWwwPL
         DDD//0bT2BTLQYBr2oJCiQ/7IMr8/wU0TNjr2a5D8Du0uBPzm4EyPULttDT42ZDGNW
         Xzq1LMcm4uw1T7G6gfPxQuyP2NvJcMSQMNGJXd+A=
Date:   Thu, 20 May 2021 10:35:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH for 4.4, 4,9] iio: tsl2583: Fix division by a zero lux_val
Message-ID: <YKYfTmGyEO0xneX6@kroah.com>
References: <20210518032846.37859-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518032846.37859-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 12:28:46PM +0900, Nobuhiro Iwamatsu wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> commit af0e1871d79cfbb91f732d2c6fa7558e45c31038 upstream.
> 
> The lux_val returned from tsl2583_get_lux can potentially be zero,
> so check for this to avoid a division by zero and an overflowed
> gain_trim_val.
> 
> Fixes clang scan-build warning:
> 
> drivers/iio/light/tsl2583.c:345:40: warning: Either the
> condition 'lux_val<0' is redundant or there is division
> by zero at line 345. [zerodivcond]
> 
> Fixes: ac4f6eee8fe8 ("staging: iio: TAOS tsl258x: Device driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> [iwamatsu: Change file path.]
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/staging/iio/light/tsl2583.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

This only applied to 4.4.y, not 4.9.y, can you provide a new backport
for that tree?

thanks,

greg k-h
