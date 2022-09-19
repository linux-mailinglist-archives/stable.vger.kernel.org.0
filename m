Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F45BC271
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 07:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiISFMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 01:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiISFMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 01:12:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2036E1ADAE;
        Sun, 18 Sep 2022 22:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663564363; x=1695100363;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TK+uOfCqtjxOwrtXY/qUnGfyOWvcOwn1Cd85+GtTggI=;
  b=Fg89/ou5DGBv/JfV2G8kCuI4fb9uQDzqHl58cSi1VmboqPel1FPtRfB4
   a5MXT/FIAlCRhKyEqWpnMLvIpjhKgi1S+b3nWzcv1Oo+tGxA5GMWe8dry
   4L6YIrnmErFTQbS7N7ZYb+JIXhE3Rn22Kf+dC4RhM8fLB8ZnfY88WXeyk
   7nKlwO1tYEzQ4iP3RlwWJQhqp4l0L3XYI/5iKifV0pYxN9rjbHcqJKwNr
   Hs+oLOj98PNKf0ZIN/seqm8nzxhr8RHWqRwjxafVHgtkCepj1BmrYTxvA
   eiLVErNumD3R2GgU4dwQz8A0wQuJiOwsjhtuwM6rZGGSh5vttT08NE1Nd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10474"; a="299298753"
X-IronPort-AV: E=Sophos;i="5.93,325,1654585200"; 
   d="scan'208";a="299298753"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2022 22:12:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,325,1654585200"; 
   d="scan'208";a="595937514"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orsmga006.jf.intel.com with ESMTP; 18 Sep 2022 22:12:39 -0700
Date:   Mon, 19 Sep 2022 13:02:59 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Tom Rix <trix@redhat.com>
Cc:     Russ Weight <russell.h.weight@intel.com>, mdf@kernel.org,
        hao.wu@intel.com, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgoncalv@redhat.com,
        marpagan@redhat.com, matthew.gerlach@linux.intel.com,
        basheer.ahmed.muddebihal@intel.com, tianfei.zhang@intel.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 1/1] fpga: m10bmc-sec: Fix possible memory leak of
 flash_buf
Message-ID: <Yyf4AwlHMKuna/pY@yilunxu-OptiPlex-7050>
References: <20220916235205.106873-1-russell.h.weight@intel.com>
 <f1e92634-8f96-6a3b-52e9-e83fa879ca39@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1e92634-8f96-6a3b-52e9-e83fa879ca39@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-09-16 at 17:20:43 -0700, Tom Rix wrote:
> 
> On 9/16/22 4:52 PM, Russ Weight wrote:
> > There is an error check following the allocation of flash_buf that returns
> > without freeing flash_buf. It makes more sense to do the error check
> > before the allocation and the reordering eliminates the memory leak.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Fixes: 154afa5c31cd ("fpga: m10bmc-sec: expose max10 flash update count")
> > Signed-off-by: Russ Weight <russell.h.weight@intel.com>
> Reviewed-by: Tom Rix <trix@redhat.com>

Acked-by: Xu Yilun <yilun.xu@intel.com>

Applied to for-6.0

> > Cc: <stable@vger.kernel.org>
> > ---
> >   drivers/fpga/intel-m10-bmc-sec-update.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/fpga/intel-m10-bmc-sec-update.c b/drivers/fpga/intel-m10-bmc-sec-update.c
> > index 526c8cdd1474..79d48852825e 100644
> > --- a/drivers/fpga/intel-m10-bmc-sec-update.c
> > +++ b/drivers/fpga/intel-m10-bmc-sec-update.c
> > @@ -148,10 +148,6 @@ static ssize_t flash_count_show(struct device *dev,
> >   	stride = regmap_get_reg_stride(sec->m10bmc->regmap);
> >   	num_bits = FLASH_COUNT_SIZE * 8;
> > -	flash_buf = kmalloc(FLASH_COUNT_SIZE, GFP_KERNEL);
> > -	if (!flash_buf)
> > -		return -ENOMEM;
> > -
> >   	if (FLASH_COUNT_SIZE % stride) {
> >   		dev_err(sec->dev,
> >   			"FLASH_COUNT_SIZE (0x%x) not aligned to stride (0x%x)\n",
> > @@ -160,6 +156,10 @@ static ssize_t flash_count_show(struct device *dev,
> >   		return -EINVAL;
> >   	}
> > +	flash_buf = kmalloc(FLASH_COUNT_SIZE, GFP_KERNEL);
> > +	if (!flash_buf)
> > +		return -ENOMEM;
> > +
> >   	ret = regmap_bulk_read(sec->m10bmc->regmap, STAGING_FLASH_COUNT,
> >   			       flash_buf, FLASH_COUNT_SIZE / stride);
> >   	if (ret) {
> 
