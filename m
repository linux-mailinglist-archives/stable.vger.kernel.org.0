Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF286E5CF2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 11:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjDRJGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 05:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjDRJFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 05:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCBA7A87;
        Tue, 18 Apr 2023 02:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2184761B1C;
        Tue, 18 Apr 2023 09:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F46C433EF;
        Tue, 18 Apr 2023 09:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681808693;
        bh=MpxhFy15fg9ehTSkmmlcWUhl1nltRQKJK4b0qUxbzVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0FdWpY0wbd/esAH99iz+uAYJZ1bkH0F96NCmBYwuAzp/BcLQBYtVWdgigCugXMuAU
         Y6jRCj3J+71Fuz8M9/dLqg7uiiJdzaYRclEmEle4XLg1gnkjIGHxhYpmQ0Omu/ZiY4
         /ffm/IU6mylBDlYPQBuwkD+xKIxsTS2n4sZSj1Ps=
Date:   Tue, 18 Apr 2023 11:04:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     stable@vger.kernel.org, acme@redhat.com, andres@anarazel.de,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [backport PATCH 0/2] stable v5.15, v5.10 and v5.4: fix perf
 build errors
Message-ID: <2023041848-basil-plop-145c@gregkh>
References: <20230417122943.2155502-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417122943.2155502-1-anders.roxell@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 17, 2023 at 02:29:41PM +0200, Anders Roxell wrote:
> Hi,
> 
> I would like to see these patches backported. They are needed so perf
> can be cross compiled with gcc on v5.15, v5.10 and v5.4.
> I built it with tuxmake [1] here are two example commandlines:
> tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 --kconfig defconfig perf
> tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-12 --kconfig defconfig perf
> 
> Tried to build perf with both gcc-11 and gcc-12.
> 
> Patch 'tools perf: Fix compilation error with new binutils'
> and 'tools build: Add feature test for init_disassemble_info API changes'
> didn't apply cleanly, thats why I send these in a patchset.
> 
> When apply 'tools build: Add feature test for
> init_disassemble_info API changes' to 5.4 it will be a minor merge
> conflict, do you want me to send this patch in two separate patches one
> for 5.4 and another for v5.10?
> 
> The sha for these two patches in mainline are.
> cfd59ca91467 tools build: Add feature test for init_disassemble_info API changes
> 83aa0120487e tools perf: Fix compilation error with new binutils
> 
> The above patches solves these:
> util/annotate.c: In function 'symbol__disassemble_bpf':
> util/annotate.c:1729:9: error: too few arguments to function 'init_disassemble_info'
>  1729 |         init_disassemble_info(&info, s,
>       |         ^~~~~~~~~~~~~~~~~~~~~
> 
> 
> Please apply these to v5.10 and v5.4
> a45b3d692623 tools include: add dis-asm-compat.h to handle version differences
> d08c84e01afa perf sched: Cast PTHREAD_STACK_MIN to int as it may turn into sysconf(__SC_THREAD_STACK>
> 
> The above patches solves these:
> /home/anders/src/kernel/stable-5.10/tools/include/linux/kernel.h:43:24: error: comparison of distinct pointer types lacks a cast [-Werror]
>    43 |         (void) (&_max1 == &_max2);              \
>       |                        ^~
> builtin-sched.c:673:34: note: in expansion of macro 'max'
>   673 |                         (size_t) max(16 * 1024, PTHREAD_STACK_MIN));
>       |                                  ^~~
> 
> 
> Please apply these to v5.15, v5.10 and v5.4
> 8e8bf60a6754 perf build: Fixup disabling of -Wdeprecated-declarations for the python scripting engine
> 4ee3c4da8b1b perf scripting python: Do not build fail on deprecation warnings
> 63a4354ae75c perf scripting perl: Ignore some warnings to keep building with perl headers

Can you please provide patch series of these upstream commits backported
to the relevant branchs that you wish to see them in?  You have 2
patches in this series without git commit ids, and I have no idea where
to apply them, or not apply them...

Or better yet, just use the latest version of perf as was pointed out,
on these old kernel releases.

thanks,

greg k-h
