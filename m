Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814844F62FA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiDFPLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiDFPL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:11:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098611DF875;
        Wed,  6 Apr 2022 05:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FEB06179E;
        Wed,  6 Apr 2022 12:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B24C385A1;
        Wed,  6 Apr 2022 12:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649246823;
        bh=29FlFNXkq27syBNmf9v5tb8A1L9rU05KZSllftSB3hU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kVy1iQrsTySgS5FxZTXzmnZ5tx01hAkemwsko9mFzQ/aI7nTEFV/bjRvB0oKgk3TC
         P9QcVAfk4JbrbLJspRRr2Vrr/8hemxPrcSCZ0GznQZD7Pmo0qqw/ucaQERYqD8o2Lt
         zTAmACYIgMa+QKBnaI6wd2yOZON1bC4DhfbjK5KI=
Date:   Wed, 6 Apr 2022 14:07:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <Yk2CZY8AuzSjgwMx@kroah.com>
References: <20220405070258.802373272@linuxfoundation.org>
 <e80a3eb4-335c-5f8c-dc22-e33176b225da@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e80a3eb4-335c-5f8c-dc22-e33176b225da@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 06:08:44AM -0700, Guenter Roeck wrote:
> On 4/5/22 00:24, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.110 release.
> > There are 599 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building um:defconfig ... failed
> Building csky:defconfig ... failed
> Building microblaze:mmu_defconfig ... failed
> ------
> Error log:
> 
> fs/binfmt_elf.c: In function 'fill_note_info':
> fs/binfmt_elf.c:2050:45: error: 'siginfo' undeclared (first use in this function)
>  2050 |                 sz = elf_dump_thread_status(siginfo->si_signo, ets);
>       |                                             ^~~~~~~
> fs/binfmt_elf.c:2050:45: note: each undeclared identifier is reported only once for each function it appears in
> fs/binfmt_elf.c:2056:53: error: 'regs' undeclared (first use in this function)
>  2056 |         elf_core_copy_regs(&info->prstatus->pr_reg, regs);
>       |                                                     ^~~~
> 
> Build just started, so there are likely going to be more failures.

Thanks, I missed this in my backport.  Now should be fixed up, I'll push
out a -rc2 after this goes through some local build tests.

greg k-h
