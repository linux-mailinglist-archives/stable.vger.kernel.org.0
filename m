Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E19E23D8AC
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 11:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgHFJal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 05:30:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:55826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbgHFJaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 05:30:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58CA3B668;
        Thu,  6 Aug 2020 09:30:16 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3660A1E12C9; Thu,  6 Aug 2020 11:29:59 +0200 (CEST)
Date:   Thu, 6 Aug 2020 11:29:59 +0200
From:   Jan Kara <jack@suse.cz>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jiang Ying <jiangying8582@126.com>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, wanglong19@meituan.com
Subject: Re: stable rc 4.4 - v4.4.232-33-g0b3898baf614 - build breaks on
 arm64, arm, x86_64 and i386.
Message-ID: <20200806092959.GB1313@quack2.suse.cz>
References: <CA+G9fYtpsT23+xXkOfhBt3RP6MeHKjQCrmgF921mDdwQ+wZu2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtpsT23+xXkOfhBt3RP6MeHKjQCrmgF921mDdwQ+wZu2g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 05-08-20 22:42:08, Naresh Kamboju wrote:
> stable rc 4.4 build breaks on arm64, arm, x86_64 and i386.
> 
> Here are the build log failures on arm64.
>    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>     target_arch: arm64
>     toolchain: gcc-9
>     git_short_log: 0b3898baf614 (\Linux 4.4.233-rc1\)
>     git_sha: 0b3898baf61459e1f963dcf893b4683174668975
>     git_describe: v4.4.232-33-g0b3898baf614
>     kernel_version: 4.4.233-rc1
> 
> make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
> aarch64-linux-gnu-gcc" O=build Image
> #
> ../arch/arm64/kernel/hw_breakpoint.c: In function ‘arch_bp_generic_fields’:
> ../arch/arm64/kernel/hw_breakpoint.c:348:5: note: parameter passing
> for argument of type ‘struct arch_hw_breakpoint_ctrl’ changed in GCC
> 9.1
>   348 | int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctrl,
>       |     ^~~~~~~~~~~~~~~~~~~~~~
> ../fs/ext4/inode.c: In function ‘ext4_direct_IO’:
> ../fs/ext4/inode.c:3355:9: error: ‘offset’ redeclared as different
> kind of symbol
>  3355 |  loff_t offset = iocb->ki_pos;
>       |         ^~~~~~
> ../fs/ext4/inode.c:3349:17: note: previous definition of ‘offset’ was here
>  3349 |          loff_t offset)
>       |          ~~~~~~~^~~~~~

This looks like a breakage from "ext4: fix direct I/O read error" where for
4.4 the patch needs to be updated (addition of the line
"loff_t offset = iocb->ki_pos;" needs to be removed from the patch because
'offset' is already passed from the caller. Jiang, will you update the patch
for 4.4 kernels please?

								Honza

> make[3]: *** [../scripts/Makefile.build:277: fs/ext4/inode.o] Error 1
> make[3]: Target '__build' not remade because of errors.
> make[2]: *** [../scripts/Makefile.build:484: fs/ext4] Error 2
> ../drivers/net/ethernet/apm/xgene/xgene_enet_main.c:32:36: warning:
> array ‘xgene_enet_acpi_match’ assumed to have one element
>    32 | static const struct acpi_device_id xgene_enet_acpi_match[];
>       |                                    ^~~~~~~~~~~~~~~~~~~~~
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [/linux/Makefile:1006: fs] Error 2
> make[1]: Target 'Image' not remade because of errors.
> make: *** [Makefile:152: sub-make] Error 2
> make: Target 'Image' not remade because of errors.
> 
> -- 
> Linaro LKFT
> https://lkft.linaro.org
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
