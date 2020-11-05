Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65702A82F8
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgKEQEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:04:44 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:45490 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgKEQEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 11:04:43 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A5G4Z32034127;
        Thu, 5 Nov 2020 10:04:35 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604592275;
        bh=Tkak3lHBbbhAsRhTyoXbxbfPQtNqMPrBhg42KssZeVQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=f1HweYtXYwYEGlCH23bYEZOfjMxEwZDUKMbbp9yvBM4p/eqPHurheYtC991kfcWwD
         EwZJKACrccsFGVXihaCO/vUTY6Yzhqo6t7fOkisJuAjhGrfnIBTPQTjnJQV41wG3Ks
         mRKWu70lVnt1JojgsyqnqmH1AlmpHKuFneRDkQdY=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A5G4ZoL013724
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Nov 2020 10:04:35 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 5 Nov
 2020 10:04:35 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 5 Nov 2020 10:04:35 -0600
Received: from [10.250.233.179] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A5G4Xla099908;
        Thu, 5 Nov 2020 10:04:34 -0600
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
 <31ce9a84-d949-c1d1-a8c6-44ead119ca1b@ti.com>
 <2198bd20e69be374f7533f45118c98750eb5362a.camel@infinera.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <1af99b7d-e388-3c41-a8d8-9f82067ae857@ti.com>
Date:   Thu, 5 Nov 2020 21:34:32 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2198bd20e69be374f7533f45118c98750eb5362a.camel@infinera.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/4/20 3:23 PM, Joakim Tjernlund wrote:
> On Wed, 2020-11-04 at 11:12 +0530, Vignesh Raghavendra wrote:
>> Hi Joakim
>>
>> On 10/31/20 4:56 PM, Joakim Tjernlund wrote:
>>> On Fri, 2020-10-30 at 19:52 +0100, Miquel Raynal wrote:
>>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>>>>
>>>>
[...]
>> commit 4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling
>> status register") was added in 5.3 and therefore is part of 5.4. But
>> note that this is a "new feature" and therefore won't be backported to
>> kernels older than 5.3.
> 
> Oh, my memory is off then, sorry.
> 
>> Similarly, this patch (when accepted) is not a candidate for stable
>> kernel backports because the intention of enabling polling status
>> register for Write Completion is to enable flashes that "don't" support
>> DQ polling at all (mainly HyperFlash).
>> Enabling this for all flashes that support the feature is not a bug fix
>> IMO. Also, there isn't enough testing to prove that feature works for
>> all CFI NOR flashes on all platforms and therefore would be risky to be
>> backported to stable kernels.
> 
> This is 2 things,
>  1. making it possible to use Hyper flash (HW enablement)
>  2. improving the flash driver to function more precise(getting an accurate error rather than a TMO) for most AMD flashes.
> 
> 1. happens on a regular basis in stable.
> 2. can be discussed for stable but should at least go into master now that status has been in there for a while
> 

Yes, but my objection is that there has not been enough testing to prove
that its safe to backport to stable kernels and there is nothing that's
broken in older kernels which this patch fixes.


Regards
Vignesh
