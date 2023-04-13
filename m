Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81196E104D
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 16:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjDMOq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 10:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjDMOqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 10:46:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374E719B7;
        Thu, 13 Apr 2023 07:46:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9520A63F41;
        Thu, 13 Apr 2023 14:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCCAC433D2;
        Thu, 13 Apr 2023 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681397187;
        bh=xB0g7VKULAqtplPv631WkWR3el9jGpalRG/x43DEig8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ojfPHAYXtitRJwYXSzFtwNw9qhx2hI53msnC00q/T2iMQ5NeK206NwEeCFN4Y/Ctv
         yFMfSOxR5fY1ICiQg1pLoqB8ELhQeR41WhrJcQSgqufnBy4oleDF3Vaae62tfg/HdJ
         eHJIoBCf18e9SbaftgJXpupX+wnBPOjvFXw87oNI=
Date:   Thu, 13 Apr 2023 16:46:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eddie Chapman <eddie@ehuk.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review (possible amdgpu
 regression)
Message-ID: <2023041326-esophagus-spoils-4c3f@gregkh>
References: <20230412082823.045155996@linuxfoundation.org>
 <97c9d345-b57c-8024-be35-357c8842115a@ehuk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97c9d345-b57c-8024-be35-357c8842115a@ehuk.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 10:47:13PM +0100, Eddie Chapman wrote:
> Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.107 release.
> > There are 93 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please let
> > me know.
> > 
> > Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> > Anything received after that time might be too late.
> > 
> 
> I think I'm seeing a regression here in the amdgpu driver, though not being
> a kernel dev I could be wrong.
> 
> I built and booted this today on an x86_64 machine (AMD Ryzen 7 3700X,
> Gigabyte X570 UD motherboard) with 3 x AMD graphics cards (using names from
> lspci output):
> - Cape Verde GL [FirePro W4100]
> - Oland XT [Radeon HD 8670 / R5 340X OEM / R7 250/350/350X OEM] (rev 83)
> - Bonaire [Radeon R7 200 Series]
> 
> All three using the amdgpu driver (radeon module blacklisted).
> 
> This machine has been running vanilla 5.15 stable releases for a good while,
> with the kernel updated with whatever the latest 5.15 release is every 6
> weeks or so. Never had any amdgpu problems.
> 
> To build 5.15.107-rc1 I applied the contents of the queue-5.15 directory on
> top of 5.15.106, having synced the stable queue git repo up until commit
> 344d8ad1b5dde387d1ce4d1be2641753b89dd10d (still the latest commit as a
> type). This is what I have done for years running vanilla stable kernels.
> 
> There was nothing out of the ordinary in the build output, but on rebooting
> into 5.15.107-rc1 I had the following error in dmesg from 1 card only:
> 
> amdgpu 0000:0d:00.0: [drm:amdgpu_ib_ring_tests [amdgpu]] *ERROR* IB test
> failed on vce0 (-110).
> [drm:process_one_work] *ERROR* ib ring test failed (-110).
> 
> This was during bootup immediately after driver loading. X is not running.
> 0000:0d:00.0 is the Bonaire card.
> 
> I then shutdown and fully powered off for a few minutes, booted 5.15.107-rc1
> again, but the error on that card persisted exactly the same.
> 
> This was a regression for me as I've never had that error before on any
> kernel release (I grepped through old kernel logs to check).
> 
> I then rebuilt 5.15.107-rc1 but without applying the following 4 patches:
> 
> drm-panfrost-fix-the-panfrost_mmu_map_fault_addr-error-path.patch
> drm-amdgpu-fix-amdgpu_job_free_resources-v2.patch
> drm-amdgpu-prevent-race-between-late-signaled-fences.patch
> drm-bridge-lt9611-fix-pll-being-unable-to-lock.patch
> 
> On booting into the newly built kernel there was no error anymore, amdgpu
> dmesg output was as normal, and the machine is running fine now on that.
> 
> So I'm quite confident one of those patches introduced the error for me.
> Having now looked at the contents of them I see the lt9611 is entirely
> different hardware and I'm guessing the panfrost one probably is as well, so
> most likely I didn't need to remove those 2.
> 
> This is not a great report and maybe not helpful (sorry) as unfortunately I
> cannot try and narrow it down further to a single patch as this machine has
> to stay running now for a while. I just crudely tried yanking those 4 to
> hopefully get rid of the error and get the machine running again. Also I
> didn't go on to test whether the card actually worked as expected, maybe the
> error is harmless after all, though it doesn't look insignificant.
> 
> As the error was only output for the Bonaire card (the other two were fine),
> below is lspci -vvv output for that card only in case it helps. If anyone
> would like further info just let me know.

Ok, I've dropped the two drm-amdgpu-* patches from the tree for now.
Let me know if the release works properly for you or not.

thanks for testing and letting us know!

greg k-h
