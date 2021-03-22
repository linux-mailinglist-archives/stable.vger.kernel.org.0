Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7B234394E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 07:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCVGRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 02:17:13 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:61903 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhCVGQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 02:16:52 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F3km773xmz9tyNr;
        Mon, 22 Mar 2021 07:16:39 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id J0m3ymugyvRa; Mon, 22 Mar 2021 07:16:39 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F3km761Hcz9tyNH;
        Mon, 22 Mar 2021 07:16:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4550F8B776;
        Mon, 22 Mar 2021 07:16:44 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id cB3FgN3OxlXo; Mon, 22 Mar 2021 07:16:44 +0100 (CET)
Received: from [172.25.230.100] (po15451.idsi0.si.c-s.fr [172.25.230.100])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1146E8B75B;
        Mon, 22 Mar 2021 07:16:43 +0100 (CET)
Subject: Re: [PATCH 5.10 267/290] powerpc: Fix missing declaration of
 [en/dis]able_kernel_vsx()
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135551.044220754@linuxfoundation.org>
 <CAMuHMdUqDX8NSGNsw4R=-pEk+nNRsBPBhXD91bq4qy-v1ybcJQ@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <fed84796-e3b4-47fc-7f5f-57d53565aa73@csgroup.eu>
Date:   Mon, 22 Mar 2021 07:16:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUqDX8NSGNsw4R=-pEk+nNRsBPBhXD91bq4qy-v1ybcJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 15/03/2021 à 15:15, Geert Uytterhoeven a écrit :
> On Mon, Mar 15, 2021 at 3:04 PM <gregkh@linuxfoundation.org> wrote:
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> From: Christophe Leroy <christophe.leroy@csgroup.eu>
>>
>> commit bd73758803c2eedc037c2268b65a19542a832594 upstream.
>>
>> Add stub instances of enable_kernel_vsx() and disable_kernel_vsx()
>> when CONFIG_VSX is not set, to avoid following build failure.
> 
> Please note that this is not sufficient, and will just turn the build error
> in another, different build error.

Not exactly, the fix is sufficient in most case, it is only with ancient versions of gcc (eg 4.9) or 
with CONFIG_CC_OPTIMISE_FOR_SIZE that we now get a build bug. Building with gcc 10 now works.

> Waiting for the subsequent fix to enter v5.12-rc4...
> https://lore.kernel.org/lkml/2c123f94-ceae-80c0-90e2-21909795eb76@csgroup.eu/

This has now landed in mainline as commit eed5fae00593ab9d261a0c1ffc1bdb786a87a55a see 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/powerpc/include/asm/cpu_has_feature.h?h=v5.12-rc4&id=eed5fae00593ab9d261a0c1ffc1bdb786a87a55a

Christophe

> 
>>
>>    CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.o
>>    In file included from ./drivers/gpu/drm/amd/amdgpu/../display/dc/dm_services_types.h:29,
>>                     from ./drivers/gpu/drm/amd/amdgpu/../display/dc/dm_services.h:37,
>>                     from drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:27:
>>    drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c: In function 'dcn_bw_apply_registry_override':
>>    ./drivers/gpu/drm/amd/amdgpu/../display/dc/os_types.h:64:3: error: implicit declaration of function 'enable_kernel_vsx'; did you mean 'enable_kernel_fp'? [-Werror=implicit-function-declaration]
>>       64 |   enable_kernel_vsx(); \
>>          |   ^~~~~~~~~~~~~~~~~
>>    drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:640:2: note: in expansion of macro 'DC_FP_START'
>>      640 |  DC_FP_START();
>>          |  ^~~~~~~~~~~
>>    ./drivers/gpu/drm/amd/amdgpu/../display/dc/os_types.h:75:3: error: implicit declaration of function 'disable_kernel_vsx'; did you mean 'disable_kernel_fp'? [-Werror=implicit-function-declaration]
>>       75 |   disable_kernel_vsx(); \
>>          |   ^~~~~~~~~~~~~~~~~~
>>    drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:676:2: note: in expansion of macro 'DC_FP_END'
>>      676 |  DC_FP_END();
>>          |  ^~~~~~~~~
>>    cc1: some warnings being treated as errors
>>    make[5]: *** [drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.o] Error 1
>>
>> This works because the caller is checking if VSX is available using
>> cpu_has_feature():
>>
>>    #define DC_FP_START() { \
>>          if (cpu_has_feature(CPU_FTR_VSX_COMP)) { \
>>                  preempt_disable(); \
>>                  enable_kernel_vsx(); \
>>          } else if (cpu_has_feature(CPU_FTR_ALTIVEC_COMP)) { \
>>                  preempt_disable(); \
>>                  enable_kernel_altivec(); \
>>          } else if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE)) { \
>>                  preempt_disable(); \
>>                  enable_kernel_fp(); \
>>          } \
>>
>> When CONFIG_VSX is not selected, cpu_has_feature(CPU_FTR_VSX_COMP)
>> constant folds to 'false' so the call to enable_kernel_vsx() is
>> discarded and the build succeeds.
>>
>> Fixes: 16a9dea110a6 ("amdgpu: Enable initial DCN support on POWER")
>> Cc: stable@vger.kernel.org # v5.6+
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>> [mpe: Incorporate some discussion comments into the change log]
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> Link: https://lore.kernel.org/r/8d7d285a027e9d21f5ff7f850fa71a2655b0c4af.1615279170.git.christophe.leroy@csgroup.eu
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   arch/powerpc/include/asm/switch_to.h |   10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> --- a/arch/powerpc/include/asm/switch_to.h
>> +++ b/arch/powerpc/include/asm/switch_to.h
>> @@ -71,6 +71,16 @@ static inline void disable_kernel_vsx(vo
>>   {
>>          msr_check_and_clear(MSR_FP|MSR_VEC|MSR_VSX);
>>   }
>> +#else
>> +static inline void enable_kernel_vsx(void)
>> +{
>> +       BUILD_BUG();
>> +}
>> +
>> +static inline void disable_kernel_vsx(void)
>> +{
>> +       BUILD_BUG();
>> +}
>>   #endif
>>
>>   #ifdef CONFIG_SPE
> 
> Gr{oetje,eeting}s,
> 
>                          Geert
> 
