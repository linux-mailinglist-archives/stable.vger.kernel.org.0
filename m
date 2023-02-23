Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF276A0E0E
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 17:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjBWQb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 11:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBWQb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 11:31:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012CB126C9;
        Thu, 23 Feb 2023 08:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FCC661761;
        Thu, 23 Feb 2023 16:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0B2C433EF;
        Thu, 23 Feb 2023 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677169884;
        bh=IoOpMdJMMufC5j2/gAEF1pE3PIHEhES/laRJlr0+P9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H2X3EmqlSd4LpquhLHf2QltIctwsZvWBJt3/UAib6EyF977ytLFXNlHFwbs/2gI5K
         ewLA4mCCNI8nVBgCLlOP9UR+gk0P8GzcBmtS+pgW4UJyF4tTK0nLfLoT0eIPrZhXxr
         th879Smnp3bpY740pxvReHidnPSUw0eQpB0QO4P4=
Date:   Thu, 23 Feb 2023 17:31:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/46] 6.1.14-rc1 review
Message-ID: <Y/eU2oQ3qhpEeV+R@kroah.com>
References: <20230223130431.553657459@linuxfoundation.org>
 <Y/d5KdOfh5rXUeqk@wendy>
 <CA+G9fYsG8t1qO6MzJ=OYmegDwXCePafWbYjCc=JgiF3Mk5yQxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsG8t1qO6MzJ=OYmegDwXCePafWbYjCc=JgiF3Mk5yQxg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 08:08:43PM +0530, Naresh Kamboju wrote:
> On Thu, 23 Feb 2023 at 20:03, Conor Dooley <conor.dooley@microchip.com> wrote:
> >
> > On Thu, Feb 23, 2023 at 02:06:07PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.14 release.
> > > There are 46 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> >
> > > Dave Hansen <dave.hansen@linux.intel.com>
> > >     uaccess: Add speculation barrier to copy_from_user()
> >
> > This breaks the build for me on RISC-V, you need to take f3dd0c53370e
> > ("bpf: add missing header file include") from Linus' tree.
> > It was broken in mainline too, so it is probably broken everywhere you
> > backported it :(
> 
> Thanks for your report.
> 
> I do see arm and arm64 build breaks with following build warnings / errors:
> 
> kernel/bpf/core.c: In function '___bpf_prog_run':
> kernel/bpf/core.c:1911:17: error: implicit declaration of function
> 'barrier_nospec' [-Werror=implicit-function-declaration]
>  1911 |                 barrier_nospec();
>       |                 ^~~~~~~~~~~~~~
> cc1: some warnings being treated as errors

Should all be fixed up in the -rc2 releases.

thanks,

greg k-h
