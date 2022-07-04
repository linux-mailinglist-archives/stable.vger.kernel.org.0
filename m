Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D555658D9
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 16:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiGDOlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 10:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiGDOlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 10:41:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1432BF61;
        Mon,  4 Jul 2022 07:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25E60B81074;
        Mon,  4 Jul 2022 14:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B97BC3411E;
        Mon,  4 Jul 2022 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656945618;
        bh=YfXvpgNTPd6wqKycqGcp7pXMQrFy8/mCKXTtRgjATvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cC6SKa+4avw+8gPSbujRBlDN+uYDcG43aLYdUM2yIDqONAm9o+IMxCk6Ac+adI+Ol
         vn4IG6+iAYdH4p30JLFOya2rsoQnqj5/58ZkiWgQfr35tbmkXGTTgf90/HAM0BtgvB
         1+wMqFLkEJhz0NmzfaMPUk3gGpGRx6nNRNaWYOhk=
Date:   Mon, 4 Jul 2022 16:40:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, slade@sladewatkins.com,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Message-ID: <YsL70A0fxJ6BtwDu@kroah.com>
References: <20220630133230.239507521@linuxfoundation.org>
 <Yr6pTvc0Zka7qVfc@debian.me>
 <Yr6vKgOmqF562oc+@kroah.com>
 <Yr7M//9X8RdNz+Hu@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr7M//9X8RdNz+Hu@debian>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 01, 2022 at 11:31:27AM +0100, Sudip Mukherjee wrote:
> On Fri, Jul 01, 2022 at 10:24:10AM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jul 01, 2022 at 02:59:10PM +0700, Bagas Sanjaya wrote:
> > > On Thu, Jun 30, 2022 at 03:47:26PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.18.9 release.
> > > > There are 6 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > 
> > > Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 12.1.0)
> > > and powerpc (ps3_defconfig, GCC 12.1.0).
> > > 
> > > I get a warning on cifs:
> > > 
> > >   CC [M]  fs/cifs/connect.o
> > >   CC      drivers/tty/tty_baudrate.o
> > >   CC      drivers/tty/tty_jobctrl.o
> > > fs/cifs/connect.c: In function 'is_path_remote':
> > > fs/cifs/connect.c:3426:14: warning: unused variable 'nodfs' [-Wunused-variable]
> > >  3426 |         bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
> > >       |              ^~~~~
> > > 
> > > The culprit is commit 2340f1adf9fbb3 ("cifs: don't call
> > > cifs_dfs_query_info_nonascii_quirk() if nodfs was set") (upstream commit
> > > 421ef3d56513b2).
> > 
> > Again, gcc-12 is going to have problems with stable releases until
> > Linus's tree is fixed up entirely.  Once that happens, then I will take
> > backports to stable kernels to get them to build properly.
> 
> I have not tested, but this should be fixed by this one:
> 
> 93ed91c020aa ("cifs: fix minor compile warning")

Thanks, now queued up.

greg k-h
