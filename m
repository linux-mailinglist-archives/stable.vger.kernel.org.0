Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F43358DA04
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 16:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243577AbiHIOBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 10:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiHIOBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 10:01:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4838F271A;
        Tue,  9 Aug 2022 07:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9602DB8111F;
        Tue,  9 Aug 2022 14:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D94DC433C1;
        Tue,  9 Aug 2022 14:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660053672;
        bh=u+a4xxI8QuroONub9HjlQCWDta7sG4zKmZv7pm4e4YQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BqCEXUMORsYoPmP0TX81BzFZY+JxVRuIDNIJDwJyMmP1ljzVK0zj3ajutrpW6JxP3
         v9AcpNw3Jd+XSv3AcYY5JxJ3WjdLf8tylmnTHCMzBAJmuoWWNQ1wSz4uh8G+BcR7H7
         qzp31MJLYX9n2DH5YKN3sMJDHK9WTvgZSceadpRZwuCsxLYct7IQX4R9GIMTt4h0iz
         2Cmm0vkMz+q23/7NHrWRw9dtTkAY+pHpPQr/5h78SGZFNOdRetRdf5bA8m0gL5czd6
         layPBfn/2nP/+JtU/3GNMs7icW9SY8QkXZO3IbCrXv5UdOOGZF0uXBSw38UVPIjojv
         Kzn2k3i4UllqA==
Date:   Tue, 9 Aug 2022 10:01:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>, catalin.marinas@arm.com,
        bp@suse.de, Jason@zx2c4.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.19 05/58] arm64: kernel: drop unnecessary PoC
 cache clean+invalidate
Message-ID: <YvJopiTwMaahZGIy@sashalap>
References: <20220808013118.313965-1-sashal@kernel.org>
 <20220808013118.313965-5-sashal@kernel.org>
 <CAMj1kXGaOeDtFKCXwKo5Dt9DJneyS5fjnmoZZBmYeDZfYG6GiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMj1kXGaOeDtFKCXwKo5Dt9DJneyS5fjnmoZZBmYeDZfYG6GiA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 11:05:29AM +0200, Ard Biesheuvel wrote:
>On Mon, 8 Aug 2022 at 03:31, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> [ Upstream commit 2e945851e26836c0f2d34be3763ddf55870e49fe ]
>>
>> Some early boot code runs before the virtual placement of the kernel is
>> finalized, and we used to go back to the very start and recreate the ID
>> map along with the page tables describing the virtual kernel mapping,
>> and this involved setting some global variables with the caches off.
>>
>> In order to ensure that global state created by the KASLR code is not
>> corrupted by the cache invalidation that occurs in that case, we needed
>> to clean those global variables to the PoC explicitly.
>>
>> This is no longer needed now that the ID map is created only once (and
>> the associated global variable updates are no longer repeated). So drop
>> the cache maintenance that is no longer necessary.
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> Link: https://lore.kernel.org/r/20220624150651.1358849-9-ardb@kernel.org
>> Signed-off-by: Will Deacon <will@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>NAK
>
>This patch *must* *not* be backported. It will break the boot.

Appologies for this one, this was a technical issue on my end and I owe
a beer for yourself and few other folks that should have been filtered
out.

I'll drop all your patches from the AUTOSEL queue.

-- 
Thanks,
Sasha
