Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B7D54B767
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 19:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244735AbiFNRMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 13:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244479AbiFNRMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 13:12:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7912B13DD9;
        Tue, 14 Jun 2022 10:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A61B6166C;
        Tue, 14 Jun 2022 17:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6439BC3411D;
        Tue, 14 Jun 2022 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655226752;
        bh=peyZwVSOaogAFeJxpKowfzymLa/etOhDZTzm9M6ehBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KlUt4+38+8rfoiPeMI4kOjUhIbqNkw4vYxBFtxau4KQN3BdHGtYJ4ubre7hOUkjpl
         ri35qfOSdhVv5Z6LvLEjKJAzS13WXlFhs+yWHgG7a4dXVm3a1Ye1mSLSEp2AdkPihR
         Uq9Wc00DGpYaoOF2Whsywp669sjcQzB+616MlJhw=
Date:   Tue, 14 Jun 2022 19:12:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <YqjBfjUYVRE1k9iM@kroah.com>
References: <20220613181847.216528857@linuxfoundation.org>
 <20220614153607.GB3088490@roeck-us.net>
 <20220614170827.GB3690098@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614170827.GB3690098@roeck-us.net>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 10:08:27AM -0700, Guenter Roeck wrote:
> On Tue, Jun 14, 2022 at 08:36:08AM -0700, Guenter Roeck wrote:
> > On Mon, Jun 13, 2022 at 08:19:49PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.47 release.
> > > There are 251 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 159 pass: 159 fail: 0
> > Qemu test results:
> > 	total: 488 pass: 488 fail: 0
> > 
> 
> I spoke a bit too early. I see the following backtrace in some qemu arm
> boot tests.
> 
> BUG: spinlock bad magic on CPU#0, kdevtmpfs/15
>  lock: noop_backing_dev_info+0x6c/0x3b0, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> CPU: 0 PID: 15 Comm: kdevtmpfs Not tainted 5.15.47-rc2-00252-g677f0128d0ed #1
> Hardware name: ARM RealView Machine (Device Tree Support)
> [<c01101d0>] (unwind_backtrace) from [<c010bc0c>] (show_stack+0x10/0x14)
> [<c010bc0c>] (show_stack) from [<c0a10ae4>] (dump_stack_lvl+0x68/0x90)
> [<c0a10ae4>] (dump_stack_lvl) from [<c0191250>] (do_raw_spin_lock+0xbc/0x124)
> [<c0191250>] (do_raw_spin_lock) from [<c02eb578>] (__mark_inode_dirty+0x1cc/0x704)
> [<c02eb578>] (__mark_inode_dirty) from [<c02e6a74>] (simple_setattr+0x44/0x5c)
> [<c02e6a74>] (simple_setattr) from [<c02d7a18>] (notify_change+0x400/0x45c)
> [<c02d7a18>] (notify_change) from [<c0a19ef8>] (devtmpfsd+0x1f8/0x2b8)
> [<c0a19ef8>] (devtmpfsd) from [<c014cf3c>] (kthread+0x150/0x17c)
> [<c014cf3c>] (kthread) from [<c0100120>] (ret_from_fork+0x14/0x34)
> Exception stack(0xd00dbfb0 to 0xd00dbff8)
> bfa0:                                     00000000 00000000 00000000 00000000
> bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 
> This bisects to commit bc5d960d4e58 ("writeback: Fix inode->i_io_list not
> be protected by inode->i_lock error"). The problem is also seen in the
> mainline kernel. v5.15.y.queue and later are affected. Reverting the patch
> here and in mainline fixes the problem.

Thanks for letting me know.  Hopefully it gets fixed in upstream...
