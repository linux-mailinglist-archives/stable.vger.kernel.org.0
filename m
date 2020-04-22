Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381971B343B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgDVA5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDVA5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 20:57:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43952071E;
        Wed, 22 Apr 2020 00:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587517057;
        bh=yF4IerkwF4biRl+OADsB8mxTEQrEvoTbOOESw96+zJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2LUpyG58mgT4D1es6Tuosf3vm8FN9eZ1fsiKVDO4vo3Rk2cfeBjFrVyRYJOwFBgL8
         bhJIdS1dRXWrj03h8H9GygWayv3vdavMgibz/qfEuLpMZoJ7B5BgV5smmaE68sXTUt
         /s5ZTXjuCQmg+JLBCYSd/OWDOpklIBKORt/zmiSo=
Date:   Tue, 21 Apr 2020 20:57:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Haren Myneni <haren@us.ibm.com>, Joe Perches <joe@perches.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 5.4 52/84] linux/bits.h: add compile time sanity
 check of GENMASK inputs
Message-ID: <20200422005735.GW1809@sasha-vm>
References: <20200415114442.14166-1-sashal@kernel.org>
 <20200415114442.14166-52-sashal@kernel.org>
 <20200415194032.GA935@rikard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200415194032.GA935@rikard>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 09:40:32PM +0200, Rikard Falkeborn wrote:
>On Wed, Apr 15, 2020 at 07:44:09AM -0400, Sasha Levin wrote:
>> From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
>>
>> [ Upstream commit 295bcca84916cb5079140a89fccb472bb8d1f6e2 ]
>>
>> GENMASK() and GENMASK_ULL() are supposed to be called with the high bit as
>> the first argument and the low bit as the second argument.  Mixing them
>> will return a mask with zero bits set.
>>
>> Recent commits show getting this wrong is not uncommon, see e.g.  commit
>> aa4c0c9091b0 ("net: stmmac: Fix misuses of GENMASK macro") and commit
>> 9bdd7bb3a844 ("clocksource/drivers/npcm: Fix misuse of GENMASK macro").
>>
>> To prevent such mistakes from appearing again, add compile time sanity
>> checking to the arguments of GENMASK() and GENMASK_ULL().  If both
>> arguments are known at compile time, and the low bit is higher than the
>> high bit, break the build to detect the mistake immediately.
>>
>> Since GENMASK() is used in declarations, BUILD_BUG_ON_ZERO() must be used
>> instead of BUILD_BUG_ON().
>>
>> __builtin_constant_p does not evaluate is argument, it only checks if it
>> is a constant or not at compile time, and __builtin_choose_expr does not
>> evaluate the expression that is not chosen.  Therefore, GENMASK(x++, 0)
>> does only evaluate x++ once.
>>
>> Commit 95b980d62d52 ("linux/bits.h: make BIT(), GENMASK(), and friends
>> available in assembly") made the macros in linux/bits.h available in
>> assembly.  Since BUILD_BUG_OR_ZERO() is not asm compatible, disable the
>> checks if the file is included in an asm file.
>>
>> Due to bugs in GCC versions before 4.9 [0], disable the check if building
>> with a too old GCC compiler.
>>
>> [0]: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=19449
>>
>> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Haren Myneni <haren@us.ibm.com>
>> Cc: Joe Perches <joe@perches.com>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Cc: lkml <linux-kernel@vger.kernel.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Link: http://lkml.kernel.org/r/20200308193954.2372399-1-rikard.falkeborn@gmail.com
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  include/linux/bits.h | 22 ++++++++++++++++++++--
>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/bits.h b/include/linux/bits.h
>> index 669d69441a625..f108302a3121c 100644
>> --- a/include/linux/bits.h
>> +++ b/include/linux/bits.h
>> @@ -18,12 +18,30 @@
>>   * position @h. For example
>>   * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
>>   */
>> -#define GENMASK(h, l) \
>> +#if !defined(__ASSEMBLY__) && \
>> +	(!defined(CONFIG_CC_IS_GCC) || CONFIG_GCC_VERSION >= 49000)
>> +#include <linux/build_bug.h>
>> +#define GENMASK_INPUT_CHECK(h, l) \
>> +	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
>> +		__builtin_constant_p((l) > (h)), (l) > (h), 0)))
>> +#else
>> +/*
>> + * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
>> + * disable the input check if that is the case.
>> + */
>> +#define GENMASK_INPUT_CHECK(h, l) 0
>> +#endif
>> +
>> +#define __GENMASK(h, l) \
>>  	(((~UL(0)) - (UL(1) << (l)) + 1) & \
>>  	 (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
>> +#define GENMASK(h, l) \
>> +	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
>>
>> -#define GENMASK_ULL(h, l) \
>> +#define __GENMASK_ULL(h, l) \
>>  	(((~ULL(0)) - (ULL(1) << (l)) + 1) & \
>>  	 (~ULL(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
>> +#define GENMASK_ULL(h, l) \
>> +	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_ULL(h, l))
>>
>>  #endif	/* __LINUX_BITS_H */
>> --
>> 2.20.1
>>
>
>This does not really fix anything, it's compile time prevention, so I
>don't know how appropriate this is for stable (it was also picked for
>5.5 and 5.6, but I'm just replying here now, I can ping the other
>selections if necessary if the patch should be dropped)?
>
>Also, for 5.4, it does somewhat depend on commit 8788994376d8
>("linux/build_bug.h: change type to int"). Without it, there may be a
>subtle integer promotion issue if sizeof(size_t) > sizeof(unsigned long)
>(I don't *think* such platform exists, but I don't have a warm a fuzzy
>feeling about it).

I'll drop it from this selection, but ideally I'd like to have it in.

The codebase is different between Linus's tree and the stable trees, and
I'm worried that some of these GENMASK issues were fixed upstream and
not in the stable trees. Getting this patch back would help us fix those
with minimal risk.

-- 
Thanks,
Sasha
