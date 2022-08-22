Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CC459BF18
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 13:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbiHVL6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 07:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiHVL6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 07:58:18 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E069286;
        Mon, 22 Aug 2022 04:58:12 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 27MBwBf8019247;
        Mon, 22 Aug 2022 13:58:11 +0200
Date:   Mon, 22 Aug 2022 13:58:11 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Message-ID: <20220822115811.GE17080@1wt.eu>
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com>
 <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
 <YwMxRAfrrsPE6sNI@kroah.com>
 <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
 <YwM3DwvPIGkfE4Tu@kroah.com>
 <acc6051b-748f-4f06-63b3-919eb831217c@gmx.com>
 <YwNFxIouYoRo/wT+@kroah.com>
 <34793a7b-64e4-f1cb-b84e-5804b4f6fac3@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34793a7b-64e4-f1cb-b84e-5804b4f6fac3@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 07:43:18PM +0800, Qu Wenruo wrote:
> Tried to compile gcc10 from AUR, which failed to compile.
> 
> 
> Anyway, thanks to the advice from Willy, I got the pre-built crosstool
> (gcc 7.5) set up, with some small tweaks like disabling
> CONFIG_RANDOMIZE_BASE to workaround the RELOCS failure, it at least
> compiles for v4.14.0.
> 
> Although there is still warning from test_gen_len:
> 
>  Warning: ffffffff818158cc:	0f ff e9             	ud0    %ecx,%ebp
>  Warning: objdump says 3 bytes, but insn_get_length() says 2
>  Warning: arch/x86/tools/test_get_len found difference at
> <cpu_idle_poll>:ffffffff818159b0

Strange, sounds like a binutils issue though I could be wrong.

> And unfortunately v4.14 still fails to boot, even with GCC 7.5, which
> provides an almost perfect (except above wanrings) build.
> 
> I also tried to reduce the CPUid, from host-passthru to qemu64, and
> rebuild, no change (same test_get_len wanrings, same boot failure).
> 
> No clue at all now, would try older debian in a VM then.

I suggest that instead of switching distros you should rather first
try 4.14.0 to verify if there was a regression affecting your system.
And if so, then a bisect will certainly be welcome. If it still does
not work, then maybe a different distro could help, though I doubt it.

Willy
