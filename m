Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6EB115641
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 18:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfLFRPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 12:15:21 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18289 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfLFRPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 12:15:21 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dea8c970000>; Fri, 06 Dec 2019 09:15:03 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 06 Dec 2019 09:15:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 06 Dec 2019 09:15:20 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec
 2019 17:15:20 +0000
Received: from [10.2.166.36] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec 2019
 17:15:19 +0000
Subject: Re: [PATCH v3 09/15] ASoC: tegra: Add fallback for audio mclk
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>
References: <1575600438-26795-1-git-send-email-skomatineni@nvidia.com>
 <1575600438-26795-10-git-send-email-skomatineni@nvidia.com>
 <20191206070912.GB1318959@kroah.com>
 <6fef4ee1-0528-9f8e-cb25-4af126d33b99@nvidia.com>
 <20191206162934.GA86904@kroah.com>
 <febf1f1a-6cca-c4d1-e220-50af5ef13ff7@nvidia.com>
Message-ID: <bb19856c-ced5-1627-c5eb-ef44bbd177ae@nvidia.com>
Date:   Fri, 6 Dec 2019 09:15:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <febf1f1a-6cca-c4d1-e220-50af5ef13ff7@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575652503; bh=Ha30IeK9dQpJMa7MVA9eoSW7mD8wVYCw0GVIgOnoUIg=;
        h=X-PGP-Universal:Subject:From:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Transfer-Encoding:
         Content-Language;
        b=khoJAzbHgjckYbMYdN64v9UB2eEn4VSlXw5mZQ7n/GvuiiSchzl7Y/DckOyGr9YpM
         zdxeQDbCRqvsGWOpE+MedOk/xWN/jBWOb5Sj8baQm4osfkXakmIktVFO+m8EqXfmZ6
         TyyIjn/JTdqxeh+B3HgutWuzryJ8FhOBEm38XIqTEv2BRynXgHqtwpfr1DLkRO1Cxe
         HH+H08AP8Py/iM9i770Mo0EIuq14Mj85jptUQ5wa+OPGXLe+Dj86n11IFkeOERihFw
         7QkjyZJf93tJLeG1rD4wvBRpCHAsnfKBF7nJjcvx11adThk+DreUMXLYN2O8whIwJ3
         yDzH0WSo9DiAg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/6/19 9:11 AM, Sowjanya Komatineni wrote:
>
> On 12/6/19 8:29 AM, Greg KH wrote:
>> On Fri, Dec 06, 2019 at 08:19:26AM -0800, Sowjanya Komatineni wrote:
>>> On 12/5/19 11:09 PM, Greg KH wrote:
>>>> On Thu, Dec 05, 2019 at 06:47:12PM -0800, Sowjanya Komatineni wrote:=

>>>>> mclk is from clk_out_1 which is part of Tegra PMC block and pmc=20
>>>>> clocks
>>>>> are moved to Tegra PMC driver with pmc as clock provider and using =

>>>>> pmc
>>>>> clock ids.
>>>>>
>>>>> New device tree uses clk_out_1 from pmc clock provider.
>>>>>
>>>>> So, this patch adds fallback to extern1 in case of retrieving mclk =

>>>>> fails
>>>>> to be backward compatible of new device tree with older kernels.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>>
>>>>> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
>>>>> ---
>>>>> =C2=A0=C2=A0 sound/soc/tegra/tegra_asoc_utils.c | 10 ++++++++--
>>>>> =C2=A0=C2=A0 1 file changed, 8 insertions(+), 2 deletions(-)
>>>> <formletter>
>>>>
>>>> This is not the correct way to submit patches for inclusion in the
>>>> stable kernel tree.=C2=A0 Please read:
>>>> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.h=
tml=20
>>>>
>>>> for how to do this properly.
>>>>
>>>> </formletter>
>>> Hi Greg,
>>>
>>> link says to option-1 is strongly preferred for for all patches=20
>>> except for
>>> submissions that are not in net/ and security related.
>>>
>>> Option-1 is to add Cc: stable@vger.kernel.org in sign-off area and I
>>> followed this.
>> That's fine, but then why did you just email a patch to yourself and t=
he
>> list?=C2=A0 Shouldn't you also submit the patch upstream to get it pro=
perly
>> merged first?
>>
>> thanks,
>>
>> greg k-h
>
> I set patches to the mailing list as per get_maintainers script.
>
> Do I need to add any other alias to get patch applied for stable=20
> kernel other than cc tag?
>
Does this patch need to be sent separate to upstream (not part of this=20
series) with cc stable tag?
-------------------------------------------------------------------------=
----------
This email message is for the sole use of the intended recipient(s) and m=
ay contain
confidential information.  Any unauthorized review, use, disclosure or di=
stribution
is prohibited.  If you are not the intended recipient, please contact the=
=20sender by
reply email and destroy all copies of the original message.
-------------------------------------------------------------------------=
----------
