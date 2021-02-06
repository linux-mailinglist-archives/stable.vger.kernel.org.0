Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF46311CF6
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 12:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhBFLtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 06:49:49 -0500
Received: from mail.xenproject.org ([104.130.215.37]:54978 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhBFLtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 06:49:46 -0500
X-Greylist: delayed 1720 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Feb 2021 06:49:46 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=cQMVVJSJD0Yb9XwMSYFH2sar2ohLPP0jLc971S/sMZo=; b=ffsul8eGaVzjXDWs7EhAD5EEVQ
        uJn1mS8YMhPvBFddMAHUIXJCNzkhcLZqkJH+YtdQ17z4s3/BDSWyZlFmJ/sb7QnX1sPMn0cAoqMMf
        tH7LPW55otKCCBIBm8Yhdue3YtzZoFlozVtvzCTF9e+OrAvDEMqKM5+fiT3jmHR5uq3s=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l8LdS-0007F2-Ew; Sat, 06 Feb 2021 11:20:18 +0000
Received: from [54.239.6.185] (helo=a483e7b01a66.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l8LdS-0001vv-5l; Sat, 06 Feb 2021 11:20:18 +0000
Subject: Re: [PATCH 1/7] xen/events: reset affinity of 2-level event initially
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-2-jgross@suse.com>
From:   Julien Grall <julien@xen.org>
Message-ID: <f89567cf-f954-0d97-087e-5e31bfa6d49d@xen.org>
Date:   Sat, 6 Feb 2021 11:20:16 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210206104932.29064-2-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Juergen,

On 06/02/2021 10:49, Juergen Gross wrote:
> When creating a new event channel with 2-level events the affinity
> needs to be reset initially in order to avoid using an old affinity
> from earlier usage of the event channel port.
> 
> The same applies to the affinity when onlining a vcpu: all old
> affinity settings for this vcpu must be reset. As percpu events get
> initialized before the percpu event channel hook is called,
> resetting of the affinities happens after offlining a vcpu (this is
> working, as initial percpu memory is zeroed out).
> 
> Cc: stable@vger.kernel.org
> Reported-by: Julien Grall <julien@xen.org>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>   drivers/xen/events/events_2l.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
> index da87f3a1e351..23217940144a 100644
> --- a/drivers/xen/events/events_2l.c
> +++ b/drivers/xen/events/events_2l.c
> @@ -47,6 +47,16 @@ static unsigned evtchn_2l_max_channels(void)
>   	return EVTCHN_2L_NR_CHANNELS;
>   }
>   
> +static int evtchn_2l_setup(evtchn_port_t evtchn)
> +{
> +	unsigned int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		clear_bit(evtchn, BM(per_cpu(cpu_evtchn_mask, cpu)));

The bit corresponding to the event channel can only be set on a single 
CPU. Could we avoid the loop and instead clear the bit while closing the 
port?

Cheers,

-- 
Julien Grall
