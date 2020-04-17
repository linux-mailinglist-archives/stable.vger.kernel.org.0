Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7C71AE323
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 19:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgDQRGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 13:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgDQRGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 13:06:03 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00C3B20771;
        Fri, 17 Apr 2020 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587143162;
        bh=yzvetAbVpiaLVdfmAxZMZ7Knq0EnO5SErf91lV63dCQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lTnup2Atbd2Lvjr+R0STiF44puICPoxiy4kAuAchj+cezOuhCz2rkKUIcEDye3wz+
         RLlLtGGylM3ydtePh23XBMB064T2Th0aiiVGXg4VXhgwTi/yMajYtzwmWAzlOa/sHb
         tLwwEwWSvUhZhFoLXo0ChYSXfQ3YnKtCtyDnKznA=
Subject: Re: [PATCH 5.6 000/254] 5.6.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200416131325.804095985@linuxfoundation.org>
 <a83ee7a6-d13d-6929-e4be-669058714fd9@kernel.org>
 <20200417083813.GE141762@kroah.com>
From:   shuah <shuah@kernel.org>
Message-ID: <e3126e04-1887-7b77-a791-3e789845d08d@kernel.org>
Date:   Fri, 17 Apr 2020 11:05:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200417083813.GE141762@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/17/20 2:38 AM, Greg Kroah-Hartman wrote:
> On Thu, Apr 16, 2020 at 03:35:35PM -0600, shuah wrote:
>> On 4/16/20 7:21 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.6.5 release.
>>> There are 254 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.5-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Compiled and booted on my test system. No dmesg regressions.
>> reboot and poweroff hang forever. I saw this problem on
>> Linux 5.7rc1 as well.
>>
>> AMD Ryzen 5 PRO 2400GE
>>
>> I don't see this problem on Intel i7-8550U
>>
>> I haven't started debugging yet. I will have to go back and
>> check if it is introduced in 5.6.4-rc1. 5.6-3-rc2 is the last
>> good one.
>>
>> I will update you later on today with bisect data.
> 
> Oh nice, we are bug-compatible with mainline :(
> 

Okay success. I reverted it and Linux 5.6-rc1 no longer hangs
on reboot/poweroff

git bisect bad
a655a99c9f6a1d819d695fca6d48b450449f45ee is the first bad commit

Okay success. I reverted it and Linux 5.6-rc1 no longer hangs
on reboot/poweroff

I am building Linux 5.7-rc1 with this reverted now.

Details and full bisect log. I am building Linux 5.7-rc1 with
this reverted now.

commit a655a99c9f6a1d819d695fca6d48b450449f45ee
Author: Prike Liang <Prike.Liang@amd.com>
Date:   Tue Apr 7 20:21:26 2020 +0800

     drm/amdgpu: fix gfx hang during suspend with video playback (v2)

     [ Upstream commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58 ]

     The system will be hang up during S3 suspend because of SMU is pending
     for GC not respose the register CP_HQD_ACTIVE access request.This issue
     root cause of accessing the GC register under enter GFX CGGPG and can
     be fixed by disable GFX CGPG before perform suspend.

     v2: Use disable the GFX CGPG instead of RLC safe mode guard.

     Signed-off-by: Prike Liang <Prike.Liang@amd.com>
     Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
     Reviewed-by: Huang Rui <ray.huang@amd.com>
     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
     Cc: stable@vger.kernel.org
     Signed-off-by: Sasha Levin <sashal@kernel.org>

:040000 040000 95fb17ff249bfc19d8b65119fdcb5a4ced21d487 
7a62a4762daedbb41f0eda5831a116ad2c2b8077 M      drivers

Full bisect log:
git bisect start
# good: [0a27a29496060843ae3a8fe78aaec0062cbd5dfa] Linux 5.6.4
git bisect good 0a27a29496060843ae3a8fe78aaec0062cbd5dfa
# bad: [576aa353744ce5f1279071363e4a55e97f486f39] Linux 5.6.5-rc1
git bisect bad 576aa353744ce5f1279071363e4a55e97f486f39
# good: [7509db5d111a5763a199902052eecc480e0ec724] x86/tsc_msr: Make MSR 
derived TSC frequency more accurate
git bisect good 7509db5d111a5763a199902052eecc480e0ec724
# good: [15f1ead7d7966d087352ba2cf81a1759b25ad163] scsi: lpfc: Fix 
broken Credit Recovery after driver load
git bisect good 15f1ead7d7966d087352ba2cf81a1759b25ad163
# good: [9e52b4ab5fadd803c8c2e617aa8c151720757fb1] s390/diag: fix 
display of diagnose call statistics
git bisect good 9e52b4ab5fadd803c8c2e617aa8c151720757fb1
# good: [3e1e6903924fd6c95db7e46c5baa41dfa0f46fdb] 
powerpc/hash64/devmap: Use H_PAGE_THP_HUGE when setting up huge devmap 
PTE entries
git bisect good 3e1e6903924fd6c95db7e46c5baa41dfa0f46fdb
# good: [0344e0fee2f904ebce1d58bec8ace3ee9cf5f777] drm/dp_mst: Fix 
clearing payload state on topology disable
git bisect good 0344e0fee2f904ebce1d58bec8ace3ee9cf5f777
# bad: [136881c0420bb52d5f21f75688f5aee1cf401737] perf/core: Unify 
{pinned,flexible}_sched_in()
git bisect bad 136881c0420bb52d5f21f75688f5aee1cf401737
# bad: [0d928b424b99cfe0e7806c530f6039a053d5082d] drm/i915/ggtt: do not 
set bits 1-11 in gen12 ptes
git bisect bad 0d928b424b99cfe0e7806c530f6039a053d5082d
# bad: [a655a99c9f6a1d819d695fca6d48b450449f45ee] drm/amdgpu: fix gfx 
hang during suspend with video playback (v2)
git bisect bad a655a99c9f6a1d819d695fca6d48b450449f45ee
# first bad commit: [a655a99c9f6a1d819d695fca6d48b450449f45ee] 
drm/amdgpu: fix gfx hang during suspend with video playback (v2)

thanks,
-- Shuah
