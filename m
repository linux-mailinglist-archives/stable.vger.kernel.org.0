Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150CF17BDF6
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgCFNQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:16:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgCFNQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 08:16:01 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2757206E2;
        Fri,  6 Mar 2020 13:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583500560;
        bh=O7DyGs5X6WqiUvbbNzIrGmdLmE4umMZW5A0duTxIafY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lr9PiGlc4n4rCWo1HRZm5j2i4lLL0ZFcAeP+tJp17RVsKiWz3s8ZsK4MMyEgz8iRQ
         z5taC+sqbOnEcE1UKcQ++5hi+Qm1fAeXtMW1JRKXnn73XyPnmU8iDDmeLPYuvtfj+c
         oiVldnxvdr/fW5BXBLl73DP1MBwgzvP3K+9zPw1Q=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jACpb-00AZkS-1a; Fri, 06 Mar 2020 13:15:59 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Mar 2020 13:15:59 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [patch 1/7] genirq/debugfs: Add missing sanity checks to
 interrupt injection
In-Reply-To: <20200306130623.500019114@linutronix.de>
References: <20200306130341.199467200@linutronix.de>
 <20200306130623.500019114@linutronix.de>
Message-ID: <8eaa5507e4cf77042d39688465c2b989@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org, bhelgaas@google.com, linux-pci@vger.kernel.org, kbusch@kernel.org, sathyanarayanan.kuppuswamy@linux.intel.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-03-06 13:03, Thomas Gleixner wrote:
> Interrupts cannot be injected when the interrupt is not activated and 
> when
> a replay is already in progress.
> 
> Fixes: 536e2e34bd00 ("genirq/debugfs: Triggering of interrupts from 
> userspace")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  kernel/irq/debugfs.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> --- a/kernel/irq/debugfs.c
> +++ b/kernel/irq/debugfs.c
> @@ -206,8 +206,15 @@ static ssize_t irq_debug_write(struct fi
>  		chip_bus_lock(desc);
>  		raw_spin_lock_irqsave(&desc->lock, flags);
> 
> -		if (irq_settings_is_level(desc) || desc->istate & IRQS_NMI) {
> -			/* Can't do level nor NMIs, sorry */
> +		/*
> +		 * Don't allow injection when the interrupt is:
> +		 *  - Level or NMI type
> +		 *  - not activated
> +		 *  - replaying already
> +		 */
> +		if (irq_settings_is_level(desc) ||
> +		    !irqd_is_activated(&desc->irq_data) ||
> +		    (desc->istate & (IRQS_NMI | IRQS_REPLAY)) {
>  			err = -EINVAL;
>  		} else {
>  			desc->istate |= IRQS_PENDING;

Huh, nice catch.

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
