Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC283A36C2
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFJWCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhFJWCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77667613F1;
        Thu, 10 Jun 2021 22:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623362438;
        bh=nucnG5/QbJ/UafKRCt55CqTzS6+sHQTAWpyRcFUheUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OKDp/WO/2bZ7+KuIi5wq/GKNwZymdnRr5mMC5N4kLONwm3q39r4C4LUf0oS0wvBhK
         wGZxbu1b58cfY8QfKIKVwwWNH2snT2EWNjbsSznxKJmHA/RsXHqMHouhk6RcTldiQF
         d5QWj/ZQ3ui5F753H6wYJvaiAdlEMknnlA5SfAOEHuVMY9Q4YTHwJINXKZllTZkqXX
         BDR5ikIdLCN3cjPGA0KoHgMdewY3wDN7MV8lK98ML37yKwzsXzcLfhKpr55W2hHULT
         IGXttB4srUQLbSSyM6t7wNaJtdAZWPAhnX8gthnHxr5yQUXVAmumx0g78UPruQGNWC
         oLfODFtKbYMHA==
Date:   Thu, 10 Jun 2021 18:00:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH AUTOSEL 5.12 42/43] powerpc/fsl: set
 fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
Message-ID: <YMKLhWMfYf4pQYOo@sashalap>
References: <20210603170734.3168284-1-sashal@kernel.org>
 <20210603170734.3168284-42-sashal@kernel.org>
 <87y2bqfok8.fsf@mpe.ellerman.id.au>
 <81ce50f1-73eb-687b-898a-df5f6ac68c5a@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <81ce50f1-73eb-687b-898a-df5f6ac68c5a@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 12:58:54AM +0000, Chris Packham wrote:
>
>On 4/06/21 12:42 pm, Michael Ellerman wrote:
>> Sasha Levin <sashal@kernel.org> writes:
>>> From: Chris Packham <chris.packham@alliedtelesis.co.nz>
>>>
>>> [ Upstream commit 7adc7b225cddcfd0f346d10144fd7a3d3d9f9ea7 ]
>>>
>>> The i2c controllers on the P2040/P2041 have an erratum where the
>>> documented scheme for i2c bus recovery will not work (A-004447). A
>>> different mechanism is needed which is documented in the P2040 Chip
>>> Errata Rev Q (latest available at the time of writing).
>>>
>>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
>>> Acked-by: Michael Ellerman <mpe@ellerman.id.au>
>>> Signed-off-by: Wolfram Sang <wsa@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>   arch/powerpc/boot/dts/fsl/p2041si-post.dtsi | 16 ++++++++++++++++
>>>   1 file changed, 16 insertions(+)
>> This patch (and the subsequent one), just set a flag in the device tree.
>>
>> They have no effect unless you also backport the code change that looks
>> for that flag, which was upstream commit:
>>
>>    8f0cdec8b5fd ("i2c: mpc: implement erratum A-004447 workaround")
>
>That change itself isn't cherry-pick able without
>
>65171b2df15e ("i2c: mpc: Make use of i2c_recover_bus()")
>
>and in between 65171b2df15e and 8f0cdec8b5fd are a bunch of cleanups and
>a fairly major rewrite which may also affect the cherry-pick ability.
>
>> AFAICS you haven't picked that one up for any of the stable trees.
>>
>> I'll defer to Chris & Wolfram on whether it's a good idea to take the
>> code change for stable.
>
>We have been doing some extra QA on our end for the "i2c: mpc: Refactor
>to improve responsiveness" and "P2040/P2041 i2c recovery erratum" series
>which hasn't thrown up any issues. But it's still a lot of new code and
>at some point we're going to run into API changes.
>
>Given the fact that it's starting to snowball one might err on the side
>of caution.
>
>> I guess it's harmless to pick these two patches, but it's also
>> pointless. So I think you either want to take all three, or drop these
>> two.
>
>At a minimum you need
>
>65171b2df15e ("i2c: mpc: Make use of i2c_recover_bus()")
>8f0cdec8b5fd ("i2c: mpc: implement erratum A-004447 workaround")
>7adc7b225cdd ("powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041
>i2c controllers")
>19ae697a1e4e ("powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010
>i2c controllers")

I'll take the two additional commits, thanks!

-- 
Thanks,
Sasha
