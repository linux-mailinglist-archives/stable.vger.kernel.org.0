Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879324D4742
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbiCJMvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242130AbiCJMvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:51:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC0914995D
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 04:50:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 595FD6198C
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 12:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242FDC340E8;
        Thu, 10 Mar 2022 12:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646916651;
        bh=sj8CwLN4pMaDiMg4EMB04ZXcz/3Sp+ATEwhlBlVnBUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBtH3AZUTJIcmvCjXdf/r0MBSSqMdb7Kf1clfXp+m21Ty3NhDjdY+4L9iFlaDtKem
         i1N/ch36hFum2eybZBMmm0OBAsky5MypBjyZy7nRmjWW3cmNmuQ0nkk50ys6/V5Y6F
         8Vkd0TJKp6+t/JNMUU9bYL+AyyO67A3gROwazyy4=
Date:   Thu, 10 Mar 2022 13:50:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc queue/5.4 x86 and i386 gcc-11 builds failed -
 bugs.c:973:41: error: implicit declaration of function
 'unprivileged_ebpf_enabled'
Message-ID: <Yin0KPT/rd+TsTae@kroah.com>
References: <CA+G9fYu5TTXufJUW64=uFTntnB021xvQaO_t5Ay4mcUr-7TYTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu5TTXufJUW64=uFTntnB021xvQaO_t5Ay4mcUr-7TYTQ@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 06:12:15PM +0530, Naresh Kamboju wrote:
> stable-rc queue/5.4 x86 and i386 gcc-11 builds failed due to following
> errors / warnings.
> 
> metadata:
>     git_describe: v5.4.183-21-g73e4e04ab074
>     git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
>     git_sha: 73e4e04ab074c2edbda9422d6b9bfb2dc5779ce3
>     git_short_log: 73e4e04ab074 (\ARM: fix build warning in proc-v7-bugs.c\)
>     target_arch: x86_64
>     toolchain: gcc-11
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=x86_64
> CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> /builds/linux/arch/x86/kernel/cpu/bugs.c: In function
> 'spectre_v2_select_mitigation':
> /builds/linux/arch/x86/kernel/cpu/bugs.c:973:41: error: implicit
> declaration of function 'unprivileged_ebpf_enabled'
> [-Werror=implicit-function-declaration]
>   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> build link [1] & [2]

Should now be fixed.  I'll be pushing out -rc2 in a bit...

thanks,

greg k-h
