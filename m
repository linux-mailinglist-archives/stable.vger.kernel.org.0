Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC511487D3A
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 20:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiAGTn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 14:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiAGTn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 14:43:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF468C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 11:43:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCB34B82768
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 19:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3DDC36AE9;
        Fri,  7 Jan 2022 19:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641584634;
        bh=3ReycX2PmwqL8N5r5obhn2BQBzx0StuQjWOgoCkzjTg=;
        h=From:To:Cc:Subject:Date:From;
        b=g2keSuf4cMWXwPuCTD0CXq/i07A34+fzYW+SiqaBpryXa3ZouwEi5Ger2a26eSQAa
         sYyGQdtYiFYYmnEAGSU/bcbXr85Zj6nIOaqP4Z7xQr+nAqy+phyBrMoi6LLBFg2v68
         llt3q9hjNxxNrbwf/xb8+fDAvDmAh1/PB1WLeOM0LdkAWZqMGrP5S3Sf8LCDF2k57r
         KlPlNW5H4Yc8a2nncHxLJXBK1lVT/lbs8YAPsg9Rgw13HHiJzJn1swbJ4lP7LLDgpv
         01GzVx+zjOpncwEZtfXXR50nBsPzbqHGgtVQS9m6kE91nObUGKYSpVA+DGHq5RhW82
         QaEH7LxIGASSw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH RFC 4.9 0/5] Fix booting arm64 big endian with QEMU 5.0.0+
Date:   Fri,  7 Jan 2022 12:43:30 -0700
Message-Id: <20220107194335.3090066-1-nathan@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello everyone,

After upgrading the version of QEMU used in our CI from 4.2.0 to 6.2.0,
I noticed that our 4.9 arm64 big endian builds stopped booting properly.
This is not something that is clang specific, I could reproduce it with
GCC 8.3.0 (the rootfs is at [1]).

$ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- distclean defconfig

$ scripts/config -e CPU_BIG_ENDIAN

$ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig Image.gz

$ qemu-system-aarch64 \
    -initrd rootfs.cpio \
    -append 'console=ttyAMA0 earlycon' \
    -cpu max \
    -machine virt,gic-version=max \
    -machine virtualization=true \
    -display none \
    -kernel arch/arm64/boot/Image.gz \
    -m 512m \
    -nodefaults \
    -serial mon:stdio
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.9.296 (nathan@archlinux-ax161) (gcc version 8.3.0 (Debian 8.3.0-2) ) #1 SMP PREEMPT Fri Jan 7 19:10:49 UTC 2022
...
[    0.773924] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    0.773924]
[    0.776016] CPU: 0 PID: 1 Comm: init Not tainted 4.9.296 #1
[    0.776149] Hardware name: linux,dummy-virt (DT)
[    0.776375] Call trace:
[    0.777063] [<ffff000008088ba0>] dump_backtrace+0x0/0x1b0
[    0.777293] [<ffff000008088d64>] show_stack+0x14/0x20
[    0.777420] [<ffff0000088c2d18>] dump_stack+0x98/0xb8
[    0.777555] [<ffff0000088c0ee8>] panic+0x11c/0x278
[    0.777684] [<ffff0000080c4d20>] do_exit+0x940/0x970
[    0.777816] [<ffff0000080c4db8>] do_group_exit+0x38/0xa0
[    0.777974] [<ffff0000080cf698>] get_signal+0xb8/0x678
[    0.778111] [<ffff000008087ca8>] do_signal+0xd8/0x9b0
[    0.778248] [<ffff0000080888dc>] do_notify_resume+0x8c/0xa8
[    0.778392] [<ffff000008082ff4>] work_pending+0x8/0x10
[    0.778790] Kernel Offset: disabled
[    0.778891] Memory Limit: none
[    0.779241] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

I ended up bisecting QEMU down to cd3f80aba0 ("target/arm: Enable
ARMv8.1-VHE in -cpu max") [2], which did not seem obviously broken. I
noticed that our 4.14 builds were fine so I ended up doing a reverse
bisect down to commit ec347012bbec ("arm64: sysreg: Move to use
definitions for all the SCTLR bits"). Getting that change to apply
cleanly involved applying the three other arm64 patches in this series
and making it build properly required the BUILD_BUG_ON header split
(including bug.h might have been sufficient but I did not want to risk
any further breakage). I searched through mainline to see if there were
any fixes commits that I missed and I did not find any.

I am not sure if this series would be acceptable in 4.9, hence the RFC
tag. If not, I am happy to just spin down our boot tests of arm64 big
endian on 4.9, which is not a super valuable target, but I figured I
would send the series and let others decide!

[1]: https://github.com/ClangBuiltLinux/boot-utils/tree/6cfa15992d375dfb874ca0677abdaebfba4f74e6/images/arm64be
[2]: https://gitlab.com/qemu-project/qemu/-/commit/cd3f80aba0c559a6291f7c3e686422b15381f6b7

Cheers,
Nathan

Ian Abbott (1):
  bug: split BUILD_BUG stuff out into <linux/build_bug.h>

James Morse (1):
  arm64: sysreg: Move to use definitions for all the SCTLR bits

Mark Rutland (2):
  arm64: reduce el2_setup branching
  arm64: move !VHE work to end of el2_setup

Stefan Traby (1):
  arm64: Remove a redundancy in sysreg.h

 arch/arm64/include/asm/sysreg.h | 69 +++++++++++++++++++++++++--
 arch/arm64/kernel/head.S        | 49 ++++++++-----------
 arch/arm64/mm/proc.S            | 24 +---------
 include/linux/bug.h             | 72 +---------------------------
 include/linux/build_bug.h       | 84 +++++++++++++++++++++++++++++++++
 5 files changed, 170 insertions(+), 128 deletions(-)
 create mode 100644 include/linux/build_bug.h


base-commit: 710bf39c7aec32641ea63f6593db1df8c3e4a4d7
-- 
2.34.1

