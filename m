Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5273767D2
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhEGPVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:21:36 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:45832 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234057AbhEGPVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:21:32 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 147FDCsu005115;
        Fri, 7 May 2021 17:20:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=ZkGeTUEAKBO08rb9KF3t1bgdoda2RV7ah1ty+Jk5bMg=;
 b=wQxmP3g3Q/kGPs8FlI/MoDyQrPMbAxqIggmGeMPWoSCbtjTKPBx/HWQR/Fnbu0JR9adO
 lllu4GbanYSd+MBa5xO9LoJIBmhk91ccrvh6fQ3Qn8gRG/HldBaHaYgRV49YzKmcFbkU
 nRbjgpW1Vm096elOMSu4LOYDiw2/7dwN4mKy9UK0xYGdkXE/EEI6c8e6jeeRKzqJjyyi
 vWPgODyz6wMKUE9khgYy0sTc5acElgYN0+6m3u76vAivHMlUnznku4aCJPu3HNXYJJD5
 gNooGZb8NTRHS1G71gncugwLnd/0MsVkadardp3jJ2elZzb5ehSnDwCB/aAdtnhUOZwq 9Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 38csqbw15d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 May 2021 17:20:10 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D7D7A1000D7;
        Fri,  7 May 2021 17:15:22 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node3.st.com [10.75.127.6])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9072422B9D7;
        Fri,  7 May 2021 17:15:22 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.51) by SFHDAG2NODE3.st.com
 (10.75.127.6) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 May
 2021 17:15:21 +0200
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Quentin Perret <qperret@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Ard Biesheuvel <ardb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
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
From:   Alexandre TORGUE <alexandre.torgue@foss.st.com>
Message-ID: <ad90b2bb-0fab-9f06-28dd-038e8005490b@foss.st.com>
Date:   Fri, 7 May 2021 17:15:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YIFzMkW+tXonTf0K@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG2NODE3.st.com (10.75.127.6) To SFHDAG2NODE3.st.com
 (10.75.127.6)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_06:2021-05-06,2021-05-07 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Quentin

On 4/22/21 2:59 PM, Quentin Perret wrote:
> On Wednesday 21 Apr 2021 at 07:33:52 (-0700), Florian Fainelli wrote:
>> It is not, otherwise I would have noticed earlier, can you try the same
>> thing that happens on my platform with a reserved region (without
>> no-map) adjacent to a reserved region with 'no-map'?
> 
> I just tried, but still no luck. FTR, I tried to reproduce your setup
> with the following DT:
> 
>          memory@40000000 {
>                  reg = <0x00 0x40000000 0x01 0x00>;
>                  device_type = "memory";
>          };
> 
>          reserved-memory {
>                  #address-cells = <2>;
>                  #size-cells = <2>;
>                  ranges;
> 
>                  foo@fdfff000{
>                          reg = <0x00 0xfdfff000 0x0 0x1000>;
>                  };
>                  bar@fe000000{
>                          reg = <0x00 0xfe000000 0x0 0x2000000>;
>                          no-map;
>                  };
>          };
> 
> And with 5.4.102 and 5.10.31 I get the following in /proc/iomem
> 
> <...>
> 40000000-fdffffff : System RAM
>    40080000-412cffff : Kernel code
>    412d0000-417affff : reserved
>    417b0000-419f8fff : Kernel data
>    48000000-48008fff : reserved
>    f7c00000-fdbfffff : reserved
>    fdfff000-fdffffff : reserved
> fe000000-ffffffff : reserved
> 100000000-13fffffff : System RAM
> <...>
> 
> which looks about right. I'll keep trying a few other things.

Did you get time to continue some tests on this issue ?

On my side this DT is not working:

memory@c0000000 {
         reg = <0xc0000000 0x20000000>;
};

reserved-memory {
         #address-cells = <1>;
         #size-cells = <1>;
         ranges;

         gpu_reserved: gpu@d4000000 {
                 reg = <0xd4000000 0x4000000>;
                 no-map;
         };
};

Let me know if I can help.

regards
Alex

> Thanks,
> Quentin
> 
