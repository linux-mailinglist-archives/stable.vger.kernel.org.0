Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85848365BEB
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhDTPNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 11:13:07 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:35988 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230260AbhDTPNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 11:13:06 -0400
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KF1RlA019235;
        Tue, 20 Apr 2021 17:12:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=XkzaeaHEPUBufkekuCWOY5e2EkqpjeHpvz6V3rrYL7g=;
 b=IpHrr2/VEpgkv9QWFsXDq0YGsbGV31wsMqFaoYonN8zcsrtKZ4OqPepd9xm1j09Z0GP9
 KPDrz2Ih5HtucIt8NTaHD29e5ris7AQ8l8RXZyDd0RT8UG4yzBCV6rMZ6DsvXBBIT6ch
 vsQCIiHwgQ4+GZwtFaoMeXlbR8MypODOf9pJ34uLihhXAWcSAA8om+TYZ/6H0QoP958C
 ZRo6uKeUYXfUNpnFlKBQL5FEnQIDL3L6qQGFON31OFnr7domlmNjw2NsPV25L+l9Y6bu
 Y8Ka8xyDjSFlbDHR1JdfQYqsw9VTTx/HzGcL0CXkzUmMB378swW9bZdGqjpJkbkDasi0 qw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 381x3v17yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 17:12:29 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CDA0C100034;
        Tue, 20 Apr 2021 17:12:27 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node3.st.com [10.75.127.6])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id B13ED24E5F0;
        Tue, 20 Apr 2021 17:12:27 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.49) by SFHDAG2NODE3.st.com
 (10.75.127.6) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 17:12:26 +0200
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Rob Herring <robh+dt@kernel.org>, <ardb@kernel.org>
CC:     Quentin Perret <qperret@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
From:   Alexandre TORGUE <alexandre.torgue@foss.st.com>
Message-ID: <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
Date:   Tue, 20 Apr 2021 17:12:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE3.st.com
 (10.75.127.6)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_07:2021-04-20,2021-04-20 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/20/21 4:45 PM, Rob Herring wrote:
> On Tue, Apr 20, 2021 at 9:03 AM Alexandre TORGUE
> <alexandre.torgue@foss.st.com> wrote:
>>
>> Hi,
> 
> Greg or Sasha won't know what to do with this. Not sure who follows
> the stable list either. Quentin sent the patch, but is not the author.
> Given the patch in question is about consistency between EFI memory
> map boot and DT memory map boot, copying EFI knowledgeable folks would
> help (Ard B for starters).

Ok thanks for the tips. I add Ard in the loop.

Ard, let me know if other people have to be directly added or if I have 
to resend to another mailing list.

thanks
alex

> 
>>
>> Since v5.4.102 I observe a regression on stm32mp1 platform: "no-map"
>> reserved-memory regions are no more "reserved" and make part of the
>> kernel System RAM. This causes allocation failure for devices which try
>> to take a reserved-memory region.
>>
>> It has been introduced by the following path:
>>
>> "fdt: Properly handle "no-map" field in the memory region
>> [ Upstream commit 86588296acbfb1591e92ba60221e95677ecadb43 ]"
>> which replace memblock_remove by memblock_mark_nomap in no-map case.
>>
>> Reverting this patch it's fine.
>>
>> I add part of my DT (something is maybe wrong inside):
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
>>
>> Sorry if this issue has already been raised and discussed.
>>
>> Thanks
>> alex
