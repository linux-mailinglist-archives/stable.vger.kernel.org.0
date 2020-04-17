Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D671AE43C
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 20:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgDQSFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 14:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730236AbgDQSFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 14:05:48 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A3AC061A0C
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 11:05:48 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s10so2247464iln.11
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 11:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cSw7SHfr94r6Y8g79lptnLdwtRuoUFOTgybmZHOpN5c=;
        b=MsO78gIcv8B9a9dDl3pUlmekjtC4Th0r67LdkLWCzPXB9zk0Kt+ZHG4jnaZcydJkl0
         /NkM3pb2wAHJ3B+qdGubc+fHDBB5vd5fFetbYUF4x4pObQfy7AGQ712XzSE/5r7hD5BS
         EixtllKzo0fLPy0dvE5phNSZaYwNQO55AGfiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cSw7SHfr94r6Y8g79lptnLdwtRuoUFOTgybmZHOpN5c=;
        b=Xhk0dLo8uiyE1m+EN6+7NbpkdvKXp/KrXjR076Jg00rUFXRBqx1RUsv42A9FmRTcjJ
         40+X57UbyBt+jpgDz6fL8DE1I3vALiHDNAOOwvfKXMBnjCrfSHoAo0p+txz51sqGoE80
         d3vd2maQtPuDgnRgRiexCkj0fpOV903ihRInVLnuk79wC2y6LjyEnDz2lvG+4Latx2+3
         MaX9LSeZKdXy7Wm7cdiKFmkj7UVR5ZPvO2sf5e6NkibDKYLeh5VG39dZ0c3ED5h4Xwyl
         veWy3RplAO5KgpEQzOKEZPPfJzPRkvDsGBjuy1GCjFwEfNQLxnfuAh89YFq5F4+lI+nR
         njbQ==
X-Gm-Message-State: AGi0PubtJ7NlIi+BD3e7q7L65BVXavJCkTOqxghxcdDfp4OL8yn3lccP
        OmDjBKVDwFMzfI+3lt2SOka4yX9KEKg=
X-Google-Smtp-Source: APiQypKN4Py7U+XbFCkE2PGrR1E0E2ium6hhLYsim9J7QTjqcPO+Tft93K0HjElbmnsFjNU079nJPQ==
X-Received: by 2002:a92:790a:: with SMTP id u10mr4107980ilc.98.1587146747218;
        Fri, 17 Apr 2020 11:05:47 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r1sm356886ilg.61.2020.04.17.11.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 11:05:46 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernelnorg>, Prike.Liang@amd.com,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        stable <stable@vger.kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Subject: Linux 5.7-rc1 reboot/poweroff hangs
Message-ID: <b8eaee2b-21dd-c0de-f522-d58bb9ae31da@linuxfoundation.org>
Date:   Fri, 17 Apr 2020 12:05:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

Linux 5.7-rc1 reboot/powereoff hangs on AMD Ryzen 5 PRO 2400GE
system.

I isolated the commit to:

Revering the following commit fixes the problem.

commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58
Author: Prike Liang <Prike.Liang@amd.com>
Date:   Tue Apr 7 20:21:26 2020 +0800

     drm/amdgpu: fix gfx hang during suspend with video playback (v2)

     The system will be hang up during S3 suspend because of SMU is
     pending for GC not respose the register CP_HQD_ACTIVE access
     request.This issue root cause of accessing the GC register under
     enter GFX CGGPG and can be fixed by disable GFX CGPG before perform
     suspend.

     v2: Use disable the GFX CGPG instead of RLC safe mode guard.

     Signed-off-by: Prike Liang <Prike.Liang@amd.com>
     Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
     Reviewed-by: Huang Rui <ray.huang@amd.com>
     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
     Cc: stable@vger.kernel.org


I did the bisect on Linux 5.6.5-rc1

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
