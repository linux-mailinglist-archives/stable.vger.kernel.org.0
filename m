Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0757E37BB5D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhELK5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:57:30 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34186 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230096AbhELK5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:57:30 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CApkbl019914;
        Wed, 12 May 2021 12:55:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=HLNK8RvTvKmlpYPvFe1wt2QinsOgjKUyLLA9NdybeCY=;
 b=3dXEhjmQd98pBK6cfYSP2abqgW9LsPsRcW7KylHZeme/GLpkLurf1o63xzfaLpJ0rd9h
 nWe9hDgiSbMxqP1Sq5s+XawarIBKRJA0d2Z1MsMgTErOvKfLtz0wSlKbzQSAikiV/t5a
 oDGhLUr3EuAMoZmJqTX4B3XRX19CkMMhxhJsLE2saM9/Td7sDfzS4ajQAJxxBdGp4GYy
 YF8RxaFhXcV/Bahdzxe/j6foVPid5TQ2QOm4F1IraGiiljX6Gr1qxhH1cS7rQX+3AMPX
 8FItocbYo2Cq+yGFVuvPhQ/BZ8noPN6bP3oaUZBApcvcvcpRZu2Bh9YZXfpJ22DS42XO tg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 38fq9tpx0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 12:55:57 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 52AE510002A;
        Wed, 12 May 2021 12:55:55 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node3.st.com [10.75.127.6])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 24B7221C56F;
        Wed, 12 May 2021 12:55:55 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.49) by SFHDAG2NODE3.st.com
 (10.75.127.6) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 12:55:54 +0200
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Quentin Perret <qperret@google.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Android Kernel Team <kernel-team@android.com>,
        Architecture Mailman List <boot-architecture@lists.linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
 <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
 <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
 <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
 <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
 <YH/ixPnHMxNo08mJ@google.com>
 <cc8f96a4-6c85-b869-d3cf-5dc543982054@gmail.com>
 <YIFzMkW+tXonTf0K@google.com>
 <ad90b2bb-0fab-9f06-28dd-038e8005490b@foss.st.com>
 <YJkGSb72aKg6ScGo@google.com>
From:   Alexandre TORGUE <alexandre.torgue@foss.st.com>
Message-ID: <e1da4a98-7521-518f-f85a-51e9c58b1fc3@foss.st.com>
Date:   Wed, 12 May 2021 12:55:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YJkGSb72aKg6ScGo@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE3.st.com (10.75.127.6) To SFHDAG2NODE3.st.com
 (10.75.127.6)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_05:2021-05-12,2021-05-12 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Quentin,

On 5/10/21 12:09 PM, Quentin Perret wrote:
> Hi Alexandre,
> 
> On Friday 07 May 2021 at 17:15:20 (+0200), Alexandre TORGUE wrote:
>> Did you get time to continue some tests on this issue ?
> 
> I did try a few things, but still fail to reproduced :/
> 
>> On my side this DT is not working:
>>
>> memory@c0000000 {
>>          reg = <0xc0000000 0x20000000>;
>> };
>>
>> reserved-memory {
>>          #address-cells = <1>;
>>          #size-cells = <1>;
>>          ranges;
>>
>>          gpu_reserved: gpu@d4000000 {
>>                  reg = <0xd4000000 0x4000000>;
>>                  no-map;
>>          };
>> };
> 
> So this does change how memory appears in /proc/iomem for me switching
> from 5.4.101 to v5.4.102 -- for the former d4000000-d7ffffff doesn't
> appear at all, and for the latter it appears as 'reserved'.
> 
> But still, it never gets accounted as System RAM for me ...
> 
>> Let me know if I can help.
> 
> Could you please confirm you get a correct behaviour with 5.10.31 like
> Florian? If so, then bisecting to figure out what we're missing in older
> LTSes would help, but again it feels like we should just revert -- this
> wasn't really a fix in the first place.


We saw that patches [1] and [2] cause issue on stable version (at least 
for 5.4). As you said issue can be seen with above device tree and check 
in /proc/iomem than gpu_reserved region is taken by the kernel as 
"System RAM".

On v5.10 stream there are no issues seen taking patches [1]&[2] and the 
reason is linked to patches [3]&[4] which have been introduced in 
v5.10.0. Reverting them give me the same behavior than on stable version.


[1] of/fdt: Make sure no-map does not remove already reserved regions
[2] fdt: Properly handle "no-map" field in the memory region
[3] arch, drivers: replace for_each_membock() with for_each_mem_range()
[4] memblock: use separate iterators for memory and reserved regions

regards
Alex

> 
> Thanks,
> Quentin
> 

