Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF87103BAE
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 14:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfKTNgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 08:36:54 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:54770 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729766AbfKTNgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 08:36:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TieLUG2_1574257006;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0TieLUG2_1574257006)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Nov 2019 21:36:46 +0800
Subject: Re: [GIT PULL 1/3] intel_th: Fix a double put_device() in error path
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
References: <20191120130806.44028-1-alexander.shishkin@linux.intel.com>
 <20191120130806.44028-2-alexander.shishkin@linux.intel.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
Message-ID: <2e648871-b7f7-c77e-6a22-3c26ad90633b@linux.alibaba.com>
Date:   Wed, 20 Nov 2019 21:36:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191120130806.44028-2-alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/11/20 9:08 下午, Alexander Shishkin wrote:
> Commit a753bfcfdb1f ("intel_th: Make the switch allocate its subdevices")
> factored out intel_th_subdevice_alloc() from intel_th_populate(), but got
> the error path wrong, resulting in two instances of a double put_device()
> on a freshly initialized, but not 'added' device.
>
> Fix this by only doing one put_device() in the error path.
>
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Fixes: a753bfcfdb1f ("intel_th: Make the switch allocate its subdevices")
> Reported-by: Wen Yang <wenyang@linux.alibaba.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: stable@vger.kernel.org # v4.14+
> ---
>   drivers/hwtracing/intel_th/core.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hwtracing/intel_th/core.c b/drivers/hwtracing/intel_th/core.c
> index d5c1821b31c6..0dfd97bbde9e 100644
> --- a/drivers/hwtracing/intel_th/core.c
> +++ b/drivers/hwtracing/intel_th/core.c
> @@ -649,10 +649,8 @@ intel_th_subdevice_alloc(struct intel_th *th,
>   	}
>   
>   	err = intel_th_device_add_resources(thdev, res, subdev->nres);
> -	if (err) {
> -		put_device(&thdev->dev);
> +	if (err)
>   		goto fail_put_device;
> -	}
>   
>   	if (subdev->type == INTEL_TH_OUTPUT) {
>   		if (subdev->mknode)
> @@ -667,10 +665,8 @@ intel_th_subdevice_alloc(struct intel_th *th,
>   	}
>   
>   	err = device_add(&thdev->dev);
> -	if (err) {
> -		put_device(&thdev->dev);
> +	if (err)
>   		goto fail_free_res;
> -	}
>   
>   	/* need switch driver to be loaded to enumerate the rest */
>   	if (subdev->type == INTEL_TH_SWITCH && !req) {
device_add() has increased the reference count,

so when it returns an error, an additional call to put_device()

is needed here to reduce the reference count.

--

Regards,

Wen


