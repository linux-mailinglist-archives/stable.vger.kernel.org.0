Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC01747301D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhLMPHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:07:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235393AbhLMPHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 10:07:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639408042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uggT/+pQy7C1tHnjMg4wuSFl6S0v17jldc3DQhaGtQk=;
        b=Ueg2CAx+fgO4urH5LRKACLoIVwjGr7ZsVZ1VaW4DA/N57CD/MVkfB3i5S4zstY+KCMq1Vg
        KSZ7aLslADr5HxbywRoBYXkdBm4A/QGCCq2liHY7lcltClStLRxDAhTASRUMlVJPvz6UZq
        xaHZbk9+WgdZmY+wi4jLHu+FhTrrry0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-tsRI4cYMM5acWjw1JxONmQ-1; Mon, 13 Dec 2021 10:07:21 -0500
X-MC-Unique: tsRI4cYMM5acWjw1JxONmQ-1
Received: by mail-wm1-f70.google.com with SMTP id ay17-20020a05600c1e1100b0033f27b76819so9757185wmb.4
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 07:07:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=uggT/+pQy7C1tHnjMg4wuSFl6S0v17jldc3DQhaGtQk=;
        b=pqcnBPzWnt7jwBWC+c3OwFYDEhx0i0z71+Ag/cuOEA9lcjn981spHNFDXHZVx64TTy
         sW2zpmv5Nccgs0yi3gD9ezDOsazTx38n3l67rvwTjBCwP4/C5UV0NbcZ9XmEpmBJBFTP
         UYeagPwV0dDqn+QPxkZPlJk1UbWUR6METF6cD5nc3WwkBeMnyTCjRVc5PDpsK5ChUbc8
         DNKb14xDTk4/aPxRdm3ue4sg/qw36HqH+DAjwp7NHyp/E5Ck3Vwvn/VaB09C/urXoSEb
         9vWeqYb171pdiYGWmHyLaDeVo1Z97bcthKbCwefd7UwZQLO+pUQPP5iF+fXhPz5IpLSL
         C1XA==
X-Gm-Message-State: AOAM530DJ+gOWuxraqLrVGuaOXybAHyEN8b+aGMzpGGsb6iN6H66rb/g
        MCSfbG7viiqZQVB4KNZd972uDyrfTxlpiY2vuHqnjVYK9mQwqe4iDRr/cOOUKzofWKP46Pzq3DB
        OEISxPBiiyWs2hbPV
X-Received: by 2002:adf:ab53:: with SMTP id r19mr33062250wrc.584.1639408039891;
        Mon, 13 Dec 2021 07:07:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzET13cEtz/YoT7d03sX89afl9lxr5U+/Ow3qaZB2VDAxF8TdSnM8UszCXjQP9+6JM8VcTBUQ==
X-Received: by 2002:adf:ab53:: with SMTP id r19mr33062220wrc.584.1639408039689;
        Mon, 13 Dec 2021 07:07:19 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6276.dip0.t-ipconnect.de. [91.12.98.118])
        by smtp.gmail.com with ESMTPSA id t17sm7931762wmq.15.2021.12.13.07.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 07:07:19 -0800 (PST)
Message-ID: <ba5f460b-fc6c-601b-053c-086185fd3049@redhat.com>
Date:   Mon, 13 Dec 2021 16:07:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>,
        Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Nico Pache <npache@redhat.com>
References: <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz> <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbHfBgPQMkjtuHYF@dhcp22.suse.cz> <YbdhdySBaHJ/UxBZ@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YbdhdySBaHJ/UxBZ@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.12.21 16:06, Michal Hocko wrote:
> On Thu 09-12-21 11:48:42, Michal Hocko wrote:
> [...]
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 852041f6be41..2d38a431f62f 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1161,19 +1161,21 @@ static void reset_node_present_pages(pg_data_t *pgdat)
>>  }
>>  
>>  /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
>> -static pg_data_t __ref *hotadd_new_pgdat(int nid)
>> +static pg_data_t __ref *hotadd_init_pgdat(int nid)
>>  {
>>  	struct pglist_data *pgdat;
>>  
>>  	pgdat = NODE_DATA(nid);
>> -	if (!pgdat) {
>> -		pgdat = arch_alloc_nodedata(nid);
>> -		if (!pgdat)
>> -			return NULL;
>>  
>> +	/*
>> +	 * NODE_DATA is preallocated (free_area_init) but its internal
>> +	 * state is not allocated completely. Add missing pieces.
>> +	 * Completely offline nodes stay around and they just need
>> +	 * reintialization.
>> +	 */
>> +	if (!pgdat->per_cpu_nodestats) {
>>  		pgdat->per_cpu_nodestats =
>>  			alloc_percpu(struct per_cpu_nodestat);
>> -		arch_refresh_nodedata(nid, pgdat);
> 
> This should really be 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 42211485bcf3..2daa88ce8c80 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1173,7 +1173,7 @@ static pg_data_t __ref *hotadd_init_pgdat(int nid)
>  	 * Completely offline nodes stay around and they just need
>  	 * reintialization.
>  	 */
> -	if (!pgdat->per_cpu_nodestats) {
> +	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
>  		pgdat->per_cpu_nodestats =
>  			alloc_percpu(struct per_cpu_nodestat);
>  	} else {
> 

I'll try giving this some churn later this week -- busy with other stuff.

-- 
Thanks,

David / dhildenb

