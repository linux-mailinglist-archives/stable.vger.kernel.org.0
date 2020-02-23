Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53531697F8
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 14:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgBWNzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 08:55:10 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52627 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726302AbgBWNzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Feb 2020 08:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582466109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EPL+Ij7TjC4xr/HDB4HJ/CmiyuAMo98kUlya8NTfiGA=;
        b=Sc4xJC04U8MggAwXFJbHu83UUD2bdHJPW+FpzO1vBIqrfKE9+52AJMwC/yprqYA96Hcyew
        ggSUVPw1vzBiPv3c1Nd5ycUMcOVE+LMCSbzScQGjRUXeBZL1+n6O9tWPS3DHplTNi6jLd5
        jDIk39AwhaTjS5bOpzZSSEXyZTomzzc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-NFJKhPG5MKWPYZ92GojeHQ-1; Sun, 23 Feb 2020 08:55:08 -0500
X-MC-Unique: NFJKhPG5MKWPYZ92GojeHQ-1
Received: by mail-wm1-f71.google.com with SMTP id p2so1852979wma.3
        for <stable@vger.kernel.org>; Sun, 23 Feb 2020 05:55:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EPL+Ij7TjC4xr/HDB4HJ/CmiyuAMo98kUlya8NTfiGA=;
        b=R4XMSK+nrv1LhkZPahxn0vW9Qj5C36nTKYgsWnog9gIgfGSTtbMaOQJWHpaHNMWHxI
         K7Zww3HLH4eyEhLxq8ljxUpOCclEV3EPeDvrrCRwGyTtPhMYV00rs2U9oWMhdbq3cgMk
         pHsAneXsC+q85g16oGCW3VvtCRVdhpBDGxY8h4k5er49525v7U06UAiDRYoBxzyQDjBv
         gzvuvSYpEyfCzl/2MrDvQ3pxMH8LleHZq00PJrxw0o/3mLZthnxdSVe20BDDMpOs6yyJ
         cl4RELNcl6+/wZ1euFRpgxiy1usBgjjjusqMxzXUGI2yUBOQ7fqnXD8cgq1zY/u8MS3i
         mcUQ==
X-Gm-Message-State: APjAAAWj5daKdBLyt0lxo5NL/61o+jfqH+Cubm2FozO5PWC+OM4KqGMV
        KFnjVWZLa8ZGeur2/xKAcMRN/Kx3pTlcd9GYN858PHvCIbgAwVLlKfuhAueaZ388wmxfKZeaTTC
        4o2x66oECm2rnnYCq
X-Received: by 2002:adf:9486:: with SMTP id 6mr1957487wrr.341.1582466106374;
        Sun, 23 Feb 2020 05:55:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqzhpUioWe32CRYNPZd2baCs11PLqnIlZcWUisoENKm7kuIL0HbsVPj5XrcWe2JVuQuw92rvvQ==
X-Received: by 2002:adf:9486:: with SMTP id 6mr1957468wrr.341.1582466106174;
        Sun, 23 Feb 2020 05:55:06 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id h13sm10309833wml.45.2020.02.23.05.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 05:55:05 -0800 (PST)
Subject: Re: [PATCH v3 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andy@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200207205456.113758-1-hdegoede@redhat.com>
 <20200207205456.113758-3-hdegoede@redhat.com>
 <87eev67xkc.fsf@nanos.tec.linutronix.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <36b1e1bb-cbb0-88c0-dab2-aa5e14233e63@redhat.com>
Date:   Sun, 23 Feb 2020 14:55:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87eev67xkc.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/8/20 1:05 AM, Thomas Gleixner wrote:
> Hans,
> 
> Hans de Goede <hdegoede@redhat.com> writes:
>> @@ -120,11 +180,23 @@ unsigned long cpu_khz_from_msr(void)
>>   	rdmsr(MSR_FSB_FREQ, lo, hi);
>>   	index = lo & freq_desc->mask;
>>   
>> -	/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
>> -	freq = freq_desc->freqs[index];
>> -
>> -	/* TSC frequency = maximum resolved freq * maximum resolved bus ratio */
>> -	res = freq * ratio;
>> +	/*
>> +	 * Note this also catches cases where the index points to an unpopulated
>> +	 * part of muldiv, in that case the else will set freq and res to 0.
>> +	 */
>> +	if (freq_desc->muldiv[index].divider) {
>> +		freq = DIV_ROUND_CLOSEST(TSC_REFERENCE_KHZ *
>> +					   freq_desc->muldiv[index].multiplier,
>> +					 freq_desc->muldiv[index].divider);
>> +		/* Multiply by ratio before the divide for better accuracy */
>> +		res = DIV_ROUND_CLOSEST(TSC_REFERENCE_KHZ *
>> +					   freq_desc->muldiv[index].multiplier *
>> +					   ratio,
>> +					freq_desc->muldiv[index].divider);
> 
> What about:
> 
>          struct muldiv *md = &freq_desc->muldiv[index];
> 
>          if (md->divider) {
> 		tscref = TSC_REFERENCE_KHZ * md->multiplier;
>          	freq = DIV_ROUND_CLOSEST(tscref, md->divider);
> 		/*
>                   * Multiplying by ratio before the division has better
>                   * accuracy than just calculating freq * ratio
>                   */
>                  res = DIV_ROUND_CLOSEST(tscref * ratio, md->divider);
> 
> Hmm?

That indeed looks nicer, I've prepared (and tested) a v4 with the
suggested change, I'll send out v4 right after this email.

Regards,

Hans

