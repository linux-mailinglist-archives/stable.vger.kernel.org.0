Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5441A69EA36
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 23:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBUWdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 17:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjBUWdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 17:33:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AC52E0E3
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 14:33:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFE5611F9
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 22:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91A7C433EF;
        Tue, 21 Feb 2023 22:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677018813;
        bh=bhXxhbEaEnMf8ZbGJA8+1NxgqqmQSzTnoWAE5jD/z6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVzmVHC2Mo9UUrN5K2TNb49Gqxw9oXP8BcGJThwDJMllEgZ91pbLbLBT/9WqjPotG
         zcXv+DyOXkZXUK2CqaOfZg77KLmS7hp6dg7iqm4D59SMfdVAolDcJ6Cv4mpJh2o3kc
         8YmjMz18+B1z/6IrOgOdiAUHWmfgGT3Pc23L0fwXrmQme02Zsz82VaozJfB0TCrcCp
         hRTAVUWb6dkq8ioxGhApimK3tMyzrujU5fozZ8ffMLDKVcen05MS6MSTBV+BZA2EuA
         BaZrKGJjvZEDsLevE7rDdpG4LUhmIvJwphkJxxRamcB+wfTaorGAf5QXPQx2rQ/DjG
         PuTOQrIWoocOQ==
Date:   Tue, 21 Feb 2023 15:33:31 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, llvm@lists.linux.dev,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, conor@kernel.org,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: stable-rc: 5.10: riscv: defconfig: clang-nightly: build failed -
 Invalid or unknown z ISA extension: 'zifencei'
Message-ID: <Y/VGu9IOJEKi6VwS@dev-arch.thelio-3990X>
References: <CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com>
 <Y/SLn5fto6+9xX0r@wendy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/SLn5fto6+9xX0r@wendy>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 09:15:11AM +0000, Conor Dooley wrote:
> On Tue, Feb 21, 2023 at 02:30:17PM +0530, Naresh Kamboju wrote:
> > The riscv defconfig and tinyconfig builds failed with clang-nightly
> > due to below build warnings / errors on latest stable-rc 5.10.
> > 
> > Regression on riscv:
> >   - build/clang-nightly-tinyconfig - FAILED
> >   - build/clang-nightly-defconfig - FAILED
> 
> > Build log:
> > ----
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=riscv
> > CROSS_COMPILE=riscv64-linux-gnu- HOSTCC=clang CC=clang LLVM=1
> > LLVM_IAS=1 LD=riscv64-linux-gnu-ld
> > riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> > Invalid or unknown z ISA extension: 'zifencei'
> > riscv64-linux-gnu-ld: failed to merge target specific data of file
> > init/version.o
> > riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> > Invalid or unknown z ISA extension: 'zifencei'
> > riscv64-linux-gnu-ld: failed to merge target specific data of file
> > init/do_mounts.o
> > riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> > Invalid or unknown z ISA extension: 'zifencei'
> > riscv64-linux-gnu-ld: failed to merge target specific data of file
> > init/noinitramfs.o
> > riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> > Invalid or unknown z ISA extension: 'zifencei'
> > riscv64-linux-gnu-ld: failed to merge target specific data of file
> > init/calibrate.o
> > riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> > Invalid or unknown z ISA extension: 'zifencei'
> 
> > Build details,
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.168-58-g7d11e4c4fc56/testrun/14869376/suite/build/test/clang-nightly-tinyconfig/details/
> 
> binutils 2.35 by the looks of things, I **think** that zifencei didn't
> land until 2.36. zicsr and zifence get added via cc-option-yn, which,
> IIRC, doesn't do anything with the linker. I dunno if anyone in RISC-V
> land cares this much about "odd" configurations back in 5.10, but while
> a fix is outstanding, you could use a newer binutils?

This is new in clang-17 so I bisected LLVM down to commit 22e199e6afb1
("[RISCV] Accept zicsr and zifencei command line options"), so I think
we need something like commit aae538cd03bc ("riscv: fix detection of
toolchain Zihintpause support") for zifencei to make sure all three
tools stay in sync, since I suspect that this is reproducible in
mainline with GNU ld. We just happen not to notice when using
LLVM=1 LLVM_IAS=1 since the tools have symmetrical support.

I can work up something like that change tomorrow if that seems like the
path worth taking.

Cheers,
Nathan
