Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD2B50AFA9
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 07:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiDVFo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 01:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiDVFo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 01:44:56 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0CA4F458
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 22:42:02 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kl3FG6wJZz4xLb;
        Fri, 22 Apr 2022 15:41:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1650606118;
        bh=CzpPNa6LNBRn4OqfkiDTKTk6MLwFbBssFLjPgmXcayA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=L88olYxweE+CygJgshK3C46w2LQk5l7diuD/dFnFg4+3GHhyY+kY+FU2SW5TlnLaK
         3Dolow5IPpMXLVPm2vPUE9+wz9sqeeTijdL+mJ4FpbULVyo0UdIGbB+XccsWC6ZaR+
         zGA1DueNmVxVA+eVoiXyCnvn2FYDsC0matiy6kzJ8So9JGfJYKful61C2Quc8tG3YA
         WkgSGCCJ7hwlzBM5/jRj9luUsoj997wiRC6/9B0Mi9GBxEr/XavSMphkwkG02lZFsT
         yW1R49oTvh0Kfz0ASaSiFVXVILBlPx9DVhYZ80MSKf21y/C9iuoRM7RfbQwNp3tz7t
         j7CyFBVdPftlA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev
Subject: Re: Apply d799769188529abc6cbf035a10087a51f7832b6b to 5.17 and 5.15?
In-Reply-To: <YmF0iajmlAg6Kj9I@dev-fedora.thelio-3990X>
References: <Yl8pNxSGUgeHZ1FT@dev-arch.thelio-3990X>
 <877d7ig9oz.fsf@mpe.ellerman.id.au>
 <YmF0iajmlAg6Kj9I@dev-fedora.thelio-3990X>
Date:   Fri, 22 Apr 2022 15:41:51 +1000
Message-ID: <8735i5ad40.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nathan Chancellor <nathan@kernel.org> writes:
> On Thu, Apr 21, 2022 at 05:46:52PM +1000, Michael Ellerman wrote:
>> Nathan Chancellor <nathan@kernel.org> writes:
>> > Hi Greg, Sasha, and Michael,
>> >
>> > Commit d79976918852 ("powerpc/64: Add UADDR64 relocation support") fixes
>> > a boot failure with CONFIG_RELOCATABLE=y kernels linked with recent
>> > versions of ld.lld [1]. Additionally, it resolves a separate boot
>> > failure that Paul Menzel reported [2] with ld.lld 13.0.0. Is this a
>> > reasonable backport for 5.17 and 5.15? It applies cleanly, resolves both
>> > problems, and does not appear to cause any other issues in my testing
>> > for both trees but I was curious what Michael's opinion was, as I am far
>> > from a PowerPC expert.
>> >
>> > This change does apply cleanly to 5.10 (I did not try earlier branches)
>> > but there are other changes needed for ld.lld to link CONFIG_RELOCATABLE
>> > kernels in that branch so to avoid any regressions, I think it is safe
>> > to just focus on 5.15 and 5.17.
>> 
>> I considered tagging it for stable, but I wanted it to get a bit of
>> testing first, it's a reasonably big patch.
>> 
>> I think we're reasonably confident it doesn't introduce any new bugs,
>> but more testing time is always good.
>> 
>> So I guess I'd be inclined to wait another week or so before requesting
>> a stable backport?
>
> Sure, thanks for the response! I'll ping this thread on Monday, May 2nd,
> so that we have two more RC releases to try and flush out any lingering
> issues. If you do receive any reports of regressions, please let me
> know.

Sounds good, thanks.

cheers
