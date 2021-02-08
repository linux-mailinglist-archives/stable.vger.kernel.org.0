Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE9F312EE4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhBHKYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:24:04 -0500
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:48512 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhBHKWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:22:20 -0500
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2021 05:22:17 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1612779740;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qqXwtjOco8fjJeHnQYr5Tm8x0nM5NCab4a40inMqm1A=;
  b=fcTVzDBYpf2tKDB3IzCcNvCAf9qMNg9nBqGfbOGLQeRme9horfeefQk1
   9EFGru3c9LRPAg4KiqqrnxGqOtx9gDk59fgAn2tiJ0o8r/bKWmTT05mfK
   l9qOvtlgnRsuMkAE5+3cOLJNdvwZ+PdopqZj2uT4frUDZeNuKZq6zb7dF
   A=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: rjLiNJ3vCQ9cpicm4ICWdmqbU0Vr/mR7YGxVzAVJ52hyZBx42ePUyqcKVcg6h7iZihXAwtKnvk
 /u2ugcsHkCr2tjlPPtTnxOG0gr7hIogThvz1V16ht6iY6ej2VQBERCF/JonZUOAMxcv1kmMigu
 t848MnWL4C9XA83gbWwfXTwIC+UvubXumL2q3pImtIFTIMF3nv5XVgU+Y3eWieoOYu+wqvg7aw
 5/aeHo7oBKNfyDvBwrXzr6XxnepobkJpK0X8OPTp9b8GRTuQ0FaGUL8wvw83yykXckovqWbTs8
 NP0=
X-SBRS: 5.1
X-MesageID: 36787092
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.81,161,1610427600"; 
   d="scan'208";a="36787092"
Subject: Re: [PATCH 2/7] xen/events: don't unmask an event channel when an eoi
 is pending
To:     Juergen Gross <jgross@suse.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        <stable@vger.kernel.org>, Julien Grall <julien@xen.org>
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-3-jgross@suse.com>
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
Message-ID: <bdf20a87-5b4d-529e-7028-cea3eeef769b@citrix.com>
Date:   Mon, 8 Feb 2021 10:15:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20210206104932.29064-3-jgross@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-02-06 10:49, Juergen Gross wrote:
> An event channel should be kept masked when an eoi is pending for it.
> When being migrated to another cpu it might be unmasked, though.
> 
> In order to avoid this keep two different flags for each event channel
> to be able to distinguish "normal" masking/unmasking from eoi related
> masking/unmasking. The event channel should only be able to generate
> an interrupt if both flags are cleared.
> 
> Cc: stable@vger.kernel.org
> Fixes: 54c9de89895e0a36047 ("xen/events: add a new late EOI evtchn framework")
> Reported-by: Julien Grall <julien@xen.org>
> Signed-off-by: Juergen Gross <jgross@suse.com>
...> +static void lateeoi_ack_dynirq(struct irq_data *data)
> +{
> +	struct irq_info *info = info_for_irq(data->irq);
> +	evtchn_port_t evtchn = info ? info->evtchn : 0;
> +
> +	if (VALID_EVTCHN(evtchn)) {
> +		info->eoi_pending = true;
> +		mask_evtchn(evtchn);
> +	}
> +}

Doesn't this (and the one below) need a call to clear_evtchn() to
actually ack the pending event? Otherwise I can't see what clears
the pending bit.

I tested out this patch but processes using the userspace evtchn device did
not work very well without the clear_evtchn() call.

Ross

> +
> +static void lateeoi_mask_ack_dynirq(struct irq_data *data)
> +{
> +	struct irq_info *info = info_for_irq(data->irq);
> +	evtchn_port_t evtchn = info ? info->evtchn : 0;
> +
> +	if (VALID_EVTCHN(evtchn)) {
> +		info->masked = true;
> +		info->eoi_pending = true;
> +		mask_evtchn(evtchn);
> +	}
> +}
> +
