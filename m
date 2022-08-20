Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D12459AEB7
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 16:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345244AbiHTOhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 10:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345362AbiHTOhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 10:37:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4DD51A0C;
        Sat, 20 Aug 2022 07:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1B75B80CE7;
        Sat, 20 Aug 2022 14:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99438C433D6;
        Sat, 20 Aug 2022 14:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661006238;
        bh=BWn2AuZzmBQWgCHdWYaKRFlhXdOsJZRS65HElJ+rCnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c0/5SZHW21ph5f4RPJG97a05DM5d7Lpao/oGNc8IrLae65UMG0PQhuBVVmwlVPxQL
         9e7vfn6zON8NsmuFTIKxNxYHxcsnua3klYYFWVuHmnvWZBcw5W2nnwAY6ApLOzo34i
         hvGS5swdxJf9hdWZAJ4JaT2X4OYQQw4zF4WliNfhoNu7LM1EclC4Wb+08AucuzI0Re
         JVBVTUBeaJ8IRu6Culw2PO5W+8NvYbaTlK7G+YrEaBZ/5Xr0/bfM79QEWLQvfM3aXT
         Sqs1Uds/CEA/zSAtIvhAzOny89n8ryglMphBY7gAE4fEHA206UG8wflCl5UzKy2U4D
         W05rEP29vxoBA==
Date:   Sat, 20 Aug 2022 10:37:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lecopzer Chen <lecopzer.chen@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux@armlinux.org.uk, ryabinin.a.a@gmail.com,
        matthias.bgg@gmail.com, arnd@arndb.de, rostedt@goodmis.org,
        nick.hawkins@hpe.com, john@phrozen.org,
        linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.19 54/64] ARM: 9202/1: kasan: support
 CONFIG_KASAN_VMALLOC
Message-ID: <YwDxnRGKNbk5Chay@sashalap>
References: <20220814152437.2374207-1-sashal@kernel.org>
 <20220814152437.2374207-54-sashal@kernel.org>
 <CAMj1kXEzSwOtMGUi1VMg9xj60sHJ=9GHdjK2LXBXahSPmm56jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMj1kXEzSwOtMGUi1VMg9xj60sHJ=9GHdjK2LXBXahSPmm56jw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 04:45:14PM +0200, Ard Biesheuvel wrote:
>On Sun, 14 Aug 2022 at 17:30, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Lecopzer Chen <lecopzer.chen@mediatek.com>
>>
>> [ Upstream commit 565cbaad83d83e288927b96565211109bc984007 ]
>>
>> Simply make shadow of vmalloc area mapped on demand.
>>
>> Since the virtual address of vmalloc for Arm is also between
>> MODULE_VADDR and 0x100000000 (ZONE_HIGHMEM), which means the shadow
>> address has already included between KASAN_SHADOW_START and
>> KASAN_SHADOW_END.
>> Thus we need to change nothing for memory map of Arm.
>>
>> This can fix ARM_MODULE_PLTS with KASan, support KASan for higmem
>> and support CONFIG_VMAP_STACK with KASan.
>>
>> Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
>> Tested-by: Linus Walleij <linus.walleij@linaro.org>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This patch does not belong in -stable. It has no fixes: or cc:stable
>tags, and the contents are completely inappropriate for backporting
>anywhere. In general, I think that no patch that touches arch/arm
>(with the exception of DTS updates, perhaps) should ever be backported
>unless proposed or acked by the maintainer.

I'll drop it.

>I know I shouldn't ask, but how were these patches build/boot tested?
>KAsan is very tricky to get right, especially on 32-bit ARM ...

They were only build tested at this stage. They go through
boot/functional test only after they are actually queued up for the
various trees.

-- 
Thanks,
Sasha
