Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9E55B6E8B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 15:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiIMNpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 09:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiIMNpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 09:45:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB692CC92
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 06:45:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49CE7B80E07
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 13:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41C3C433C1;
        Tue, 13 Sep 2022 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663076726;
        bh=bBd9EEgMWVhwpjXD4tN72Gypfr3qp9/TdhRqxnC7VLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UzPvczsmyx02VWo1TLEZp88t7eFkOC3NP1a+BYv/Pxq6tWCeo1nEqnquCTPn3caSI
         NUoEwEXjZ1hbBLQ8ZhU7IsiHRIKSHoS3OOKB+NYuzw/50n6LTiEDd2ySVWFSDqGrR3
         2/TpjmkT3yuX66btmxGQ/KxladGoj9sA+spI1czasAnNgY4KECUAdrelocvLlLQ3JM
         /VHK7e8ZxkS6RZCszGjK7syBnhVAwaVsA931uuNolngloMYKu0ebYDlG+n4aC4LD2i
         a8IMuELJxzsLyOM5RBJHLScsGze3e9VHAmJ4AR9pFz3Mpxa76IkhRmzQkqLw4qM1rP
         NTvI6KzLzRfCQ==
Date:   Tue, 13 Sep 2022 09:45:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Claudiu.Beznea@microchip.com
Cc:     naresh.kamboju@linaro.org, stable@vger.kernel.org,
        lkft-triage@lists.linaro.org, gregkh@linuxfoundation.org,
        Frederic.Schumacher@microchip.com
Subject: Re: stable-rc: 5.15: arch/arm/mach-at91/pm.c:370:52: error:
 'DDR3PHY_ZQ0SR0' undeclared (first use in this function)
Message-ID: <YyCJcxDOYBPM8z7y@sashalap>
References: <CA+G9fYs-K=tN=By5-ZmYw-QT196TB_h+8qLNRRhL9beMpuAKiA@mail.gmail.com>
 <7db0ccb7-7324-9442-fcc1-548309a4b9b7@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7db0ccb7-7324-9442-fcc1-548309a4b9b7@microchip.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 12:28:31PM +0000, Claudiu.Beznea@microchip.com wrote:
