Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BDE562E14
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 10:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiGAI0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 04:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiGAI0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 04:26:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E2B796BC;
        Fri,  1 Jul 2022 01:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC47761CE3;
        Fri,  1 Jul 2022 08:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BA7C341C6;
        Fri,  1 Jul 2022 08:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656663853;
        bh=n9dhyCK11IrHKMh1ZOr35YIkHf8CJtBe9qy5A3a85Fk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y/6nmU94zHyjEvECDtSMi1RzCikXHQqUCgMGttL3y6b/MKONcNZpBCVybJzOLmVE4
         gTDazxLDWNksyAeQK5DAYEXaO03xWyeVtOSAI0wsaETM9akyBxOHCAimon66Kx1/fd
         REVg0KA+cPX47deQ1TZi1fsAxQQVAqSF2vDS9iyk=
Date:   Fri, 1 Jul 2022 10:24:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Message-ID: <Yr6vKgOmqF562oc+@kroah.com>
References: <20220630133230.239507521@linuxfoundation.org>
 <Yr6pTvc0Zka7qVfc@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr6pTvc0Zka7qVfc@debian.me>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 01, 2022 at 02:59:10PM +0700, Bagas Sanjaya wrote:
> On Thu, Jun 30, 2022 at 03:47:26PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.18.9 release.
> > There are 6 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> 
> Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 12.1.0)
> and powerpc (ps3_defconfig, GCC 12.1.0).
> 
> I get a warning on cifs:
> 
>   CC [M]  fs/cifs/connect.o
>   CC      drivers/tty/tty_baudrate.o
>   CC      drivers/tty/tty_jobctrl.o
> fs/cifs/connect.c: In function 'is_path_remote':
> fs/cifs/connect.c:3426:14: warning: unused variable 'nodfs' [-Wunused-variable]
>  3426 |         bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
>       |              ^~~~~
> 
> The culprit is commit 2340f1adf9fbb3 ("cifs: don't call
> cifs_dfs_query_info_nonascii_quirk() if nodfs was set") (upstream commit
> 421ef3d56513b2).

Again, gcc-12 is going to have problems with stable releases until
Linus's tree is fixed up entirely.  Once that happens, then I will take
backports to stable kernels to get them to build properly.

But until then, no need to report anything here, as there's nothing I
can do.

thanks,

greg k-h
