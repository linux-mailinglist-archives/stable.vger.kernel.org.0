Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3D133AE8A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 10:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCOJVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 05:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhCOJU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 05:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C552E64E31;
        Mon, 15 Mar 2021 09:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615800056;
        bh=vBIlPWM9vkyAXquqB5CHKO9pN0K+cHl3v3MxzH8369o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jRmWRDhL0YDmS3WveWUBjTFzsbx3524sKTQdLTvYirmiJIbFbgJpoj0votLyUUWC+
         y0JgW289NdroNZWx/XnrJWpocLL8HCgUI4+NFTGmm3UUh5f6Gf7MgjPEuNROgno0gF
         HOFUTk1pya+THWvMq6ZeYZNLjFnLFr+1S2XxwlfA=
Date:   Mon, 15 Mar 2021 10:20:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: v5.4.y-queue, v5.10.y-queue build failures
Message-ID: <YE8m9c5jvIZ4dlKA@kroah.com>
References: <066efc42-0788-8668-2ff5-d431e77068b5@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <066efc42-0788-8668-2ff5-d431e77068b5@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 14, 2021 at 05:32:55PM -0700, Guenter Roeck wrote:
> Building mips:allnoconfig ... failed
> --------------
> Error log:
> WARNING: vmlinux.o(.text+0x9cd4): Section mismatch in reference from the function reserve_exception_space() to the function .meminit.text:memblock_reserve()
> The function reserve_exception_space() references
> the function __meminit memblock_reserve().
> This is often because reserve_exception_space lacks a __meminit
> annotation or the annotation of memblock_reserve is wrong.
> FATAL: modpost: Section mismatches detected.
> Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
> make[2]: *** [scripts/Makefile.modpost:66: __modpost] Error 1
> make[1]: *** [Makefile:1100: vmlinux] Error 2
> make: *** [Makefile:179: sub-make] Error 2
> --------------
> Building mips:tinyconfig ... failed
> --------------
> Error log:
> WARNING: vmlinux.o(.text+0x9130): Section mismatch in reference from the function reserve_exception_space() to the function .meminit.text:memblock_reserve()
> The function reserve_exception_space() references
> the function __meminit memblock_reserve().
> This is often because reserve_exception_space lacks a __meminit
> annotation or the annotation of memblock_reserve is wrong.
> FATAL: modpost: Section mismatches detected.
> Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
> make[2]: *** [scripts/Makefile.modpost:66: __modpost] Error 1
> make[1]: *** [Makefile:1100: vmlinux] Error 2
> make: *** [Makefile:179: sub-make] Error 2
> --------------
> 
> Bisect of allnoconfig in v5.4.y-queue:
> 
> # bad: [2bcbae06b8fb9030973ee996e1b8ed43f3bfd4ab] Linux 5.4.106-rc1
> # good: [ce615a08404c821bcb3c6f358b8f34307bfe30c9] Linux 5.4.105
> git bisect start 'HEAD' 'v5.4.105'
> # good: [bd6952cc4634c2ce46d5c9615c4b9bc66049bab3] net: hns3: fix error mask definition of flow director
> git bisect good bd6952cc4634c2ce46d5c9615c4b9bc66049bab3
> # bad: [51eefc7c01fca6cbbae9a75850e32a05ce814698] crypto: arm - use Kconfig based compiler checks for crypto opcodes
> git bisect bad 51eefc7c01fca6cbbae9a75850e32a05ce814698
> # bad: [0f684432b233e1b11a3950e5da596575b24173ef] powerpc/64: Fix stack trace not displaying final frame
> git bisect bad 0f684432b233e1b11a3950e5da596575b24173ef
> # bad: [f45ae3c66aae2459e8b2208a31fffcccce4c9b8b] mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'
> git bisect bad f45ae3c66aae2459e8b2208a31fffcccce4c9b8b
> # bad: [353c41af24ecc267a0334a5e4b2c08e6e5f5fd64] net: phy: fix save wrong speed and duplex problem if autoneg is on
> git bisect bad 353c41af24ecc267a0334a5e4b2c08e6e5f5fd64
> # bad: [9f79af92045b80792a5f7aaa1f0612ddd4fcb6af] net: enetc: initialize RFS/RSS memories for unused ports too
> git bisect bad 9f79af92045b80792a5f7aaa1f0612ddd4fcb6af
> # bad: [d14e578414046982a7bb60c6ee8a46e6b73bd84e] MIPS: kernel: Reserve exception base early to prevent corruption
> git bisect bad d14e578414046982a7bb60c6ee8a46e6b73bd84e
> # first bad commit: [d14e578414046982a7bb60c6ee8a46e6b73bd84e] MIPS: kernel: Reserve exception base early to prevent corruption
> 
> Reverting the offending patch fixes the problem.

Now dropped, thanks.

greg k-h
