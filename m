Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C017C532CED
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 17:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbiEXPGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238643AbiEXPGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:06:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E3310D2;
        Tue, 24 May 2022 08:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A03E8CE1A79;
        Tue, 24 May 2022 15:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F584C34115;
        Tue, 24 May 2022 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653404770;
        bh=O7X4vE0GlOx06lgMAdKQm11gzb+06yXdlSRL4alplco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nXf8Pp4fGvt+fnXcEdHe0oVPOpJaZqbDkmhh9pIhlpLW55pk3P060FwGGr2d1dG7Q
         8yNT5+f8qiNXIUrXFCuduVvciw6f7N+G/STt1HSyXMXFcTrBwEU6o+Adp57HsbWD2h
         fGM0fTuPFz8UJVl90erQPksltcKDZ0t1ZkqphJHA=
Date:   Tue, 24 May 2022 17:06:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
Message-ID: <Yoz0Xv59MrUwFkMT@kroah.com>
References: <20220523165743.398280407@linuxfoundation.org>
 <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
 <YozK4DvamHBJ1qdX@kroah.com>
 <fbeb9833-4166-1919-e6ab-9ac7625a21d6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbeb9833-4166-1919-e6ab-9ac7625a21d6@nvidia.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 03:55:58PM +0100, Jon Hunter wrote:
> 
> On 24/05/2022 13:09, Greg Kroah-Hartman wrote:
> 
> ...
> 
> > > I am seeing a boot regression on tegra124-jetson-tk1 and reverting the above
> > > commit is fixing the problem. This also appears to impact linux-4.14.y,
> > > 4.19.y and 5.4.y.
> > > 
> > > Test results for stable-v4.9:
> > >      8 builds:	8 pass, 0 fail
> > >      18 boots:	16 pass, 2 fail
> > >      18 tests:	18 pass, 0 fail
> > > 
> > > Linux version:	4.9.316-rc1-gbe4ec3e3faa1
> > > Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
> > >                  tegra210-p2371-2180, tegra30-cardhu-a04
> > > 
> > > Boot failures:	tegra124-jetson-tk1
> > 
> > Odd.  This is also in 5.10.y, right?  No issues there?  Are we missing
> > something?
> 
> 
> Actually, the more I look at this, the more I see various intermittent
> reports with this and it is also impacting the mainline.
> 
> The problem is that the commit in question is causing a ton of messages to
> be printed a boot and this sometimes is causing the boot test to fail
> because the boot is taking too long. The console shows ...
> 
> [ 1233.327547] CPU0: Spectre BHB: using loop workaround
> [ 1233.327795] CPU1: Spectre BHB: using loop workaround
> [ 1233.328270] CPU1: Spectre BHB: using loop workaround
> [ 1233.328700] CPU1: Spectre BHB: using loop workaround
> [ 1233.355477] CPU2: Spectre BHB: using loop workaround
> ** 7 printk messages dropped **
> [ 1233.366271] CPU0: Spectre BHB: using loop workaround
> [ 1233.366580] CPU0: Spectre BHB: using loop workaround
> [ 1233.366815] CPU1: Spectre BHB: using loop workaround
> [ 1233.405475] CPU1: Spectre BHB: using loop workaround
> [ 1233.405874] CPU0: Spectre BHB: using loop workaround
> [ 1233.406041] CPU1: Spectre BHB: using loop workaround
> ** 1 printk messages dropped **
> 
> There is a similar report of this [0] and I believe that we need a similar
> fix for the above prints as well. I have reported this to Ard [1]. So I am
> not sure that these Spectre BHB patches are quite ready for stable.

These patches are quite small, and just enable it for this known-broken
cpu type.

If there is an issue enabling it for this cpu type, then we can work on
that upstream, but there shouldn't be a reason to prevent this from
being merged now, especially given that it is supposed to be fixing a
known issue.

thanks,

greg k-h
