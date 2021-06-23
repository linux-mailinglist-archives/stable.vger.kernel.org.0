Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DEF3B1D89
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 17:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhFWPWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhFWPWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 11:22:04 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25DAC061574;
        Wed, 23 Jun 2021 08:19:46 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 69D8D1F4388C
Subject: Re: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
To:     Kees Cook <keescook@chromium.org>
Cc:     Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        "kernelci@groups.io" <kernelci@groups.io>,
        Collabora Kernel ML <kernel@collabora.com>
References: <20210619025834.2505201-1-keescook@chromium.org>
 <e958209b-8621-57ca-01d6-2e76b05dab4c@collabora.com>
 <202106230734.78A239D@keescook>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <b290a69c-6c24-a0f3-392b-33dc4985af2b@collabora.com>
Date:   Wed, 23 Jun 2021 16:19:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <202106230734.78A239D@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+kernelci +collabora

On 23/06/2021 15:38, Kees Cook wrote:
> On Wed, Jun 23, 2021 at 01:39:57PM +0100, Guillaume Tucker wrote:
>> On 19/06/2021 03:58, Kees Cook wrote:
>>> Some environments do not set $SHELL when running tests. There's no need
>>> to use $SHELL here anyway, so just replace it with hard-coded path
>>> instead. Additionally avoid using bash-isms in the command, so that
>>> regular /bin/sh can be used.
>>>
>>> Suggested-by: Guillaume Tucker <guillaume.tucker@collabora.com>
>>> Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>>
>> Tested-by: "kernelci.org bot" <bot@kernelci.org> 
>>
>>
>> Sample staging results with this patch applied on top of
>> next-20210622:
>>
>> https://staging.kernelci.org/test/plan/id/60d2dbdc3cfb88da0924bf41/
>>
>> Full log:
>>
>> https://storage.staging.kernelci.org/kernelci/staging-next/staging-next-20210623.0/x86_64/x86_64_defconfig+x86-chromebook+kselftest/clang-13/lab-collabora/kselftest-lkdtm-asus-C523NA-A20057-coral.html
> 
> Awesome! This looks great. :)
> 
> What's needed to build these kernels will different CONFIGs? I see a
> bunch of things (commonly found in distro kernels) that are not set:
> 
> CONFIG_SLAB_FREELIST_HARDENED=y
> CONFIG_FORTIFY_SOURCE=y
> CONFIG_HARDENED_USERCOPY=y
> # CONFIG_HARDENED_USERCOPY_FALLBACK is not set
> 
> Should I add these to the kselftest "config" file for LKDTM?

Yes, that's the current way to do it.

KernelCI is simply concatenating all the config files found under
tools/testing/selftests into one big kselftest fragment which is
then merged with the defconfig.  We could enable arbitrary things
for KernelCI but of course it's much better to not do that and
stick to what's in the kernel tree.

If you do send such a patch, please CC kernelci@groups.io or
myself and we can give it a spin on staging.kernelci.org as well.

Best wishes,
Guillaume
