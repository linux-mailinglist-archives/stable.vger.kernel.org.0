Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F7B5841FB
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiG1Ol5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiG1Olj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1801AD68;
        Thu, 28 Jul 2022 07:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6BAD619A0;
        Thu, 28 Jul 2022 14:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8188FC433D6;
        Thu, 28 Jul 2022 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659019244;
        bh=x3BbMBebWS2xumUffqhwncq3wIP/qRCy6BYtHkcFWtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JRls25zm1PC0THIn5fv68AmANWaIO/n1RFKMPaXtI714RjXYEy0FTO2+yPfpI0Wxv
         n+LWa7IkIj4WHyYtOGPyLYV3KTRJzIOT80CqlNJZPMP08Gt+FUtGXNK7IDBdJ/Uwj+
         RD8vcic19hqx+Y1180o4llrWEPMtA1Guxreou6dU=
Date:   Thu, 28 Jul 2022 16:40:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/105] 5.10.134-rc1 review
Message-ID: <YuKf6bIbwVRpw2q/@kroah.com>
References: <20220727161012.056867467@linuxfoundation.org>
 <570b5e5a-c25d-ccd4-42ce-f2d73d4e3511@roeck-us.net>
 <219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 07:22:09AM -0700, Guenter Roeck wrote:
> On 7/28/22 06:20, Guenter Roeck wrote:
> > On 7/27/22 09:09, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.134 release.
> > > There are 105 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Crashes when trying to boot from btrfs file system. Crash log below.
> > I'll bisect.
> > 
> 
> bisect log:
> 
> # bad: [d2801d3917f2749cb2ec1788ee94021acbb8c2ad] Linux 5.10.134-rc1
> # good: [5034934536433b2831c80134f1531bbdbc2de160] Linux 5.10.133
> git bisect start 'HEAD' 'v5.10.133'
> # bad: [c03ac6b78c06b8f9f500ba859f13b5b7c9557520] tcp: Fix a data-race around sysctl_tcp_tw_reuse.
> git bisect bad c03ac6b78c06b8f9f500ba859f13b5b7c9557520
> # bad: [36d59bca14ae38aa24ba8b12d0d3bd1d5d58f4c8] drm/amdgpu/display: add quirk handling for stutter mode
> git bisect bad 36d59bca14ae38aa24ba8b12d0d3bd1d5d58f4c8
> # bad: [271e142fbfd4da6b80a179c5b1a1599e77bcb9e7] net: inline rollback_registered()
> git bisect bad 271e142fbfd4da6b80a179c5b1a1599e77bcb9e7
> # good: [e9d008ed8b527bded5ffff5f0e46756b01d2fb8a] xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE
> git bisect good e9d008ed8b527bded5ffff5f0e46756b01d2fb8a
> # bad: [fc360adfd749d004819019e9ac6eb261e1bc434c] docs: net: explain struct net_device lifetime
> git bisect bad fc360adfd749d004819019e9ac6eb261e1bc434c
> # bad: [6b4d59cc6a3ff5c9836cd2b617e19354fb1bdf78] block: fix bounce_clone_bio for passthrough bios
> git bisect bad 6b4d59cc6a3ff5c9836cd2b617e19354fb1bdf78
> # bad: [7c4bd973d072c7f3bd7b63cedeb81ed4e06e6c4a] block: split bio_kmalloc from bio_alloc_bioset
> git bisect bad 7c4bd973d072c7f3bd7b63cedeb81ed4e06e6c4a
> # first bad commit: [7c4bd973d072c7f3bd7b63cedeb81ed4e06e6c4a] block: split bio_kmalloc from bio_alloc_bioset

Crap, I was really worried about this set of patches.  I'll go revert
them and ask for the submitter who wanted them to REALLY test them out
before sending them in again.  As it was, I had to pick up a load of
fix-ups that the original requestor missed, odds are there's a few more
missing that are also needed.

thanks for the bisection, helps loads, I'll fix this up and push out a
-rc2.

thanks,

greg k-h
