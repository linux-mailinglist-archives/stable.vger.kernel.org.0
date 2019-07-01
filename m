Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B1C5B883
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 11:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfGAJ7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 05:59:20 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42901 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbfGAJ7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 05:59:20 -0400
Received: by mail-oi1-f193.google.com with SMTP id s184so9456290oie.9
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 02:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zJ1eCqybR6XBDa3xMqEmhEU7kRa806a7wltOX8SiK1E=;
        b=Img0Pav5pdGVOal2OPYiuiF+ozFL6PDQsvm+tSDEOJ39/1ug//jFIEp4R97AHMGedS
         MBD+FyKb5hf+nz1oJ/L4rBvtKuBmFhsxW4ulJMJ93tHMLZMUfg4370PIplJC7mx186sW
         4TfYSKAIVKNV7gHoP8I2Yn4tTGY+uEGjJ9gzwgzBHTBgG2oNFK8OXfdvJJPS3lJBO32R
         pRksTU3sxQ1y636HuyCVuAwgRlZqNCdCOi1kCJzmvDLrx5bc71EckHpNNSIhoEeJnMQ3
         yoOfmO4V9xkAErOH2tA9TnER0MWkGYPT68wyol5j1jZzXTWW83v0zo4y1vFcs1Fem1Mg
         is0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zJ1eCqybR6XBDa3xMqEmhEU7kRa806a7wltOX8SiK1E=;
        b=ORN4ekSdBabh7nlCgNITu7OsPpYyzxlxkutu59Tcc3l32HXESe9s27DSinr6bgWlDG
         Ef3j/cGPWxV1p6KLAIZnmxhUxg+os5lqbgKL9eeQhA7x8w+69rQnEmYWIATQCqe1bnMJ
         /XkZ5c+TpWGZ+PLBn8RJGh3xKj3zhxO3L8zs0EC16u4O2jiKw/L8pSVKodlZ0VOlcB1l
         t4O4gQI1uLVw7v7H7xJChND5NbUCxMH5W3ZKveBik/urC+EDSrmoTFHPnmh46s/tD1+j
         ZZOiUaVDd13/Ir5UNOMi5V6OWBO2zvbieygWqdtd/9iRwIsZqKOXzg0r/KfaZEjxlPJE
         Z4IA==
X-Gm-Message-State: APjAAAUSBJCcZ07xSjrsG3bn5KNcrFL90taJtJ/50TTmYKbCt0LusIHR
        5t2UrzDtkdW5eQDT1iMqSvz0CA==
X-Google-Smtp-Source: APXvYqwuzxYxvAyr6Pwp7jk4NOSZbMD9VdMPR6CLCUueq3LidiHNe8WNZ6Gl1AMTFZjImE8teVbY7g==
X-Received: by 2002:aca:37c5:: with SMTP id e188mr6133417oia.66.1561975159282;
        Mon, 01 Jul 2019 02:59:19 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li964-79.members.linode.com. [45.33.10.79])
        by smtp.gmail.com with ESMTPSA id r25sm3999683otq.39.2019.07.01.02.59.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Jul 2019 02:59:18 -0700 (PDT)
Date:   Mon, 1 Jul 2019 17:59:10 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     andrew.murray@arm.com, mathieu.poirier@linaro.org,
        alexander.shishkin@linux.intel.com, coresight@lists.linaro.org,
        Sudeep.Holla@arm.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mike.leach@linaro.org
Subject: Re: [PATCH v2 2/5] coresight: etm4x: use explicit barriers on
 enable/disable
Message-ID: <20190701095910.GC32042@leoy-ThinkPad-X240s>
References: <20190627083525.37463-1-andrew.murray@arm.com>
 <20190627083525.37463-3-andrew.murray@arm.com>
 <20190628024529.GC20296@leoy-ThinkPad-X240s>
 <20190628083523.GG34530@e119886-lin.cambridge.arm.com>
 <20190628085154.GD32370@leoy-ThinkPad-X240s>
 <20190628090013.GI34530@e119886-lin.cambridge.arm.com>
 <20190628094116.GF32370@leoy-ThinkPad-X240s>
 <ff3c3659-930a-1572-588b-9cb040f38e4f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff3c3659-930a-1572-588b-9cb040f38e4f@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Suzuki,

