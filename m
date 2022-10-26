Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC6560DB88
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiJZGor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiJZGoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:44:46 -0400
X-Greylist: delayed 455 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Oct 2022 23:44:43 PDT
Received: from zombie.net4u.de (zombie.net4u.de [5.9.79.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAF00C75A;
        Tue, 25 Oct 2022 23:44:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by zombie.net4u.de (Postfix) with ESMTP id 9717F2A40402;
        Wed, 26 Oct 2022 06:36:57 +0000 (UTC)
Received: from zombie.net4u.de ([127.0.0.1])
        by localhost (zombie.net4u.de [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id u81zJ8M_YPTG; Wed, 26 Oct 2022 06:36:56 +0000 (UTC)
Received: from [IPV6:2001:470:999b:fb01:7285:c2ff:fe2b:43c3] (unknown [IPv6:2001:470:999b:fb01:7285:c2ff:fe2b:43c3])
        by zombie.net4u.de (Postfix) with ESMTPSA id 4F76D2A40398;
        Wed, 26 Oct 2022 06:36:56 +0000 (UTC)
Message-ID: <f6aa6991-4c52-787c-a9c6-75f91e40548e@net4u.de>
Date:   Wed, 26 Oct 2022 08:36:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221024112934.415391158@linuxfoundation.org>
From:   Ernst Herzberg <earny@net4u.de>
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Missed a patch?

Problematic patch in v6.0.3 :

> commit 3ea7c50339859394dd667184b5b16eee1ebb53bc
> Author: Josef Bacik <josef@toxicpanda.com>
> Date:   Mon Aug 8 16:10:26 2022 -0400
> 
>     btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure
>     [ Upstream commit 8a1ae2781dee9fc21ca82db682d37bea4bd074ad ]
>     Now that lockdep is staying enabled through our entire CI runs I started
>     seeing the following stack in generic/475


See:

https://lore.kernel.org/stable/Y1aeWdHd4%2FluzhAu@localhost.localdomain/

> 
> Well I definitely fucked this patch up, because I should have used the _locked
> variant, but this was part of a series where I did the correct thing in the next
> patch
> 
>     btrfs: remove use btrfs_remove_free_space_cache instead of variant
> 
> so this problem doesn't exist in linus.  So either we need to pull that back
> into stable as well, or drop this patch from stable.  I'm good either way, this
> was just to fix a lockdep splat so it's not really stable material, but I'll
> leave that decision up to y'all.  Thanks,
> 
> Josef
> 
> 

