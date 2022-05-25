Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07DC53373E
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243143AbiEYHRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244308AbiEYHRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:17:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E719E25DA;
        Wed, 25 May 2022 00:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D06F61750;
        Wed, 25 May 2022 07:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EF4C385B8;
        Wed, 25 May 2022 07:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653463021;
        bh=ta4NQ7XiMcnlKRrNO3QHpmRH6BLFECd/mov8h2352+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uXDTdSh2UH6XzqdXJvjZKevbUBRfwDJE4QrBai0lWwryBP5a5GhqrH236WAL1q5aQ
         JymtI2W6JXrgeZxNeQjy571bkh0pH4yr72GvF0vxsJIXlmRB8rd/QGGZql7OVpu5Vr
         2pLouSoj8hM+SDuQbTHIJDwi0rKYyCgG1oRe/0dE=
Date:   Wed, 25 May 2022 09:16:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/97] 5.10.118-rc1 review
Message-ID: <Yo3X6vko52ka4zwh@kroah.com>
References: <20220523165812.244140613@linuxfoundation.org>
 <18a4a99f-e72a-1578-d6e5-8f5bb4ec4897@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18a4a99f-e72a-1578-d6e5-8f5bb4ec4897@linaro.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 04:36:39PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 23/05/22 12:05, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.118 release.
> > There are 97 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.118-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We see a build failure with Perf on x86_64 and i386, with bisection pointing to:
> 
> > Kan Liang <kan.liang@linux.intel.com>
> >      perf regs x86: Fix arch__intr_reg_mask() for the hybrid platform
> 
> The error message is:
> 
>   arch/x86/util/perf_regs.c:13:10: fatal error: ../../../util/pmu-hybrid.h: No such file or directory
>      13 | #include "../../../util/pmu-hybrid.h"
>         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   compilation terminated.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Commit is now dropped, thanks.

greg k-h
