Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9886C6BBB85
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 18:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjCOR5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 13:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjCOR5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 13:57:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBCB30B03
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 10:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B37D4B81EBF
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 17:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3002DC433EF;
        Wed, 15 Mar 2023 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678903056;
        bh=DfarB1MGAlmk4YITXdAFNDiQiS87D+qvCwPA5G95N/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NeNe+w3zOB4J/Son99vlIikbx69ynB6h3z3fSRASSFAatctW/INh3mwxWBBCRO38x
         r3FzHSzFIUE9Awuy4GdziMUaZbfrkftkcXzo7r5RdREOGbMlAbyIr9riz5cKRo0X/J
         jXzzzO/cGB+CGFcxJVN2MrlcNfEFWajLl9FnvAUTUCf837+kFoiC94d1NMDEArAhhH
         fhEhtL1+CnNHsnDkSv79xbrS6rl84eIGRST2H2iMMmD1BVkxue5gpNlXWIAjVxZPVk
         2WZSr9rwgWQDGr2fkLGGb6Acecmcs1MdrzVidz0LR/4Vso2mNQoCSgSlv7sy6pxoMh
         mSAIQMX76/FxQ==
Date:   Wed, 15 Mar 2023 13:57:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.15 107/145] powerpc: Check !irq instead of irq ==
 NO_IRQ and remove NO_IRQ
Message-ID: <ZBIHDxoEEVoRZqUq@sashalap>
References: <20230315115738.951067403@linuxfoundation.org>
 <20230315115742.506375747@linuxfoundation.org>
 <9ad39d8b-64e8-466f-b93b-494905cd1bf0@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ad39d8b-64e8-466f-b93b-494905cd1bf0@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 12:32:27PM +0000, Christophe Leroy wrote:
>
>
>Le 15/03/2023 à 13:12, Greg Kroah-Hartman a écrit :
>> From: Christophe Leroy <christophe.leroy@csgroup.eu>
>>
>> [ Upstream commit bab537805a10bdbf55b31324ba4a9599e0651e5e ]
>>
>> NO_IRQ is a relic from the old days. It is not used anymore in core
>> functions. By the way, function irq_of_parse_and_map() returns value 0
>> on error.
>>
>> In some drivers, NO_IRQ is erroneously used to check the return of
>> irq_of_parse_and_map().
>>
>> It is not a real bug today because the only architectures using the
>> drivers being fixed by this patch define NO_IRQ as 0, but there are
>> architectures which define NO_IRQ as -1. If one day those
>> architectures start using the non fixed drivers, there will be a
>> problem.
>>
>> Long time ago Linus advocated for not using NO_IRQ, see
>> https://lore.kernel.org/all/Pine.LNX.4.64.0511211150040.13959@g5.osdl.org
>>
>> He re-iterated the same view recently in
>> https://lore.kernel.org/all/CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com
>>
>> So test !irq instead of tesing irq == NO_IRQ.
>>
>> All other usage of NO_IRQ for powerpc were removed in previous cycles so
>> the time has come to remove NO_IRQ completely for powerpc.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> Link: https://lore.kernel.org/r/4b8d4f96140af01dec3a3330924dda8b2451c316.1674476798.git.christophe.leroy@csgroup.eu
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Same, you can't remove NO_IRQ macro without first all preparation
>patches merged during the 6.2 cycle.

Ack, I'll drop this one.

-- 
Thanks,
Sasha
