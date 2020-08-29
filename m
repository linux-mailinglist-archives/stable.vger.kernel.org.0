Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5B2567FE
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 15:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgH2N47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 09:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbgH2N47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Aug 2020 09:56:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F08BE208A9;
        Sat, 29 Aug 2020 13:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598709418;
        bh=8dNd/+HarCuZT6TLxU41GXJj/D7iMLgdNwDKWpUYY3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=savD7E7xyfXbOUYCfubBXQWeCIgPYKBSzqPuxelbZrXSYVhjTxYrevZPe5QNR9jBf
         Eisnnzj2ll4AHNysVWx7KjUh9hp4rljIasZKAHXqCe8eMOIfB6QAKh7aHjw1iLxlWQ
         Qpjv/VM6JK6A9F90UzhFnc3nsDVgSNeVP++gJ5zw=
Date:   Sat, 29 Aug 2020 09:56:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Victor Kamensky <kamensky@cisco.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        richard.purdie@linuxfoundation.org,
        Tony Ambardar <itugrok@yahoo.com>
Subject: Re: [PATCH AUTOSEL 5.4 10/58] mips: vdso: fix 'jalr t9' crash in
 vdso code
Message-ID: <20200829135656.GX8670@sasha-vm>
References: <20200305171420.29595-1-sashal@kernel.org>
 <20200305171420.29595-10-sashal@kernel.org>
 <d10c1981-ab79-86a9-4cf4-bd098d8c55f4@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d10c1981-ab79-86a9-4cf4-bd098d8c55f4@hauke-m.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 29, 2020 at 03:08:01PM +0200, Hauke Mehrtens wrote:
>On 3/5/20 6:13 PM, Sasha Levin wrote:
>> From: Victor Kamensky <kamensky@cisco.com>
>>
>> [ Upstream commit d3f703c4359ff06619b2322b91f69710453e6b6d ]
>>
>> Observed that when kernel is built with Yocto mips64-poky-linux-gcc,
>> and mips64-poky-linux-gnun32-gcc toolchain, resulting vdso contains
>> 'jalr t9' instructions in its code and since in vdso case nobody
>> sets GOT table code crashes when instruction reached. On other hand
>> observed that when kernel is built mips-poky-linux-gcc toolchain, the
>> same 'jalr t9' instruction are replaced with PC relative function
>> calls using 'bal' instructions.
>>
>> The difference boils down to -mrelax-pic-calls and -mexplicit-relocs
>> gcc options that gets different default values depending on gcc
>> target triplets and corresponding binutils. -mrelax-pic-calls got
>> enabled by default only in mips-poky-linux-gcc case. MIPS binutils
>> ld relies on R_MIPS_JALR relocation to convert 'jalr t9' into 'bal'
>> and such relocation is generated only if -mrelax-pic-calls option
>> is on.
>>
>> Please note 'jalr t9' conversion to 'bal' can happen only to static
>> functions. These static PIC calls use mips local GOT entries that
>> are supposed to be filled with start of DSO value by run-time linker
>> (missing in VDSO case) and they do not have dynamic relocations.
>> Global mips GOT entries must have dynamic relocations and they should
>> be prevented by cmd_vdso_check Makefile rule.
>>
>> Solution call out -mrelax-pic-calls and -mexplicit-relocs options
>> explicitly while compiling MIPS vdso code. That would get correct
>> and consistent between different toolchains behaviour.
>>
>> Reported-by: Bruce Ashfield <bruce.ashfield@gmail.com>
>> Signed-off-by: Victor Kamensky <kamensky@cisco.com>
>> Signed-off-by: Paul Burton <paulburton@kernel.org>
>> Cc: linux-mips@vger.kernel.org
>> Cc: Ralf Baechle <ralf@linux-mips.org>
>> Cc: James Hogan <jhogan@kernel.org>
>> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
>> Cc: richard.purdie@linuxfoundation.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/mips/vdso/Makefile | 1 +
>>  1 file changed, 1 insertion(+)
>>
>
>Hi Sasha,
>
>Why was this not added to the 5.4 stable branch?
>
>Some OpenWrt users ran into this problem with kernel 5.4 on MIPS64 [0].
>We backported this patch on our own in OpenWrt [1], but it should be
>added to the sable branch in my opinion as it fixes a real problem.
>
>@Sasha: Can you add it to the 5.4 stable branch or should I send some
>special email?

It failed building on 5.4. If you'd like it included, please send me a
tested backport for 5.4.

-- 
Thanks,
Sasha
