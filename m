Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198B7514FF9
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 17:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378688AbiD2P45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 11:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378674AbiD2P4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 11:56:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA6BD0A9B;
        Fri, 29 Apr 2022 08:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D4262267;
        Fri, 29 Apr 2022 15:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B13C385B4;
        Fri, 29 Apr 2022 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651247607;
        bh=+Y0eY5oyMZ5T469ibdO89+Q3BDTE3e0txfsZVfaWGT4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dyVkpfqgxYPSTkdVqD0o/koqN0WFC/iW8JJIjBH4FGc89p8Vp7WLdZ76/YtX1VAA7
         wmho9HhFd71J1mrSjORuSRWtFcyi4MWJ+1Rh2SsE8+2YrVK5sNcqHy1UQqiCVfMGrx
         J/rBZaHQxrMR29wkYPLTjdtZMdBDzOJaSYT4rjtdgZeyxDwWeD21C4Y5slvQvVQnLR
         cB9dIR9EiayQoWy85ivIxySIIq4c+6IPpnwSeZNIbL0fy5T6cNPbuD+VCjxh6A88TT
         i3LqOc6cGXvJOpCKXi9nwEnVH8HCgCfzvJb1r5YNn/+uOTsY+aJ7eEi8rfVYazIbeh
         GPv2TFVfr2aTQ==
Message-ID: <f194f679-4052-84cb-a3e4-165a28a98314@kernel.org>
Date:   Fri, 29 Apr 2022 10:53:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review [net: ethernet: stmmac:
 fix altr_tse_pcs function when using a]
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>
Cc:     iwamatsu@nigauri.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220426081735.651926456@linuxfoundation.org>
 <20220426200000.GB9427@duo.ucw.cz> <YmkrZ5t2cb1JSHR8@kroah.com>
 <20220429074341.GB1423@amd> <YmuuTb7Cv/JExahQ@kroah.com>
From:   Dinh Nguyen <dinguyen@kernel.org>
In-Reply-To: <YmuuTb7Cv/JExahQ@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/29/22 04:22, Greg Kroah-Hartman wrote:
> On Fri, Apr 29, 2022 at 09:43:41AM +0200, Pavel Machek wrote:
>> Hi!
>>
>>>>> This is the start of the stable review cycle for the 4.19.240 release.
>>>>> There are 53 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>> ...
>>>> I still see problems on socfpga:
>>>>
>>>> [    1.227759]  mmcblk0: p1 p2 p3
>>>> [    1.269825] Micrel KSZ9031 Gigabit PHY stmmac-0:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=stmmac-0:01, irq=POLL)
>>>> [    1.284600] socfpga-dwmac ff702000.ethernet eth0: No Safety Features support found
>>>> [    1.292374] socfpga-dwmac ff702000.ethernet eth0: registered PTP clock
>>>> [    1.299247] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
>>>> [    5.444552] Unable to handle kernel NULL pointer dereference at virtual address 00000000
>> ...
>>>> [    5.478679] Workqueue: events_power_efficient phy_state_machine
>>>> [    5.484579] PC is at socfpga_dwmac_fix_mac_speed+0x3c/0xbc
>>>> [    5.490044] LR is at arm_heavy_mb+0x2c/0x48
>>
>>>> https://lava.ciplatform.org/scheduler/job/669257
>>>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/2377419824
>>>
>>> Can you run git bisect?
>>
>> Not a bisect, but we guessed e2423aa174e6 was responsible, and tested
>> it boots with that patch reverted.
>>
>> Best regards,
>> 								Pavel
>>
>> commit e2423aa174e6c3e9805e96db778245ba73cdd88c
>>
>>      net: ethernet: stmmac: fix altr_tse_pcs function when using a
>>      fixed-link
>>
>>      [ Upstream commit a6aaa00324240967272b451bfa772547bd576ee6 ]
>>      
> 
> Thanks, now reverted from 4.19.y, 4.14.y, and 4.9.y
> 

I have fixed this with this patch that is in linux-next:

5fd1fe4807f9 ("net: ethernet: stmmac: fix write to sgmii_adapter_base")

Dinh

