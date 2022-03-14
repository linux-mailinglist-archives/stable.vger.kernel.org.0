Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC174D8BD4
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 19:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbiCNSgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 14:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243905AbiCNSgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 14:36:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35493EA9D;
        Mon, 14 Mar 2022 11:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647282907; x=1678818907;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uGjJrAPj26i3gB3nwOfJJbnYbtIQpt9SBZFoTdHol64=;
  b=bj3lfT0iVvrBdTspiXL76aWJ6duyO0exReN8EWMzMaz7byw3JnyLa4Lm
   tfxRBMG42n+jd7OKkJbHoVtN27VL3XMToWF9XH0Zzy+HWQMtNqYqzaUXS
   inQS8p7Jth0kqDrRPbjpnrMBp95OPkxqI1xiif4IfPlXBQxFr03l4epWs
   NOA9dLr5thOxhvZ8xZKDtBB9LqnelFbT8peMkU4Rx8OOqJMy5j9C5Vsx0
   WR9upS/99yONGjd5TzCFt0rr+iN+0eL98CTdBfG6BlG+ghsjgDg9TXh0G
   eLSTkAUPIHsGBV+q3J3alPKnAlYcd6Ur6CBiNh/tCc8k0UinHDlucF5Qs
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256067006"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="256067006"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:35:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="713849153"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:35:07 -0700
Message-ID: <00654dae7f6b95533a66055ea125ddb640efd7fd.camel@linux.intel.com>
Subject: Re: [PATCH] thermal: int340x: Increase bitmap size
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "amitk@kernel.org" <amitk@kernel.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>
Cc:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matthewgarrett@google.com" <matthewgarrett@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Mon, 14 Mar 2022 11:35:07 -0700
In-Reply-To: <c23d75b4e9164094bcc488c0ba9e0d77@AcuMS.aculab.com>
References: <20220314145017.928550-1-srinivas.pandruvada@linux.intel.com>
         <c23d75b4e9164094bcc488c0ba9e0d77@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-03-14 at 15:28 +0000, David Laight wrote:
> From: Srinivas Pandruvada
> > Sent: 14 March 2022 14:50
> > 
> > The number of policies are 10, so can't be supported by the bitmap
> > size
> > of u8. Even though there are no platfoms with these many policies,
> > but
> > as correctness increase to u16.
> 
> You might as well just use 'unsigned int'.
> May generate better code and there is still padding
> in the structure.
Correct. I can update the patch.

Thanks,
Srinivas

> 
>         David
> 
> > 
> > Signed-off-by: Srinivas Pandruvada <
> > srinivas.pandruvada@linux.intel.com>
> > Fixes: 16fc8eca1975 ("thermal/int340x_thermal: Add additional
> > UUIDs")
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git
> > a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> > b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> > index 72acb1f61849..c2d3df302214 100644
> > --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> > +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> > @@ -53,7 +53,7 @@ struct int3400_thermal_priv {
> >         struct art *arts;
> >         int trt_count;
> >         struct trt *trts;
> > -       u8 uuid_bitmap;
> > +       u16 uuid_bitmap;
> >         int rel_misc_dev_res;
> >         int current_uuid_index;
> >         char *data_vault;
> > --
> > 2.31.1
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
> MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 


