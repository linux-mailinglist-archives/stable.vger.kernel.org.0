Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF0D2411AF
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgHJU1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:27:43 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:51183 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHJU1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597091262; x=1628627262;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iwpO3dpinVS829lPIRAR+vT6k9fh6hMuVQXSkv+p8sA=;
  b=oz3jcEuS9WIFUYFqrohXwYU7DKWaDMvxn7g2yxMGVa43Us6Nuvz000fd
   uznc6CLpW/ErToCIr/FLzRkkEHRX/wpnTz3xNCyC1BbxrEeXGAuuhJH1M
   tHFNshufaJWVwaWXeRopLbAoAFaOMCswTAmRU4EYgWxrKSZhp8mNupeFJ
   8=;
IronPort-SDR: AqVlnbtkZ4Yx3Ju+CpUl4xg/tfrM+dj/1wOOgVmrSmsiX7r7JZA7IVEmwKf4rzvZUsYqqqwJaM
 no5etGrFCWOg==
X-IronPort-AV: E=Sophos;i="5.75,458,1589241600"; 
   d="scan'208";a="47071912"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Aug 2020 20:27:42 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 75E3DA1900;
        Mon, 10 Aug 2020 20:27:41 +0000 (UTC)
Received: from EX13D05UEE004.ant.amazon.com (10.43.62.189) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:27:40 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D05UEE004.ant.amazon.com (10.43.62.189) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:27:40 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 10 Aug 2020 20:27:40 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 197A7C13FC; Mon, 10 Aug 2020 20:27:40 +0000 (UTC)
Date:   Mon, 10 Aug 2020 20:27:40 +0000
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <tglx@linutronix.de>
Subject: Re: [PATCH 5.4] genirq/affinity: Make affinity setting if activated
 opt-in
Message-ID: <20200810202740.GA22367@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
References: <20200810202503.22317-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200810202503.22317-1-fllinden@amazon.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 08:25:03PM +0000, Frank van der Linden wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> commit f0c7baca180046824e07fc5f1326e83a8fd150c7 upstream.
> 
> John reported that on a RK3288 system the perf per CPU interrupts are all
> affine to CPU0 and provided the analysis:
> 
>  "It looks like what happens is that because the interrupts are not per-CPU
>   in the hardware, armpmu_request_irq() calls irq_force_affinity() while
>   the interrupt is deactivated and then request_irq() with IRQF_PERCPU |
>   IRQF_NOBALANCING.
> 
>   Now when irq_startup() runs with IRQ_STARTUP_NORMAL, it calls
>   irq_setup_affinity() which returns early because IRQF_PERCPU and
>   IRQF_NOBALANCING are set, leaving the interrupt on its original CPU."
> 
> This was broken by the recent commit which blocked interrupt affinity
> setting in hardware before activation of the interrupt. While this works in
> general, it does not work for this particular case. As contrary to the
> initial analysis not all interrupt chip drivers implement an activate
> callback, the safe cure is to make the deferred interrupt affinity setting
> at activation time opt-in.
> 
> Implement the necessary core logic and make the two irqchip implementations
> for which this is required opt-in. In hindsight this would have been the
> right thing to do, but ...

I backported this one since it had a minor conflict, so while the main
one was Cc-ed to stable@, it didn't get picked up.

Ran it through all our regression tests and the reproducer case, and it's
fine.

- Frank
