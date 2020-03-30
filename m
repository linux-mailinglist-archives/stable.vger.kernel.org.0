Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74633197849
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 12:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgC3KFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 06:05:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44164 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgC3KFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 06:05:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id m17so20791481wrw.11;
        Mon, 30 Mar 2020 03:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6pTdh72K+oEbDLs+fVgY5joQamAwAbVgJ6t2Gfp85/k=;
        b=OZSYnyELIN2Ek9FZmgq4jp8iwrkwvsXmY+LkkZ2dXYOodyn9WXgmzznGJo2uhMn0Tr
         7xr1gVrifoDeI8wV+YkUWM0mvg23AG8WINzk5W0vv18yB0MFKvKbumR/SJog3t56Ra1e
         adFCI1AEOWWjyMmCCmqkwWFvEMzqSX9dOHY9TyrImvoQGQEZimRjCuwzKtwAPC4j0lXc
         wtQ72Q8/9r55ZOnWMb2NGCBMZFP1Qf02TouwOU6Wp5qTxeMmTt8v2Zu3QIeMwZ4PcKhu
         PGKOPGDnMMw2HzEiTqQ3rv+CflZ8FL3ntwLNnD7P/461sgs3VXorDDI6W+4u3VCMg3aG
         GfAQ==
X-Gm-Message-State: ANhLgQ29xoLOoUUIxccfTTiTC3cubPUfQkMNzEz+yjmkVPvY+nb8TbC0
        2UxzFFQEY5tIUs4KHNYQdg4=
X-Google-Smtp-Source: ADFU+vuRmk+jLE95xL4mOYgXGEzAnx6j18AN4LYyrxsu70PapIZdpFsEbRbrhlB4S01at2jI8U7ZMQ==
X-Received: by 2002:adf:dfce:: with SMTP id q14mr14694534wrn.326.1585562705638;
        Mon, 30 Mar 2020 03:05:05 -0700 (PDT)
Received: from debian (44.142.6.51.dyn.plus.net. [51.6.142.44])
        by smtp.gmail.com with ESMTPSA id a10sm13190153wrm.87.2020.03.30.03.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 03:05:04 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:05:02 +0100
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
Message-ID: <20200330100502.hh2yygyxctsmwd6o@debian>
References: <20200327021159.31429-1-Tianyu.Lan@microsoft.com>
 <87k13641rg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k13641rg.fsf@vitty.brq.redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 09:53:39AM +0100, Vitaly Kuznetsov wrote:
> Tianyu Lan <ltykernel@gmail.com> writes:
> 
> > From: Yubo Xie <yuboxie@microsoft.com>
> >
> > sched clock callback should return time with nano second as unit
> > but current hv callback returns time with 100ns. Fix it.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
> > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > Fixes: bd00cd52d5be ("clocksource/drivers/hyperv: Add Hyper-V specific sched clock function")
> > ---
> > Change since v1:
> > 	Update fix commit number in change log. 
> > ---
> >  drivers/clocksource/hyperv_timer.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
> > index 9d808d595ca8..662ed978fa24 100644
> > --- a/drivers/clocksource/hyperv_timer.c
> > +++ b/drivers/clocksource/hyperv_timer.c
> > @@ -343,7 +343,8 @@ static u64 notrace read_hv_clock_tsc_cs(struct clocksource *arg)
> >  
> >  static u64 read_hv_sched_clock_tsc(void)
> >  {
> > -	return read_hv_clock_tsc() - hv_sched_clock_offset;
> > +	return (read_hv_clock_tsc() - hv_sched_clock_offset)
> > +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
> >  }
> >  
> >  static void suspend_hv_clock_tsc(struct clocksource *arg)
> > @@ -398,7 +399,8 @@ static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
> >  
> >  static u64 read_hv_sched_clock_msr(void)
> >  {
> > -	return read_hv_clock_msr() - hv_sched_clock_offset;
> > +	return (read_hv_clock_msr() - hv_sched_clock_offset)
> > +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
> >  }
> >  
> >  static struct clocksource hyperv_cs_msr = {
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Queued for hyperv-fixes. Thank you both.

Wei.
