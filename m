Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE9D197932
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 12:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgC3KWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 06:22:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40074 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgC3KWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 06:22:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id a81so21253753wmf.5;
        Mon, 30 Mar 2020 03:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4vIQEBciMld0vCiDFU9TfH/0TDdbnuRcouDz7FT+Dao=;
        b=fsu+c4P/6tAyRUitocVZp9kKKEf6AMJhKGDMC8AcCM0SLJnHTp6Vkuo+CbciFHwI6O
         8b5YYjEVg1p7uesi3fBhQiD9EFV0RMTZD+XbK98vRqVhJME6U8250HKlzukT6EWfIPSP
         aMq0QnRba9AtGeI7sleKPcXgqzOGkqwQO8LWgRj01yCEArGHZaHDAwmDNAjxheigoqoq
         6IepDnkxmRIosvbJWX9TD20zwOaaA7t7Gl0Tot+CPN3KNS+QknxKlhkyfsHk+Nc0l1qq
         AfsVvqbzy5kF1C2vUHLJSz7r42OD8ZqJXN4tWa47lb3X4xQVC1EZJEBBc+/CBCLP2lRT
         B4Qw==
X-Gm-Message-State: ANhLgQ3GQcYidWHrL5Qd6IoPT8ozmnkh8RuW03dDPCAVUudzdQg2Lbbk
        nehW2G9zBpaAm2uEfFqbTJo=
X-Google-Smtp-Source: ADFU+vuFweYk6OhehoyQZbg793z94p/aKZfJExcaGXCIEngab5qdWnPGnlE59M917AKIDjvsSPRFTQ==
X-Received: by 2002:a05:600c:4410:: with SMTP id u16mr12292810wmn.161.1585563724488;
        Mon, 30 Mar 2020 03:22:04 -0700 (PDT)
Received: from debian (44.142.6.51.dyn.plus.net. [51.6.142.44])
        by smtp.gmail.com with ESMTPSA id x11sm14972395wru.62.2020.03.30.03.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 03:22:03 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:22:01 +0100
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Tianyu Lan <ltykernel@gmail.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yubo Xie <yuboxie@microsoft.com>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        liuwe@microsoft.com, daniel.lezcano@linaro.org, tglx@linutronix.de,
        michael.h.kelley@microsoft.com, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH V2] x86/Hyper-V: Fix hv sched clock function return wrong
 time unit
Message-ID: <20200330102201.qs2ty22zxx2n53h3@debian>
References: <20200327021159.31429-1-Tianyu.Lan@microsoft.com>
 <87k13641rg.fsf@vitty.brq.redhat.com>
 <20200330100502.hh2yygyxctsmwd6o@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330100502.hh2yygyxctsmwd6o@debian>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 11:05:02AM +0100, Wei Liu wrote:
> On Fri, Mar 27, 2020 at 09:53:39AM +0100, Vitaly Kuznetsov wrote:
> > Tianyu Lan <ltykernel@gmail.com> writes:
> > 
> > > From: Yubo Xie <yuboxie@microsoft.com>
> > >
> > > sched clock callback should return time with nano second as unit
> > > but current hv callback returns time with 100ns. Fix it.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
> > > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > > Fixes: bd00cd52d5be ("clocksource/drivers/hyperv: Add Hyper-V specific sched clock function")
> > > ---
> > > Change since v1:
> > > 	Update fix commit number in change log. 
> > > ---
> > >  drivers/clocksource/hyperv_timer.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
> > > index 9d808d595ca8..662ed978fa24 100644
> > > --- a/drivers/clocksource/hyperv_timer.c
> > > +++ b/drivers/clocksource/hyperv_timer.c
> > > @@ -343,7 +343,8 @@ static u64 notrace read_hv_clock_tsc_cs(struct clocksource *arg)
> > >  
> > >  static u64 read_hv_sched_clock_tsc(void)
> > >  {
> > > -	return read_hv_clock_tsc() - hv_sched_clock_offset;
> > > +	return (read_hv_clock_tsc() - hv_sched_clock_offset)
> > > +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
> > >  }
> > >  
> > >  static void suspend_hv_clock_tsc(struct clocksource *arg)
> > > @@ -398,7 +399,8 @@ static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
> > >  
> > >  static u64 read_hv_sched_clock_msr(void)
> > >  {
> > > -	return read_hv_clock_msr() - hv_sched_clock_offset;
> > > +	return (read_hv_clock_msr() - hv_sched_clock_offset)
> > > +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
> > >  }
> > >  
> > >  static struct clocksource hyperv_cs_msr = {
> > 
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Queued for hyperv-fixes. Thank you both.

It appears Thomas already sent this to Linus, so I will drop this from
my branch.

Wei.

> 
> Wei.
