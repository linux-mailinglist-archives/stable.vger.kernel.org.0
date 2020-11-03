Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6EF2A5553
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388220AbgKCVIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388624AbgKCVIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 16:08:49 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EFFC0613D1;
        Tue,  3 Nov 2020 13:08:48 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 13so611546wmf.0;
        Tue, 03 Nov 2020 13:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jb4L9Y0z8nLo50iZlILjChqFx1sExeynBE0hY/3lq9A=;
        b=e1HtMVuchX9lW5ljiK0edzPzBVkUdZTnodYqjYdH2t8sqrrkvoNp0OuEhyf0wRTGGy
         70A/XvZauAfK4hEpzB6ZExqq0EzxQeuisU9fTSJytV+6YZ3ftOxx0CIGtbJC52N+aNB5
         XNAt++eOZHiRnkNIN9Ny8pqLbmWXgrg+pJTfUbvFzC0q/EzNIl9j4AitmbhQNGqihUgh
         o1bvxEWxO/7wObJvyxE99kJyaXQ5gTXfHXOglbeqBKhbUjUsif5l/NsfwzSCXK18r5Wj
         EeOen8wgWfZiNvahyIQ8OPleJeCq8WD/APsMECg03Kk61UD0LDTBZQ0MQPUtlZZEh7Dh
         ZeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jb4L9Y0z8nLo50iZlILjChqFx1sExeynBE0hY/3lq9A=;
        b=Pf8saqw70LIztoMSUwGVFatqezuUBfIAtMwxZzrY5HW758iZKiPgMy2cWHeC9eCqa6
         8FgECnwd7VUQNGIh2cf5gDzUv/9YQgFSlahTWsa2BgD+oTP6vnG8L5Mgg+1i/dbZKXvd
         BTTWtdTLDK/KDDyT0huAMH9oEvwJrZbymirYadgddGW/rQkU18T6Bje06OkwzkPO5Nh0
         TMC/E9B89kLqgzE4uwJw1YCTiOpEGObnS0cFGxgh+4k+11KT984kSLm0pehtTW2A3WdG
         BRasylM9+Ydnjym2+DdXPIWLw6AP9P/F4DpQRlscStXjhNcQSbzq9OPz1Z23Dw1B6Bwb
         r5LQ==
X-Gm-Message-State: AOAM533Tj4ePfd52Ngn9Z/7KFoQtwp2leWkYYW6DeWeKt7olkykM3qIv
        hVONJ5na6XqyIGvjVxElAIk=
X-Google-Smtp-Source: ABdhPJw+AQf6Xpm9J1SSsCBbcQyWzCWO0a+i1Eid/o/iRToCXeerTMSeRckyKfp4bAROQf3wBrNRDw==
X-Received: by 2002:a1c:4b04:: with SMTP id y4mr1080469wma.93.1604437727422;
        Tue, 03 Nov 2020 13:08:47 -0800 (PST)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id y10sm26483889wru.94.2020.11.03.13.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 13:08:46 -0800 (PST)
Subject: Re: [PATCH] x86/mpx: fix recursive munmap() corruption
To:     Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, mhocko@suse.com,
        rguenther@suse.de, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        luto@amacapital.net, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, vbabka@suse.cz
References: <20190401141549.3F4721FE@viggo.jf.intel.com>
 <alpine.DEB.2.21.1904191248090.3174@nanos.tec.linutronix.de>
 <87d0lht1c0.fsf@concordia.ellerman.id.au>
 <6718ede2-1fcb-1a8f-a116-250eef6416c7@linux.vnet.ibm.com>
 <4f43d4d4-832d-37bc-be7f-da0da735bbec@intel.com>
 <4e1bbb14-e14f-8643-2072-17b4cdef5326@linux.vnet.ibm.com>
 <87k1faa2i0.fsf@concordia.ellerman.id.au>
 <9c2b2826-4083-fc9c-5a4d-c101858dd560@linux.vnet.ibm.com>
 <12313ba8-75b5-d44d-dbc0-0bf2c87dfb59@csgroup.eu>
 <452b347c-0a86-c710-16ba-5a98c12a47e3@linux.vnet.ibm.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <02389b9c-141c-f5b7-756a-516599063766@gmail.com>
Date:   Tue, 3 Nov 2020 21:08:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <452b347c-0a86-c710-16ba-5a98c12a47e3@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent, Christophe, Michael, all,

On 11/3/20 5:11 PM, Laurent Dufour wrote:
> Le 23/10/2020 à 14:28, Christophe Leroy a écrit :
[..]
>>>> That seems like it would work for CRIU and make sense in general?
>>>
>>> Sorry for the late answer, yes this would make more sense.
>>>
>>> Here is a patch doing that.
>>>
>>
>> In your patch, the test seems overkill:
>>
>> +    if ((start <= vdso_base && vdso_end <= end) ||  /* 1   */
>> +        (vdso_base <= start && start < vdso_end) || /* 3,4 */
>> +        (vdso_base < end && end <= vdso_end))       /* 2,3 */
>> +        mm->context.vdso_base = mm->context.vdso_end = 0;
>>
>> What about
>>
>>      if (start < vdso_end && vdso_start < end)
>>          mm->context.vdso_base = mm->context.vdso_end = 0;
>>
>> This should cover all cases, or am I missing something ?
>>
>>
>> And do we really need to store vdso_end in the context ?
>> I think it should be possible to re-calculate it: the size of the VDSO
>> should be (&vdso32_end - &vdso32_start) + PAGE_SIZE for 32 bits VDSO,
>> and (&vdso64_end - &vdso64_start) + PAGE_SIZE for the 64 bits VDSO.
> 
> Thanks Christophe for the advise.
> 
> That is covering all the cases, and indeed is similar to the Michael's
> proposal I missed last year.
> 
> I'll send a patch fixing this issue following your proposal.

It's probably not necessary anymore. I've sent patches [1], currently in
akpm, the last one forbids splitting of vm_special_mapping.
So, a user is able munmap() or mremap() vdso as a whole, but not partly.

[1]:
https://lore.kernel.org/linux-mm/20201013013416.390574-1-dima@arista.com/

Thanks,
          Dmitry
