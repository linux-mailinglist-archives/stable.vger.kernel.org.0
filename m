Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5D6312EA2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhBHKNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:13:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:51920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhBHKHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 05:07:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612778773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m57HtWSnT9lNNo+P6sNLTZYsYuwZK8OejPr+c5tKA0k=;
        b=YMzOBN7u8wu6DufA67/rqYavO42OtrEcVU0jrj2aGc+eEo80i9SGA23JLWUCw6STUqfGY7
        UFg6BMAOIQmKCyCdNRE2hQsOGniljK3XArUoLVHL7yuIcuWB4h1/4OsHuaY/sCZVUZ3j2E
        iGgzdr++IJ8PC0eJtQLBc1eu1UldXZU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72167ADCD;
        Mon,  8 Feb 2021 10:06:13 +0000 (UTC)
Subject: Re: [PATCH 2/7] xen/events: don't unmask an event channel when an eoi
 is pending
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-3-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <7aa76e26-b6f4-fae2-861b-bcc0039ce497@suse.com>
Date:   Mon, 8 Feb 2021 11:06:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210206104932.29064-3-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.02.2021 11:49, Juergen Gross wrote:
> @@ -1798,6 +1818,29 @@ static void mask_ack_dynirq(struct irq_data *data)
>  	ack_dynirq(data);
>  }
>  
> +static void lateeoi_ack_dynirq(struct irq_data *data)
> +{
> +	struct irq_info *info = info_for_irq(data->irq);
> +	evtchn_port_t evtchn = info ? info->evtchn : 0;
> +
> +	if (VALID_EVTCHN(evtchn)) {
> +		info->eoi_pending = true;
> +		mask_evtchn(evtchn);
> +	}
> +}
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
>  static int retrigger_dynirq(struct irq_data *data)
>  {
>  	evtchn_port_t evtchn = evtchn_from_irq(data->irq);
> @@ -2023,8 +2066,8 @@ static struct irq_chip xen_lateeoi_chip __read_mostly = {
>  	.irq_mask		= disable_dynirq,
>  	.irq_unmask		= enable_dynirq,
>  
> -	.irq_ack		= mask_ack_dynirq,
> -	.irq_mask_ack		= mask_ack_dynirq,
> +	.irq_ack		= lateeoi_ack_dynirq,
> +	.irq_mask_ack		= lateeoi_mask_ack_dynirq,
>  
>  	.irq_set_affinity	= set_affinity_irq,
>  	.irq_retrigger		= retrigger_dynirq,
> 

Unlike the prior handler the two new ones don't call ack_dynirq()
anymore, and the description doesn't give a hint towards this
difference. As a consequence, clear_evtchn() also doesn't get
called anymore - patch 3 adds the calls, but claims an older
commit to have been at fault. _If_ ack_dynirq() indeed isn't to
be called here, shouldn't the clear_evtchn() calls get added
right here?

Jan
