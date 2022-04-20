Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF33508CE8
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 18:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380422AbiDTQOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 12:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiDTQOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 12:14:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0605B1AD94
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 09:11:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 974CC61998
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 16:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751D3C385A0;
        Wed, 20 Apr 2022 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650471077;
        bh=tJDx9gyJQ7fQu2P6ASbuullkNBvZTsgfqfZnutWvOvs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lK9g5VigZSkQH6Ca30lzBQnaH2tQNFqB0+iK+TJ5MifGLAySq6qPH/bqa73hRyqLb
         Nd4acxDQnXfXKYL7GNcaqDb9VrySUUNJw2iQs8WcJ6kTlEcR+owd9QJb1Y/0LWtKPM
         hinAZRwGeZbdiwWbSiZ9AL99RI9ujdYV4ILztEBHU2DHBaWhGJ9LE7o95kv4aTioWj
         3wsfJigqpcS57ArVUxxXEfpYFkpiTsyMTINoW52JT8wCrjFSJIq8NqywQ41HhHrfGE
         BawrphbiNbJwepPvx2IcM6SF/kxmCj6COcSOriiQg7VV7uohGv08zfqHqY6BmBSXjc
         JOhi2drpxZtCw==
Message-ID: <f567a8cc-cd1c-9f79-eda0-a45a39383611@kernel.org>
Date:   Wed, 20 Apr 2022 19:11:10 +0300
MIME-Version: 1.0
Subject: Re: [PATCH 5.15 2/2] arm64/mm: drop HAVE_ARCH_PFN_VALID
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>,
        Georgi Djakov <quic_c_gdjako@quicinc.com>
Cc:     stable@vger.kernel.org, rppt@linux.ibm.com,
        anshuman.khandual@arm.com, david@redhat.com, will@kernel.org,
        catalin.marinas@arm.com, hch@lst.de, akpm@linux-foundation.org,
        surenb@google.com, quic_sudaraja@quicinc.com
References: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
 <20220420124341.14982-2-quic_c_gdjako@quicinc.com>
 <YmAdlNslaGbSKUj4@sashalap>
From:   Georgi Djakov <djakov@kernel.org>
In-Reply-To: <YmAdlNslaGbSKUj4@sashalap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Sasha,

On 20.04.22 17:49, Sasha Levin wrote:
> On Wed, Apr 20, 2022 at 05:43:41AM -0700, Georgi Djakov wrote:
>> From: Anshuman Khandual <anshuman.khandual@arm.com>
>>
>> [ Upstream commit 3de360c3fdb34fbdbaf6da3af94367d3fded95d3 ]
>>
>> CONFIG_SPARSEMEM_VMEMMAP is now the only available memory model on arm64
>> platforms and free_unused_memmap() would just return without creating any
>> holes in the memmap mapping.  There is no need for any special handling in
>> pfn_valid() and HAVE_ARCH_PFN_VALID can just be dropped.  This also moves
>> the pfn upper bits sanity check into generic pfn_valid().
> 
> It's not clear why we need this patch in stable.
> 

I added a Link: tag, pointing to the discussion where the problem is explained
in details and the suggestion to backport these patches to 5.15. But probably
this is not enough and i should have mentioned it in the commit message too.

So in short:
This is fixing a crash on systems where the RAM base address is not aligned
to the pageblock size. Only v5.15 is affected.

 > Fixes: 859a85ddf90e ("mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE")
 > Link: https://lore.kernel.org/r/Yl0IZWT2nsiYtqBT@linux.ibm.com

Thanks,
Georgi
