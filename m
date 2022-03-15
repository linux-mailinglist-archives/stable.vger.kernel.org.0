Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3C44D9AE8
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348133AbiCOMPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240407AbiCOMP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:15:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA2EF2640;
        Tue, 15 Mar 2022 05:14:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8388F1476;
        Tue, 15 Mar 2022 05:14:17 -0700 (PDT)
Received: from [10.57.90.210] (unknown [10.57.90.210])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D8043F66F;
        Tue, 15 Mar 2022 05:14:15 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/30] 4.19.235-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220314112731.785042288@linuxfoundation.org>
 <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
 <Yi9LlP+x2swdsrbE@kroah.com>
 <ae60e4a0-3333-1ad7-1ac9-62e6ac3751de@nvidia.com>
 <Yi9X4jqy4RT4jr5n@kroah.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <3f809462-217d-fc4d-8e1e-a3d265350fcb@arm.com>
Date:   Tue, 15 Mar 2022 12:14:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Yi9X4jqy4RT4jr5n@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 3/14/22 2:57 PM, Greg Kroah-Hartman wrote:
> On Mon, Mar 14, 2022 at 02:14:41PM +0000, Jon Hunter wrote:
>> On 14/03/2022 14:05, Greg Kroah-Hartman wrote:
>>> On Mon, Mar 14, 2022 at 01:58:12PM +0000, Jon Hunter wrote:
>>>> On 14/03/2022 11:34, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 4.19.235 release.
>>>>> There are 30 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
>>>>> Anything received after that time might be too late.


>>>>> James Morse <james.morse@arm.com>
>>>>>        KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU
>>>>
>>>>
>>>> The above is causing the following build error for ARM64 ...
>>>>
>>>> arch/arm64/kvm/sys_regs.c: In function ‘reset_pmcr’:
>>>> arch/arm64/kvm/sys_regs.c:624:3: error: implicit declaration of function ‘vcpu_sys_reg’ [-Werror=implicit-function-declaration]
>>>>      vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
>>>>      ^~~~~~~~~~~~
>>>> arch/arm64/kvm/sys_regs.c:624:32: error: lvalue required as left operand of assignment
>>>>      vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
>>>>
>>>
>>> Is this also broken in Linus's tree?
>>
>>
>> No, Linus' tree is not broken. However, I don't see this change in Linus'
>> tree (v5.17-rc8).
> 
> Ah, this is a "fix something broken in stable-only" type patch :(

> James, I'm dropping this from the 4.19, 4.9, and 4.14 trees right now as
> it looks broken :(

What would you prefer I do here:
  1 post a revert for the original problematic backport.
  2 post versions of this to fix each of the above 3 stable kernels. (instead of putting conditions in the stable tag).


Thanks,

James
