Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36514DB513
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357250AbiCPPm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352184AbiCPPm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:42:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834CB43399
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00704616F3
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 15:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDED9C340E9;
        Wed, 16 Mar 2022 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647445271;
        bh=fGlxVPOqx7AWOT3JY9X9MOlp4HEsWoCwI1MuXI2ST8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JYpefBRr/EeoPTiDhHMNP9czSh83o/H1eJ+HF+AtGxXhBw5YtgFL6ulKHhtuNyNqn
         IuVYrpWgz+E+Tl1f9LJNsS+5gKk8PekxIhASqKBumXCiiiRpP+Ww/IxMQKuIdk4HL6
         EQprNezXL4o89zFvZt6jrfGZhUnkEjI/zlHlqzFqqiaJs7Da1lby3muw3MY4/OyIpv
         UhY05ibHDfHdHMmZESzXo4kLMkBjEKo/wreqnemevjoKnUZELcA6xYgtyAAdkgUso8
         Ji5ZqUdh1QnxzvXPSTnHzGocqti1DCT3QfyoFpk9gNOqIXGsB4ilXk5i2o0rKaIKBV
         yfvYEN+h0awdQ==
Date:   Wed, 16 Mar 2022 11:41:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable:PATCH v5.4.184 00/22] arm64: Mitigate spectre style
 branch history side channels
Message-ID: <YjIFE8Abn7XI+4yW@sashalap>
References: <20220315182415.3900464-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220315182415.3900464-1-james.morse@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 06:23:53PM +0000, James Morse wrote:
>Hi Greg,
>
>Here is the state of the current v5.4 backport. Now that the 32bit
>code has been merged, it doesn't conflict when KVM's shared 32bit/64bit
>code needs to use these constants.
>
>I've fixed the two issues that were reported against the v5.10 backport.
>
>I had a go at bringing all the pre-requisites in to add proton-pack.c
>to v5.4. Its currently 39 patches:
>https://git.gitlab.arm.com/linux-arm/linux-jm.git /bhb/alternative_backport/UNTESTED/v5.4.183
>(or for web browsers:
>https://gitlab.arm.com/linux-arm/linux-jm/-/commits/bhb/alternative_backport/UNTESTED/v5.4.183/
>)

I've queued it up.

>I've not managed to bring b881cdce77b4 "KVM: arm64: Allocate hyp vectors
>statically" in, as that depends on the hypervisor's per-cpu support. Its
>this patch that means those 'smccc_wa' templates are needed.
>I estimate it would be 60 patches in total if we go this way, I don't
>think its a good idea:
>All this still has to work around 541ad0150ca4 ("arm: Remove 32bit KVM
>host support") and 9ed24f4b712b ("KVM: arm64: Move virt/kvm/arm to
>arch/arm64") being missing.
>I think this approach creates more problems than it solves as the
>files have to be in different places because of 32bit. It also creates
>a significantly larger testing problem: I'm not looking forward to
>working out how to test KVM guest migration over the variant-4 KVM ABI
>changes in 29e8910a566a.

I think that the workaround you mention later on for this issue makes
sense cost/benefit-wise.

>This version of the backport still adds the mitigation management code
>to cpu_errata.c, because that is where this stuff lived in v5.4.
>
>If you prefer, I can try adding proton-pack.c as a new empty file.
>I think this would only confuse matters as the line-numbers would
>never match, and there is an interaction with the spectre-v2 mitigations
>that live in cpu_errata.c.
>
>There is one patch not present in mainline 'KVM: arm64: Add templtes for
>BHB mitigation sequences'.

Thank you!

-- 
Thanks,
Sasha
