Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80DD6384A0
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 08:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKYHpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 02:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYHpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 02:45:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876612C128;
        Thu, 24 Nov 2022 23:45:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9AA6CE2C30;
        Fri, 25 Nov 2022 07:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F707C433D6;
        Fri, 25 Nov 2022 07:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669362311;
        bh=4DOmv+Bk48r/mh7tn2tBd58GhSVVN4trqBllxSUBgDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hEte8LclML+6pWLHhdvmOoqPoRTwDsa62inGylLc+nsJULsMi7Z6R079Lek16L5AD
         4vJh8onaoB3kdZuo6veMoNV8uGLa2GNQ5B+9FNylrT9uhbdx56Sb9w6lG/auzwZRXe
         n89kxKWKsjOJDafyGFE218JL/wwvKieA5mr8bKDI=
Date:   Fri, 25 Nov 2022 08:45:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y4Byg4lq6jOWcY8D@kroah.com>
References: <20221123084625.457073469@linuxfoundation.org>
 <Y39SmCRcY7EUhkhA@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y39SmCRcY7EUhkhA@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 24, 2022 at 11:16:40AM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.10 release.
> > There are 314 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 12.2.1 20221016):
> mips: 52 configs -> 1 failure
> arm: 100 configs -> 2 failures
> arm64: 3 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> csky allmodconfig -> no failure
> powerpc allmodconfig -> 1 failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> Note:
> 1. As reported by others arm mips and powerpc allmodconfig fails with:
> drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
>  1299 | static void rtc_wake_setup(struct device *dev)
>       |             ^~~~~~~~~~~~~~
> 

Should now be fixed, thanks.


> 
> 2. arm imxrt_defconfig fails with:
> 
> In file included from ./include/linux/bpf-cgroup.h:5,
>                  from security/device_cgroup.c:8:
> ./include/linux/bpf.h:2310:20: error: static declaration of 'bpf_prog_inc_misses_counter' follows non-static declaration
>  2310 | static inline void bpf_prog_inc_misses_counter(struct bpf_prog *prog)
>       |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/bpf.h:1970:14: note: previous declaration of 'bpf_prog_inc_misses_counter' with type 'void(struct bpf_prog *)'
>  1970 | void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
>       |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Caused by a1ba348f5325 ("bpf: Prevent bpf program recursion for raw tracepoint probes").

Oh, nice catch!  I messed up the backport of this commit, and put the
prototype in the wrong place in the .h file.  Let me push out a -rc2
with this moved a bit to see if that solves the problem.

Interesting that your build tests were the only one that caught this.

thanks,

greg k-h
