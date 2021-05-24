Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1526538E6DC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhEXMsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232371AbhEXMsd (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 24 May 2021 08:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB5661151;
        Mon, 24 May 2021 12:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621860425;
        bh=WnN5e9HfBPPWYgPqD1Fhg5WKyUN1eOAm3lsD5f24Pss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uMMdwjcFEOLAVn86AayckjUSwAXBzuff07zjlCabZ+sMc3PZYSJ1Be7JsAJ/OyWib
         bHmayxNTckn5NWx1NW4HHH+O3FN2QXTjLk99e7lKbj0xYH2eUyRvGtf/9nazWU2i0j
         JXmo4ORPc0msFX4K0gQ/LeLOFNMHKEJ+OiRKzzGM=
Date:   Mon, 24 May 2021 14:47:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Colin King <colin.king@canonical.com>
Cc:     kernel-janitors@vger.kernel.org, Stable@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: Re: [PATCH][4.9.y] iio: tsl2583: Fix division by a zero lux_val
Message-ID: <YKugR84xHxne6wox@kroah.com>
References: <20210520111552.27409-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520111552.27409-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 12:15:52PM +0100, Colin King wrote:
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
> [Colin Ian King: minor context adjustments for 4.9.y]
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/staging/iio/light/tsl2583.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

Now queued up, thanks.


greg k-
