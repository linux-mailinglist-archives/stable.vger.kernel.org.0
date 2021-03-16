Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE38D33D307
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 12:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCPL3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 07:29:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:4081 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234538AbhCPL3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 07:29:06 -0400
IronPort-SDR: o7nvgtrmyM3ZPCofWZvYYE3ZInSyE6gP5bvi6TeJhSoAxXgCfV4X2yt8Ok9fxw9so/56Cs8Rdo
 xS91BA3FTr+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="169158043"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="169158043"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 04:29:04 -0700
IronPort-SDR: rU0cdm0KON0LGWPyAtiNF90Ez+rLD7hoRZU/DnajYX4Ldn8a4NgoyrTFW2dKeBVDEtghHoyaay
 9o5s54ypAwcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="411018912"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.196]) ([10.238.232.196])
  by orsmga007.jf.intel.com with ESMTP; 16 Mar 2021 04:29:00 -0700
Subject: Re: [PATCH v2 1/2] media: staging/intel-ipu3: Fix memory leak in
 imu_fmt
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210315123406.1523607-1-ribalda@chromium.org>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <34c90095-bcbf-5530-786a-e709cc493fa9@linux.intel.com>
Date:   Tue, 16 Mar 2021 19:27:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210315123406.1523607-1-ribalda@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Ricardo

Thanks for your patch.
It looks fine for me, do you mind squash 2 patchsets into 1 commit?

On 3/15/21 8:34 PM, Ricardo Ribalda wrote:
> We are losing the reference to an allocated memory if try. Change the
> order of the check to avoid that.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6d5f26f2e045 ("media: staging/intel-ipu3-v4l: reduce kernel stack usage")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>  drivers/staging/media/ipu3/ipu3-v4l2.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
> index 60aa02eb7d2a..35a74d99322f 100644
> --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
> +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
> @@ -693,6 +693,13 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
>  		if (inode == IMGU_NODE_STAT_3A || inode == IMGU_NODE_PARAMS)
>  			continue;
>  
> +		/* CSS expects some format on OUT queue */
> +		if (i != IPU3_CSS_QUEUE_OUT &&
> +		    !imgu_pipe->nodes[inode].enabled) {
> +			fmts[i] = NULL;
> +			continue;
> +		}
> +
>  		if (try) {
>  			fmts[i] = kmemdup(&imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp,
>  					  sizeof(struct v4l2_pix_format_mplane),
> @@ -705,10 +712,6 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
>  			fmts[i] = &imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
>  		}
>  
> -		/* CSS expects some format on OUT queue */
> -		if (i != IPU3_CSS_QUEUE_OUT &&
> -		    !imgu_pipe->nodes[inode].enabled)
> -			fmts[i] = NULL;
>  	}
>  
>  	if (!try) {
> 

-- 
Best regards,
Bingbu Cao
