Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49119201647
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394939AbgFSQ2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:28:50 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2345 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389951AbgFSQ22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 12:28:28 -0400
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 562AE804842AEAABF565;
        Fri, 19 Jun 2020 17:28:24 +0100 (IST)
Received: from localhost (10.52.127.178) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 19 Jun
 2020 17:28:23 +0100
Date:   Fri, 19 Jun 2020 17:27:33 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        <linux-iio@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.4 23/60] iio: buffer: Don't allow buffers
 without any channels enabled to be activated
Message-ID: <20200619172733.00005d9d@Huawei.com>
In-Reply-To: <20200618013004.610532-23-sashal@kernel.org>
References: <20200618013004.610532-1-sashal@kernel.org>
        <20200618013004.610532-23-sashal@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.127.178]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Jun 2020 21:29:27 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Lars-Peter Clausen <lars@metafoo.de>
> 
> [ Upstream commit b7329249ea5b08b2a1c2c3f24a2f4c495c4f14b8 ]
> 
> Before activating a buffer make sure that at least one channel is enabled.
> Activating a buffer with 0 channels enabled doesn't make too much sense and
> disallowing this case makes sure that individual driver don't have to add
> special case code to handle it.
> 
> Currently, without this patch enabling a buffer is possible and no error is
> produced. With this patch -EINVAL is returned.
> 
> An example of execution with this patch and some instrumented print-code:
>    root@analog:~# cd /sys/bus/iio/devices/iio\:device3/buffer
>    root@analog:/sys/bus/iio/devices/iio:device3/buffer# echo 1 > enable
>    0: iio_verify_update 748 indio_dev->masklength 2 *insert_buffer->scan_mask 00000000
>    1: iio_verify_update 753
>    2:__iio_update_buffers 1115 ret -22
>    3: iio_buffer_store_enable 1241 ret -22
>    -bash: echo: write error: Invalid argument
> 1, 2 & 3 are exit-error paths. 0 the first print in iio_verify_update()
> rergardless of error path.
> 
> Without this patch (and same instrumented print-code):
>    root@analog:~# cd /sys/bus/iio/devices/iio\:device3/buffer
>    root@analog:/sys/bus/iio/devices/iio:device3/buffer# echo 1 > enable
>    0: iio_verify_update 748 indio_dev->masklength 2 *insert_buffer->scan_mask 00000000
>    root@analog:/sys/bus/iio/devices/iio:device3/buffer#
> Buffer is enabled with no error.
> 
> Note from Jonathan: Probably not suitable for automatic application to stable.
> This has been there from the very start.  It tidies up an odd corner
> case but won't effect any 'real' users.
> 

As noted. I don't think it matters if we do apply this to stable.
It closes an interface oddity rather than an actual known bug.

> Fixes: 84b36ce5f79c0 ("staging:iio: Add support for multiple buffers")
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/industrialio-buffer.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
> index 864a61b05665..fea41b328ab9 100644
> --- a/drivers/iio/industrialio-buffer.c
> +++ b/drivers/iio/industrialio-buffer.c
> @@ -641,6 +641,13 @@ static int iio_verify_update(struct iio_dev *indio_dev,
>  	bool scan_timestamp;
>  	unsigned int modes;
>  
> +	if (insert_buffer &&
> +	    bitmap_empty(insert_buffer->scan_mask, indio_dev->masklength)) {
> +		dev_dbg(&indio_dev->dev,
> +			"At least one scan element must be enabled first\n");
> +		return -EINVAL;
> +	}
> +
>  	memset(config, 0, sizeof(*config));
>  
>  	/*


