Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71698478B59
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 13:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbhLQM1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 07:27:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhLQM1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 07:27:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639744033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQn9QnfrMJ42qGC926SQJqMG9+yUqctk6joXXXUXODU=;
        b=UFDE4rHCIriuH22kO4r2dVYRlPQQ50ga9cT8VbSdNGcfyHug8s4FIvRcn8aqQWZQNEwAR9
        ouK7v74X+pG78VS0LhH+HLut5gsDK4RYj7bxK6L8WdODLC+fM6iGTLGn9Ls4tjlyENc9ge
        OQvp62BRwE+ENauV+FmpmEFXAeXkMzE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-MHTo7wMGOP-sfkPd5M2XZQ-1; Fri, 17 Dec 2021 07:27:12 -0500
X-MC-Unique: MHTo7wMGOP-sfkPd5M2XZQ-1
Received: by mail-wr1-f69.google.com with SMTP id r7-20020adfbb07000000b001a254645f13so513510wrg.7
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 04:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=PQn9QnfrMJ42qGC926SQJqMG9+yUqctk6joXXXUXODU=;
        b=DZlwYRAC4/jInB4nWTUd98Nm3Ve4BvTyKulhafcSFk2ZqT9XDxyOmcQIdlDQybDuEW
         I9C3BvBcEDVQ7/rz/6VKi8rytRlxAJnTg2kCM5dd6a/NoZzZXChMkkGerVkodGrc+aVd
         XwaLKO3vy4LPzw6nLdameZJD+Z4B/oyN/WSrgOrgMScJfP7GkQF3pVOu1YCWONZ6N3UR
         AVMypPupP7mzaTCJ0fr4lmvfii6/lF4D83hZe6qlfoc0CuTyZIutKIIFw33vZIAIewj2
         k61k3YTIjnjvn6iDd27nzt51Egsok120E1D7IV0yczvyCQ16xlWJHyeYkdY2JZeMrdJC
         Wksw==
X-Gm-Message-State: AOAM533WgoSQSG6CA+mXLX2uh9A1GA9dbKMbkoIm8oSraQgotezli6MS
        YR3mpxROzY60G8nHwNeZoC1exP2J8MysP497dxFmO1udmS/Ec7lHcYxmIQTt6I1E1mfBO2uB+h9
        ZOccAP/g9a6ZqfDTS
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr2380619wrd.420.1639744030913;
        Fri, 17 Dec 2021 04:27:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyMU9oSbjos1l9GF9keeS6GGCVXwXiTHkH7R/bDnn/YWsy42XudUx//GCm2ssgumBD4iCJuwA==
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr2380595wrd.420.1639744030687;
        Fri, 17 Dec 2021 04:27:10 -0800 (PST)
Received: from [192.168.3.132] (p4ff234b8.dip0.t-ipconnect.de. [79.242.52.184])
        by smtp.gmail.com with ESMTPSA id d2sm7152790wra.61.2021.12.17.04.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 04:27:10 -0800 (PST)
Message-ID: <88ce4f53-587b-c18a-9694-a3e173e6e030@redhat.com>
Date:   Fri, 17 Dec 2021 13:27:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] mm: cma: fix allocation may fail sometimes
Content-Language: en-US
To:     Aisheng Dong <aisheng.dong@nxp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Jason Liu <jason.hui.liu@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "lecopzer.chen@mediatek.com" <lecopzer.chen@mediatek.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shijie Qin <shijie.qin@nxp.com>
References: <20211215080242.3034856-1-aisheng.dong@nxp.com>
 <20211215080242.3034856-2-aisheng.dong@nxp.com>
 <783f64f5-3a55-6c42-a740-19a12c2c7321@redhat.com>
 <DB9PR04MB84777DDC63F5D2D995F7F5E980779@DB9PR04MB8477.eurprd04.prod.outlook.com>
 <7d9b7e5f-a6c0-2079-90e7-c02aaeb1f4c0@redhat.com>
 <DB9PR04MB8477037EE173D98F844DCAE680789@DB9PR04MB8477.eurprd04.prod.outlook.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <DB9PR04MB8477037EE173D98F844DCAE680789@DB9PR04MB8477.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.12.21 04:44, Aisheng Dong wrote:
