Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D381154FB
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 17:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfLFQT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 11:19:28 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2757 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfLFQT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 11:19:28 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dea7f8a0001>; Fri, 06 Dec 2019 08:19:22 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 06 Dec 2019 08:19:27 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 06 Dec 2019 08:19:27 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec
 2019 16:19:26 +0000
Received: from [10.2.166.36] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec 2019
 16:19:26 +0000
Subject: Re: [PATCH v3 09/15] ASoC: tegra: Add fallback for audio mclk
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>
References: <1575600438-26795-1-git-send-email-skomatineni@nvidia.com>
 <1575600438-26795-10-git-send-email-skomatineni@nvidia.com>
 <20191206070912.GB1318959@kroah.com>
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
Message-ID: <6fef4ee1-0528-9f8e-cb25-4af126d33b99@nvidia.com>
Date:   Fri, 6 Dec 2019 08:19:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191206070912.GB1318959@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575649162; bh=r31QzvTEEUxztS18HXHk4INrtWW/PAtQkWMBptFAuio=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Transfer-Encoding:
         Content-Language;
        b=FqIDZplsXm6sHdBXN77lwaJY1KZODDZvWYKNnicfL6U6ybQQGAg2Qu9fXX5vPV16j
         OkSvaxzLPjoNF/DtAlhn/EAbjViSB2ZipDaDXV/NDD9SsYm6DmJoyM5/t9sW+j7NwH
         AEXCUfnnOjm421hqDs10catGoUdiRdx0uMkBHnFzc29cz3likgbiHvY5KFuKNt5FRr
         jc0kwACUnjvZvfwPapku3W2i2Vvw+Afox+HYbw+5jZY9QOH9d+w/qJKePh4RmzxLgl
         cKGxhNuXyCK6uuOssDgYggtwFRMxxyaDHAGL0FQByDGgzmTewGGosQEFi+vgFifdB8
         ftLuETVrT16pw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/5/19 11:09 PM, Greg KH wrote:
> On Thu, Dec 05, 2019 at 06:47:12PM -0800, Sowjanya Komatineni wrote:
>> mclk is from clk_out_1 which is part of Tegra PMC block and pmc clocks
>> are moved to Tegra PMC driver with pmc as clock provider and using pmc
>> clock ids.
>>
>> New device tree uses clk_out_1 from pmc clock provider.
>>
>> So, this patch adds fallback to extern1 in case of retrieving mclk fails
>> to be backward compatible of new device tree with older kernels.
>>
>> Cc: stable@vger.kernel.org
>>
>> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
>> ---
>>   sound/soc/tegra/tegra_asoc_utils.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>

Hi Greg,

link says to option-1 is strongly preferred for for all patches except 
for submissions that are not in net/ and security related.

Option-1 is to add Cc: stable@vger.kernel.org in sign-off area and I 
followed this.

Please help if I miss understood your feedback.

Thanks



-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
