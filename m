Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE600E845
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 19:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfD2RCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 13:02:23 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:54135 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbfD2RCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 13:02:23 -0400
Received: by mail-it1-f194.google.com with SMTP id z4so142795itc.3
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 10:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wL3BmO/NnA3NwafXMitsQjGpheHu4M8s6Xt8v0Jomo0=;
        b=s2AGHwV0MIipVuKm522AGWItowSBGgqT99tWc8KzjL140BVwLf0BNLJtwKT41jWXNL
         Ukof9nce0Cq6pB0k4RT6l+JJckq6LDo7dqUTee6F4HyesQwlrL6FccvupQpguUqjGpNE
         1LBkfc1FShajkH5kEmAjl9yf5FfYh/FTohBDK2bup5Dt8ctFaMV91kmiluhGT6lwpsIL
         XNYRY1uDKflHGrH3ShCan7broKF2mwu9hB3Nri6Yuhib2DH1pqwGFDg425K6uze853HA
         YqRV8YWIdZh09HQ/zO2TrNYOfMHz1jkmWpxyVCVGrCB7tP4XVQzYSYBc/qRxDOruKlp+
         OUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wL3BmO/NnA3NwafXMitsQjGpheHu4M8s6Xt8v0Jomo0=;
        b=qUOWTy/9Wt30KNf6zQIJIRnUAG719pB9uLoC66UCGa9q4gr3OC/ThS9xqXN7Mxf4d4
         KIu02XWoZVMetF9rBmtAn7m6upq3Roeql4G0FUFTUyktgphLGoJYL9JnWoCVLkKMXqhF
         qxAvzuiqH4K9f8OyaTKjeXECWKxIjtEbc9IrzKSDQLKNKXnZJHtFVLoW1fTdJKlIGAJ0
         iOJvXk5yzf2RRpDERWhkuhZxUyoEJqQHL/15Ifv1P6gR31+Agi1Wz/2tSuAs7bPd4umq
         qgrfUoqx2X1QjgH8iB2WtqVv7QrVFEtppQ4NqOyGjUmPdJVp4WznAc8FjWHvBHuXIaOW
         f/nQ==
X-Gm-Message-State: APjAAAUAgyxH57yODDATNK6qnky7+aadHggha6Mq9qvm+rLAIY+pE+Yn
        EA/Pd0Z3wgndGFSq59VU0lCs1w==
X-Google-Smtp-Source: APXvYqyy2Hy85tx6UOgrLCUuzqKRridrK87+eM70gRZqlE4r2DrU+rLIsbBcQp9QFi70TYGENQj11w==
X-Received: by 2002:a24:3602:: with SMTP id l2mr85415itl.68.1556557342335;
        Mon, 29 Apr 2019 10:02:22 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id w2sm9289032iot.33.2019.04.29.10.02.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Apr 2019 10:02:21 -0700 (PDT)
Date:   Mon, 29 Apr 2019 11:02:19 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Ross Zwisler <zwisler@chromium.org>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>,
        Jie Yang <yang.jie@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH] ASoC: Intel: avoid Oops if DMA setup fails
Message-ID: <20190429170219.GA89435@google.com>
References: <20190426164740.211139-1-zwisler@google.com>
 <0b030b85-00c8-2e35-3064-bb764aaff0f6@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b030b85-00c8-2e35-3064-bb764aaff0f6@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 26, 2019 at 04:03:47PM -0500, Pierre-Louis Bossart wrote:
> On 4/26/19 11:47 AM, Ross Zwisler wrote:
> > Currently in sst_dsp_new() if we get an error return from sst_dma_new()
> > we just print an error message and then still complete the function
> > successfully.  This means that we are trying to run without sst->dma
> > properly set up, which will result in NULL pointer dereference when
> > sst->dma is later used.  This was happening for me in
> > sst_dsp_dma_get_channel():
> > 
> >          struct sst_dma *dma = dsp->dma;
> > 	...
> >          dma->ch = dma_request_channel(mask, dma_chan_filter, dsp);
> > 
> > This resulted in:
> > 
> >     BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> >     IP: sst_dsp_dma_get_channel+0x4f/0x125 [snd_soc_sst_firmware]
> > 
> > Fix this by adding proper error handling for the case where we fail to
> > set up DMA.
> > 
> > Signed-off-by: Ross Zwisler <zwisler@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> >   sound/soc/intel/common/sst-firmware.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/sound/soc/intel/common/sst-firmware.c b/sound/soc/intel/common/sst-firmware.c
> > index 1e067504b6043..9be3a793a55e3 100644
> > --- a/sound/soc/intel/common/sst-firmware.c
> > +++ b/sound/soc/intel/common/sst-firmware.c
> > @@ -1251,11 +1251,15 @@ struct sst_dsp *sst_dsp_new(struct device *dev,
> >   		goto irq_err;
> >   	err = sst_dma_new(sst);
> > -	if (err)
> > +	if (err)  {
> >   		dev_warn(dev, "sst_dma_new failed %d\n", err);
> > +		goto dma_err;
> > +	}
> 
> Thanks for the patch.
> The fix looks correct, but does it make sense to keep a dev_warn() here?
> Should it be changed to dev_err() instead since as you mentioned it's fatal
> to keep going.
> Also you may want to mention in the commit message that this should only
> impact Broadwell and maybe the legacy Baytrail driver. IIRC we don't use the
> DMAs in other cases.

Sure, I'll address both of these in a v2.  Thank you for the quick review.
