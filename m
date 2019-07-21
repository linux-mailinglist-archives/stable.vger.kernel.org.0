Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A096F458
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 19:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfGUR2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 13:28:02 -0400
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:40978 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfGUR2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 13:28:02 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id AABFF9E7484;
        Sun, 21 Jul 2019 18:27:59 +0100 (BST)
Date:   Sun, 21 Jul 2019 18:27:58 +0100
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 18/35] iio: iio-utils: Fix possible
 incorrect mask calculation
Message-ID: <20190721182758.1707edab@archlinux>
In-Reply-To: <20190719041423.19322-18-sashal@kernel.org>
References: <20190719041423.19322-1-sashal@kernel.org>
        <20190719041423.19322-18-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Jul 2019 00:14:06 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Bastien Nocera <hadess@hadess.net>
> 
> [ Upstream commit 208a68c8393d6041a90862992222f3d7943d44d6 ]
> 
> On some machines, iio-sensor-proxy was returning all 0's for IIO sensor
> values. It turns out that the bits_used for this sensor is 32, which makes
> the mask calculation:
> 
> *mask = (1 << 32) - 1;
> 
> If the compiler interprets the 1 literals as 32-bit ints, it generates
> undefined behavior depending on compiler version and optimization level.
> On my system, it optimizes out the shift, so the mask value becomes
> 
> *mask = (1) - 1;
> 
> With a mask value of 0, iio-sensor-proxy will always return 0 for every axis.
> 
> Avoid incorrect 0 values caused by compiler optimization.
> 
> See original fix by Brett Dutro <brett.dutro@gmail.com> in
> iio-sensor-proxy:
> https://github.com/hadess/iio-sensor-proxy/commit/9615ceac7c134d838660e209726cd86aa2064fd3
> 
> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
Good catch, I should have cc'd stable on this one.

Thanks,

Jonathan

> ---
>  tools/iio/iio_utils.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
> index 5eb6793f3972..2d0dcd6fc64c 100644
> --- a/tools/iio/iio_utils.c
> +++ b/tools/iio/iio_utils.c
> @@ -163,9 +163,9 @@ int iioutils_get_type(unsigned *is_signed, unsigned *bytes, unsigned *bits_used,
>  			*be = (endianchar == 'b');
>  			*bytes = padint / 8;
>  			if (*bits_used == 64)
> -				*mask = ~0;
> +				*mask = ~(0ULL);
>  			else
> -				*mask = (1ULL << *bits_used) - 1;
> +				*mask = (1ULL << *bits_used) - 1ULL;
>  
>  			*is_signed = (signchar == 's');
>  			if (fclose(sysfsfp)) {

