Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F886BBB99
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCOSAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCOSAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:00:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB6756795
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3680961E0A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 18:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74968C433D2;
        Wed, 15 Mar 2023 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678903236;
        bh=eeIgKjIrne1XGkPGwXznoaDAfu4V7cmqsmC58TcUsXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mN/kPYqsleAOmHF5TGzbOAf4WdVgTy/wZzYMF/bf6CfqMOPcikufeb5udER6QdIrc
         wGl6R0522tsaEyYkvPa2Ihsl6C+r1ba2mVOiwEY70OejVZKdN67MB5dqcloaaS4Fkr
         AlcT0NzP341IXls421wFRlLDtY0W806dUDPv5tjE52OQoIhLDTxPXJpXQHNTEIJDNw
         HOUyIWNNPCzh6i7T09keSwY2glJqDtt+tQwhKUQjfbIvsh1Nohd3nyuFukhFD0IZFH
         7TRpBbyEelrIJ0FR42SIfg6NasdDjdLHe/woxO8lti7i951x21itpxtlcv6j7URWhK
         zvxFj0I7ylOYQ==
Date:   Wed, 15 Mar 2023 14:00:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Conor Dooley <conor@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH 6.2 112/141] RISC-V: clarify ISA string ordering rules in
 cpu.c
Message-ID: <ZBIHwzn12WZeoNwu@sashalap>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.408666245@linuxfoundation.org>
 <4576eb25-2c86-49d3-a290-398d583f479a@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4576eb25-2c86-49d3-a290-398d583f479a@spud>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 01:18:17PM +0000, Conor Dooley wrote:
>Hey Greg,
>
>On Wed, Mar 15, 2023 at 01:13:35PM +0100, Greg Kroah-Hartman wrote:
>> From: Conor Dooley <conor.dooley@microchip.com>
>>
>> [ Upstream commit 99e2266f2460e5778560f81982b6301dd2a16502 ]
>>
>> While the current list of rules may have been accurate when created
>> it now lacks some clarity in the face of isa-manual updates. Instead of
>> trying to continuously align this rule-set with the one in the
>> specifications, change the role of this comment.
>>
>> This particular comment is important, as the array it "decorates"
>> defines the order in which the ISA string appears to userspace in
>> /proc/cpuinfo.
>>
>> Re-jig and strengthen the wording to provide contributors with a set
>> order in which to add entries & note why this particular struct needs
>> more attention than others.
>>
>> While in the area, add some whitespace and tweak some wording for
>> readability's sake.
>>
>> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
>> Link: https://lore.kernel.org/r/20221205144525.2148448-2-conor.dooley@microchip.com
>> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>> Stable-dep-of: 1eac28201ac0 ("RISC-V: fix ordering of Zbb extension")
>
>I've been sick for the last week, and am not 100% sure what I did and
>did not reply to stable selection emails for, but I'm pretty sure that I
>did say that the ZBB stuff was a 6.3 feature and the order fix should
>not be backported.
>
>I'm not sure that I understand how this comment rework is a stable
>dependency of that backport either, but this should be dropped.
>Apologies if I missed a selection email for this one while I've been
>sick, but I was sick after all...

My bad, this one shouldn't have been left here, now dropped. Thanks!

-- 
Thanks,
Sasha