>> From: David Hildenbrand <david@redhat.com>
>> Sent: Thursday, December 16, 2021 6:57 PM
>>
>> On 16.12.21 03:54, Aisheng Dong wrote:
>>>> From: David Hildenbrand <david@redhat.com>
>>>> Sent: Wednesday, December 15, 2021 8:31 PM
>>>>
>>>> On 15.12.21 09:02, Dong Aisheng wrote:
>>>>> We met dma_alloc_coherent() fail sometimes when doing 8 VPU decoder
>>>>> test in parallel on a MX6Q SDB board.
>>>>>
>>>>> Error log:
>>>>> cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret:
>>>>> -16
>>>>> cma: number of available pages:
>>>>>
>>>>
>> 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@3607
>>>> 6+99@40477+108
>>>>> @40852+44@41108+20@41196+108@41364+108@41620+
>>>>>
>>>>
>> 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49
>>>> 324+20@49388+
>>>>> 5076@49452+2304@55040+35@58141+20@58220+20@58284+
>>>>> 7188@58348+84@66220+7276@66452+227@74525+6371@75549=>
>>>> 33161 free of
>>>>> 81920 total pages
>>>>>
>>>>> When issue happened, we saw there were still 33161 pages (129M) free
>>>>> CMA memory and a lot available free slots for 148 pages in CMA
>>>>> bitmap that we want to allocate.
>>>>>
>>>>> If dumping memory info, we found that there was also ~342M normal
>>>>> memory, but only 1352K CMA memory left in buddy system while a lot
>>>>> of pageblocks were isolated.
>>>>>
>>>>> Memory info log:
>>>>> Normal free:351096kB min:30000kB low:37500kB high:45000kB
>>>> reserved_highatomic:0KB
>>>>> 	    active_anon:98060kB inactive_anon:98948kB active_file:60864kB
>>>> inactive_file:31776kB
>>>>> 	    unevictable:0kB writepending:0kB present:1048576kB
>>>> managed:1018328kB mlocked:0kB
>>>>> 	    bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB
>>>>> lowmem_reserve[]: 0 0 0
>>>>> Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB
>>>> (UMECI) 65*64kB (UMCI)
>>>>> 	36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI)
>>>> 4*2048kB (MI) 8*4096kB (EI)
>>>>> 	8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
>>>>>
>>>>> The root cause of this issue is that since commit a4efc174b382
>>>>> ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports
>>>> concurrent
>>>>> memory allocation. It's possible that the pageblock process A try to
>>>>> alloc has already been isolated by the allocation of process B
>>>>> during memory migration.
>>>>>
>>>>> When there're multi process allocating CMA memory in parallel, it's
>>>>> likely that other the remain pageblocks may have also been isolated,
>>>>> then CMA alloc fail finally during the first round of scanning of
>>>>> the whole available CMA bitmap.
>>>>
>>>> I already raised in different context that we should most probably
>>>> convert that -EBUSY to -EAGAIN --  to differentiate an actual
>>>> migration problem from a simple "concurrent allocations that target the
>> same MAX_ORDER -1 range".
>>>>
>>>
>>> Thanks for the info. Is there a patch under review?
>>
>> No, and I was too busy for now to send it out.
>>
>>> BTW i wonder that probably makes no much difference for my patch since
>>> we may prefer retry the next pageblock rather than busy waiting on the
>> same isolated pageblock.
>>
>> Makes sense. BUT as of now we isolate not only a pageblock but a
>> MAX_ORDER -1 page (e.g., 2 pageblocks on x86-64 (!) ). So you'll have the
>> same issue in that case.
> 
> Yes, should I change to try next MAX_ORDER_NR_PAGES or keep as it is
> and let the core to improve it later?
> 
> I saw there's a patchset under review which is going to remove the
> MAX_ORDER - 1 alignment requirement for CMA.
> https://patchwork.kernel.org/project/linux-mm/cover/20211209230414.2766515-1-zi.yan@sent.com/
> 
> Once it's merged, I guess we can back to align with pageblock rather
> than MAX_ORDER-1.

While the goal is to get rid of the alignment requirement, we might
still have to isolate all applicable MAX_ORDER-1 pageblocks. Depends on
what we can or cannot achieve easily :)


-- 
Thanks,

David / dhildenb

