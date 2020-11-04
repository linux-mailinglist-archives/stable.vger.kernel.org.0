Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4A92A5DE9
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 06:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgKDFmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 00:42:22 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:48316 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgKDFmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 00:42:22 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A45gCdq082908;
        Tue, 3 Nov 2020 23:42:12 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604468532;
        bh=ZMjFopd0KFk9SYTJqQxgo4gVMZEmtDRUKhJ2peyg/qM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=A+1jORDTV7CNDlzG5SivsreGYMBBeN4SG1UnuV6ZxTmR8yazdt1NZ6DbLy8/j6GZ+
         1b2QcmwN/I8K6JS5eVY5suGKM4e9kO2bJUqWfehUtg+To1U6UrQfQxh5Z+WLqtgN7K
         Ik35AF8jcnuQGvcOsHr5MXFBSJ23qB/fsqjejT1Y=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A45gCrs090057
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Nov 2020 23:42:12 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 3 Nov
 2020 23:42:12 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 3 Nov 2020 23:42:11 -0600
Received: from [10.250.233.179] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A45g9x6085297;
        Tue, 3 Nov 2020 23:42:10 -0600
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
References: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
 <20201030184736.4ec434f5@xps13>
 <aefef0187e5ebbe315e57e834ff1ba756ba88817.camel@infinera.com>
 <20201030195251.687809f7@xps13>
 <931f422255204f0420e6f1b79657f9770ce0cf6e.camel@infinera.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <31ce9a84-d949-c1d1-a8c6-44ead119ca1b@ti.com>
Date:   Wed, 4 Nov 2020 11:12:09 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <931f422255204f0420e6f1b79657f9770ce0cf6e.camel@infinera.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joakim

On 10/31/20 4:56 PM, Joakim Tjernlund wrote:
> On Fri, 2020-10-30 at 19:52 +0100, Miquel Raynal wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>>
>>
>> Hi Joakim,
>>
>> Joakim Tjernlund <Joakim.Tjernlund@infinera.com> wrote on Fri, 30 Oct
>> 2020 18:39:35 +0000:
>>
>>> On Fri, 2020-10-30 at 18:47 +0100, Miquel Raynal wrote:
>>>>
>>>> Hi Joakim,
>>>
>>> Hi Miquel
>>>
>>>>
>>>> Please Cc the MTD maintainers, not only the list (get_maintainers.pl).
>>>
>>> I figure all maintainers are on the list ?
>>
>> I personally don't look at the list very often. I expect patches to be
>> directed to me (in the current case, Vignesh) when I am concerned.
> 
> Added Vignesh
> 

As Miquel suggested, I look at patches on mailing list at a lower
priority than patches that are CC'd to me.


>>
>>>
>>>>
>>>> Joakim Tjernlund <joakim.tjernlund@infinera.com> wrote on Thu, 22 Oct
>>>> 2020 17:45:06 +0200:
>>>>
>>>>> Commit "mtd: cfi_cmdset_0002: Add support for polling status register"
>>>>> added support for polling the status rather than using DQ polling.
>>>>> However, status register is used only when DQ polling is missing.
>>>>> Lets use status register when available as it is superior to DQ polling.
>>>>>
>>>>
>>>> I will let vignesh comment about the content (looks fine by me) but you will
>>>> need a Fixes tag here.
>>>
>>> This is not a Fixes situation, no bug just a hw enabling thing.
>>> Also, I would like to see the Status patches be backported to 4.19 as well.
>>
>> Backporting features is IMHO not relevant. I guess stable kernel only
>> take fixes...
> 
> This is not a feature really and the 5.4 stable did get them, I ask 4.19 get them too.
> 

commit 4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling
status register") was added in 5.3 and therefore is part of 5.4. But
note that this is a "new feature" and therefore won't be backported to
kernels older than 5.3.

Similarly, this patch (when accepted) is not a candidate for stable
kernel backports because the intention of enabling polling status
register for Write Completion is to enable flashes that "don't" support
DQ polling at all (mainly HyperFlash).
Enabling this for all flashes that support the feature is not a bug fix
IMO. Also, there isn't enough testing to prove that feature works for
all CFI NOR flashes on all platforms and therefore would be risky to be
backported to stable kernels.

Regards
Vignehs

