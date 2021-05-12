Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E6A37BCBC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhELMp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:45:29 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:22792 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233182AbhELMp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:45:29 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CCc9HY007980;
        Wed, 12 May 2021 14:44:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=Sdiz04I1eZ4tZNAdMz6Zqee8SEhTjRnafOqx+r8AJxY=;
 b=HLKFvyBumNJb2ATy5rSpigSmr8Bk4cQCx02DFapETO0C4tgDsbEDZ6xYytTyxhOTBRjw
 PvGUA5ivmmriLjiuXNhOPI3cy/wTiIskzzABnCdjJmLTRv7h4Bze5jBCYpZxUJqUog5J
 d+DXBPrcZxQySJ7Zqxe+2pIutK35/9hdkCq28XOTGW++PjBuxL9sBTq4an8tN4vPGf90
 Z3LE35rwNhPeCSoZWcRO2UrqTtZS3zWLgT/5iWRjKPuJxwj9lufEdiKIyGBZIy+/4uQG
 7C/9N/sqgjN+JZKSvalbDPqJ356oXzFHhe+LbuKlTGsT0HlWW808g28pN/mhkWSaLZV9 Jw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 38g3jabsk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 14:44:06 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 210E810002A;
        Wed, 12 May 2021 14:44:06 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node3.st.com [10.75.127.6])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DD70E221F7D;
        Wed, 12 May 2021 14:44:05 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.51) by SFHDAG2NODE3.st.com
 (10.75.127.6) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:44:04 +0200
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
References: <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
 <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
 <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
 <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
 <YH/ixPnHMxNo08mJ@google.com>
 <cc8f96a4-6c85-b869-d3cf-5dc543982054@gmail.com>
 <YIFzMkW+tXonTf0K@google.com>
 <ad90b2bb-0fab-9f06-28dd-038e8005490b@foss.st.com>
 <YJkGSb72aKg6ScGo@google.com>
 <e1da4a98-7521-518f-f85a-51e9c58b1fc3@foss.st.com>
 <YJvLSbGh0YPRo0S2@google.com>
From:   Alexandre TORGUE <alexandre.torgue@foss.st.com>
Message-ID: <2f384c1f-e897-e458-4562-8a7c0bd338e1@foss.st.com>
Date:   Wed, 12 May 2021 14:44:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YJvLSbGh0YPRo0S2@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE3.st.com
 (10.75.127.6)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_06:2021-05-12,2021-05-12 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/12/21 2:34 PM, Quentin Perret wrote:
> On Wednesday 12 May 2021 at 12:55:53 (+0200), Alexandre TORGUE wrote:
>> We saw that patches [1] and [2] cause issue on stable version (at least for
>> 5.4). As you said issue can be seen with above device tree and check in
>> /proc/iomem than gpu_reserved region is taken by the kernel as "System RAM".
>>
>> On v5.10 stream there are no issues seen taking patches [1]&[2] and the
>> reason is linked to patches [3]&[4] which have been introduced in v5.10.0.
>> Reverting them give me the same behavior than on stable version.
> 
> Thanks for confirming. Given that the patches were not really fixes, I
> think reverting is still the best option. I've sent reverts to -stable
> for 5.4 and prior:
> 
> https://lore.kernel.org/stable/20210512122853.3243417-1-qperret@google.com/
> 

Thanks Quentin.

alex

> Cheers,
> Quentin
> 

