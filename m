Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCE6597C5
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfF1JlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 05:41:24 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44265 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfF1JlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 05:41:24 -0400
Received: by mail-ot1-f65.google.com with SMTP id b7so5320750otl.11
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 02:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XRrEHx1uSB4yPDMUO/oxdWMhDCh65upcSfQGta3Ewhc=;
        b=Zyflk2jOVA4YyaZ24XP+l4S4Ys3pUX063Hs5TE0c2u+Z4Mlfgf6N93cfCcCDnw+ftt
         0qcpx0IEzM7HQM0rM0Jo60lPJkxhKkNtMaZQZwj+HaEWRKHDbLJFXzkMWzzrBIfnfR34
         Vcy9qak80ZQl+1fZgjGxvVvBIpzW3VRz0LvqdD3PCBGeK1HTLccmj2EwgR5tLOSzfiWY
         xeG83SJhse+T53UDv2UJTPrjpErfvrvdgWwxRlq3Q4HkELse+WSNjAIPwbBppvcjcNH8
         Vp+Y6XnC63N7lIj+CvPRmaSUZ6z0gxeubf3lP8Sgpn4lIoXH0u5lzWKuqr1wnDTdrHdm
         ojNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XRrEHx1uSB4yPDMUO/oxdWMhDCh65upcSfQGta3Ewhc=;
        b=qqHtEd+IVkM6tkuHNKF8BYxIsiU7lJCvK0gna0nxMa8LlIf4F6bnuv11pmsnqAa/1F
         JPhdQ2CSBGJru7EsojmA8zzzI+DvqJWIcq8zVOSmMv+8pOQWt9aebyBT6U+MaRMZYYaY
         oimNMDplTPaLWoJCLI+iajvsepwiIzUY21BFYnqcjb8VGnIy3NWDLM2c4Iv6B2JFFXCu
         wCg07BChqBJm0INWje5nkeykNRdtPeqFu/B3lpdmZ0c9ud3EQG7lZP4zwQm3wZnM4ymK
         VXjZ5ynJ3J9YtF2IbKUE1PfgVA7C4PowIOLnPxNudKCoSwRBAiGPDMWEMKG5zs7iQL6A
         sDNg==
X-Gm-Message-State: APjAAAUa/LuF3DWLKhNU4goXlEZonsS78C4gB3UWC5/NMLrrjN0ZvF5G
        lUF90NMHxO5vvDxbB897KhviEQ==
X-Google-Smtp-Source: APXvYqwbRmrDo7JZCH0qYUilB3Mr/tXlyAb2uuVOlGfumRJaR5DgDIt7c6RQOFKoLbf/3fXY1Ojr7w==
X-Received: by 2002:a9d:578c:: with SMTP id q12mr6906502oth.240.1561714883269;
        Fri, 28 Jun 2019 02:41:23 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li964-79.members.linode.com. [45.33.10.79])
        by smtp.gmail.com with ESMTPSA id m21sm568570otl.70.2019.06.28.02.41.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Jun 2019 02:41:22 -0700 (PDT)
Date:   Fri, 28 Jun 2019 17:41:16 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        coresight@lists.linaro.org, Sudeep Holla <sudeep.holla@arm.com>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Leach <mike.leach@linaro.org>
Subject: Re: [PATCH v2 2/5] coresight: etm4x: use explicit barriers on
 enable/disable
Message-ID: <20190628094116.GF32370@leoy-ThinkPad-X240s>
References: <20190627083525.37463-1-andrew.murray@arm.com>
 <20190627083525.37463-3-andrew.murray@arm.com>
 <20190628024529.GC20296@leoy-ThinkPad-X240s>
 <20190628083523.GG34530@e119886-lin.cambridge.arm.com>
 <20190628085154.GD32370@leoy-ThinkPad-X240s>
 <20190628090013.GI34530@e119886-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628090013.GI34530@e119886-lin.cambridge.arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

On Fri, Jun 28, 2019 at 10:00:14AM +0100, Andrew Murray wrote:
> On Fri, Jun 28, 2019 at 04:51:54PM +0800, Leo Yan wrote:
> > Hi Andrew,
> > 
> > On Fri, Jun 28, 2019 at 09:35:24AM +0100, Andrew Murray wrote:
> > 
> > [...]
> > 
> > > > > @@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
> > > > >  	control &= ~0x1;
> > > > >  
> > > > >  	/* make sure everything completes before disabling */
> > > > > -	mb();
> > > > > +	/* As recommended by 7.3.77 of ARM IHI 0064D */
> > > > > +	dsb(sy);
> > > > 
> > > > Here the old code should be right, mb() is the same thing with
> > > > dsb(sy).
> > > > 
> > > > So we don't need to change at here?
> > > 
> > > Correct - on arm64 there is no difference between mb and dsb(sy) so no
> > > functional change on this hunk.
> > > 
> > > In repsonse to Suzuki's feedback on this patch, I've updated the commit
> > > message to describe why I've made this change, as follows:
> > >      
> > > "On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
> > > only used on armv8 let's directly use dsb(sy) instead of mb(). This
> > > removes some ambiguity and makes it easier to correlate the code with
> > > the TRM."
> > > 
> > > Does that make sense?
> > 
> > On reason for preferring to use mb() rather than dsb(sy) is for
> > compatibility cross different architectures (armv7, armv8, and
> > so on ...).  Seems to me mb() is a general API and transparent for
> > architecture's difference.
> > 
> > dsb(sy) is quite dependent on specific Arm architecture, e.g. some old
> > Arm architecures might don't support dsb(sy); and we are not sure later
> > it will change for new architectures.
> 
> Yes but please note that the KConfig for this driver depends on ARM64.

Understood your point.

I am a bit suspect it's right thing to always set dependency on ARM64
for ETMv4 driver.  The reason is Armv8 CPU can also run with aarch32
mode in EL1.

If we let ETMv4 driver to support both aarch32 and aarch64, then we
will see dsb(sy) might break building for some old Arm arches.

Thanks,
Leo Yan