>On 13.09.2022 14:27, Naresh Kamboju wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On stable-rc 5.15 arm builds failed due to following errors / warnings.
>>
>> arch/arm/mach-at91/pm.c: In function 'at91_suspend_finish':
>> arch/arm/mach-at91/pm.c:370:52: error: 'DDR3PHY_ZQ0SR0' undeclared
>> (first use in this function)
>>   370 |                 tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
>>       |                                                    ^~~~~~~~~~~~~~
>> include/uapi/linux/byteorder/little_endian.h:35:51: note: in
>> definition of macro '__le32_to_cpu'
>>    35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
>>       |                                                   ^
>> arch/arm/include/asm/io.h:303:46: note: in expansion of macro 'readl_relaxed'
>>   303 | #define readl(c)                ({ u32 __v = readl_relaxed(c);
>> __iormb(); __v; })
>>       |                                              ^~~~~~~~~~~~~
>> arch/arm/mach-at91/pm.c:370:23: note: in expansion of macro 'readl'
>>   370 |                 tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
>>       |                       ^~~~~
>> arch/arm/mach-at91/pm.c:370:52: note: each undeclared identifier is
>> reported only once for each function it appears in
>>   370 |                 tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
>>       |                                                    ^~~~~~~~~~~~~~
>> include/uapi/linux/byteorder/little_endian.h:35:51: note: in
>> definition of macro '__le32_to_cpu'
>>    35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
>>       |                                                   ^
>> arch/arm/include/asm/io.h:303:46: note: in expansion of macro 'readl_relaxed'
>>   303 | #define readl(c)                ({ u32 __v = readl_relaxed(c);
>> __iormb(); __v; })
>>       |                                              ^~~~~~~~~~~~~
>> arch/arm/mach-at91/pm.c:370:23: note: in expansion of macro 'readl'
>>   370 |                 tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
>>       |                       ^~~~~
>> arch/arm/mach-at91/pm.c:373:33: error: 'DDR3PHY_ZQ0SR0_PDO_OFF'
>> undeclared (first use in this function)
>>   373 |                 index = (tmp >> DDR3PHY_ZQ0SR0_PDO_OFF) & 0x1f;
>>       |                                 ^~~~~~~~~~~~~~~~~~~~~~
>> arch/arm/mach-at91/pm.c:377:33: error: 'DDR3PHY_ZQ0SR0_PUO_OFF'
>> undeclared (first use in this function)
>>   377 |                 index = (tmp >> DDR3PHY_ZQ0SR0_PUO_OFF) & 0x1f;
>>       |                                 ^~~~~~~~~~~~~~~~~~~~~~
>> arch/arm/mach-at91/pm.c:381:33: error: 'DDR3PHY_ZQ0SR0_PDODT_OFF'
>> undeclared (first use in this function)
>>   381 |                 index = (tmp >> DDR3PHY_ZQ0SR0_PDODT_OFF) & 0x1f;
>>       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~
>> arch/arm/mach-at91/pm.c:385:33: error: 'DDR3PHY_ZQ0SRO_PUODT_OFF'
>> undeclared (first use in this function)
>>   385 |                 index = (tmp >> DDR3PHY_ZQ0SRO_PUODT_OFF) & 0x1f;
>>       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~
>> make[2]: *** [scripts/Makefile.build:289: arch/arm/mach-at91/pm.o] Error 1
>>
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>
>> Build link:
>>  - https://builds.tuxbuild.com/2EfrKWiY7k1znh1Nt7nFQmRuyRc/
>>
>> # To install tuxmake on your system globally:
>> # sudo pip3 install -U tuxmake
>> #
>>
>> tuxmake --runtime podman --target-arch arm --toolchain gcc-11
>> --kconfig at91_dt_defconfig
>>
>> Following patch seems to be causing these build failures on stable-rc 5.15.
>> ---
>> ARM: at91: pm: fix DDR recalibration when resuming from backup and self-refresh
>> [ Upstream commit 7a94b83a7dc551607b6c4400df29151e6a951f07 ]
>>
>> On SAMA7G5, when resuming from backup and self-refresh, the bootloader
>> performs DDR PHY recalibration by restoring the value of ZQ0SR0 (stored
>> in RAM by Linux before going to backup and self-refresh). It has been
>> discovered that the current procedure doesn't work for all possible values
>> that might go to ZQ0SR0 due to hardware bug. The workaround to this is to
>> avoid storing some values in ZQ0SR0. Thus Linux will read the ZQ0SR0
>> register and cache its value in RAM after processing it (using
>> modified_gray_code array). The bootloader will restore the processed value.
>>
>> Fixes: d2d4716d8384 ("ARM: at91: pm: save ddr phy calibration data to securam")
>> Suggested-by: Frederic Schumacher <frederic.schumacher@microchip.com>
>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>> Link: https://lore.kernel.org/r/20220826083927.3107272-4-claudiu.beznea@microchip.com
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Hi,
>
>This depends on:
>
>commit dc3005703f8cd893d325081c20b400e08377d9bb
>Author: Claudiu Beznea <claudiu.beznea@microchip.com>
>Date:   Thu Jan 13 16:48:51 2022 +0200
>
>    ARM: at91: ddr: remove CONFIG_SOC_SAMA7 dependency
>
>    Remove CONFIG_SOC_SAMA7 dependency to avoid having #ifdef preprocessor
>    directives in driver code (arch/arm/mach-at91/pm.c). This prepares the
>    code for next commits.
>
>    Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>    Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>    Link:
>https://lore.kernel.org/r/20220113144900.906370-2-claudiu.beznea@microchip.com
>
>Apologies for not mentioning it.

I've queued it up, thanks!

-- 
Thanks,
Sasha