On Mon, Jul 01, 2019 at 09:58:29AM +0100, Suzuki K Poulose wrote:
> Hi Leo,
> 
> On 28/06/2019 10:41, Leo Yan wrote:
> > Hi Andrew,
> > 
> > On Fri, Jun 28, 2019 at 10:00:14AM +0100, Andrew Murray wrote:
> > > On Fri, Jun 28, 2019 at 04:51:54PM +0800, Leo Yan wrote:
> > > > Hi Andrew,
> > > > 
> > > > On Fri, Jun 28, 2019 at 09:35:24AM +0100, Andrew Murray wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > > > @@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
> > > > > > >   	control &= ~0x1;
> > > > > > >   	/* make sure everything completes before disabling */
> > > > > > > -	mb();
> > > > > > > +	/* As recommended by 7.3.77 of ARM IHI 0064D */
> > > > > > > +	dsb(sy);
> > > > > > 
> > > > > > Here the old code should be right, mb() is the same thing with
> > > > > > dsb(sy).
> > > > > > 
> > > > > > So we don't need to change at here?
> > > > > 
> > > > > Correct - on arm64 there is no difference between mb and dsb(sy) so no
> > > > > functional change on this hunk.
> > > > > 
> > > > > In repsonse to Suzuki's feedback on this patch, I've updated the commit
> > > > > message to describe why I've made this change, as follows:
> > > > > "On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
> > > > > only used on armv8 let's directly use dsb(sy) instead of mb(). This
> > > > > removes some ambiguity and makes it easier to correlate the code with
> > > > > the TRM."
> > > > > 
> > > > > Does that make sense?
> > > > 
> > > > On reason for preferring to use mb() rather than dsb(sy) is for
> > > > compatibility cross different architectures (armv7, armv8, and
> > > > so on ...).  Seems to me mb() is a general API and transparent for
> > > > architecture's difference.
> > > > 
> > > > dsb(sy) is quite dependent on specific Arm architecture, e.g. some old
> > > > Arm architecures might don't support dsb(sy); and we are not sure later
> > > > it will change for new architectures.
> > > 
> > > Yes but please note that the KConfig for this driver depends on ARM64.
> > 
> > Understood your point.
> > 
> > I am a bit suspect it's right thing to always set dependency on ARM64
> > for ETMv4 driver.  The reason is Armv8 CPU can also run with aarch32
> > mode in EL1.
> > 
> > If we let ETMv4 driver to support both aarch32 and aarch64, then we
> > will see dsb(sy) might break building for some old Arm arches.
> 
> If we add support for ETMv4 on aarch32, I would recommend adding a "dsb"
> explicitly for aarch32 to make sure, it doesn't default to something else
> that the mb() may cover up as.

For aarch32, mb() should work well with below definition:

#ifdef CONFIG_ARM_HEAVY_MB
#define __arm_heavy_mb(x...) do { dsb(x); arm_heavy_mb(); } while (0)
#else
#define __arm_heavy_mb(x...) dsb(x)
#endif

#if defined(CONFIG_ARM_DMA_MEM_BUFFERABLE) || defined(CONFIG_SMP)
#define mb()		__arm_heavy_mb()
#else
#define mb()		barrier()
#endif

> There is no point in creating another level
> of indirection when the architecture is clear about it and the ETMv4 supporting
> architectures must implement "dsb". Had this been in a generic code, I would
> be happy to retain mb(). But this is specific to the ETMv4 driver and we know
> that dsb must be there.

Okay, I understand the purpose for more explict barrier in the code;
this would be fine for me.

Thanks,
Leo Yan
