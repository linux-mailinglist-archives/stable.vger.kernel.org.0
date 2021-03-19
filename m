Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0908341C68
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhCSMUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230467AbhCSMUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A7E264F6A;
        Fri, 19 Mar 2021 12:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156424;
        bh=DQfGTrGsHrSOjZryVNkkHBTc4VnuUJEBb3tRhcFG2yQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Kulvsd+PbrhtAjTsH7f05fBFaCVnXEcXUCLFcnkPrssZ43ukqcWjHJKI2+nUy2XYD
         7DNLu86AptLkm+r2smKHlxtr1581pVMAXy4whfTmVb3idnnzwVJ+IGTRQ+U9QrdMce
         qrqTyOu6KLIXmeqbE8Ne7Xkf/cIF7jgq2cc03QMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/13] 5.10.25-rc1 review
Date:   Fri, 19 Mar 2021 13:18:57 +0100
Message-Id: <20210319121745.112612545@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.25-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.25-rc1
X-KernelTest-Deadline: 2021-03-21T12:17+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.25 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.25-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.25-rc1

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Support setting learning on port

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't avoid stopping the stream at disconnection

J. Bruce Fields <bfields@redhat.com>
    Revert "nfsd4: a client's own opens needn't prevent delegations"

J. Bruce Fields <bfields@redhat.com>
    Revert "nfsd4: remove check_conflicting_opens warning"

Amir Goldstein <amir73il@gmail.com>
    fuse: fix live lock in fuse_iget()

Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>
    RDMA/srp: Fix support for unpopulated and unbalanced NUMA nodes

Piotr Krysiuk <piotras@gmail.com>
    bpf, selftests: Fix up some test_verifier cases for unprivileged

Piotr Krysiuk <piotras@gmail.com>
    bpf: Add sanity check for upper ptr_limit

Piotr Krysiuk <piotras@gmail.com>
    bpf: Simplify alu_limit masking for pointer arithmetic

Piotr Krysiuk <piotras@gmail.com>
    bpf: Fix off-by-one for area size in creating mask to left

Piotr Krysiuk <piotras@gmail.com>
    bpf: Prohibit alu ops for pointer types not defining ptr_limit

Ard Biesheuvel <ardb@kernel.org>
    crypto: x86/aes-ni-xts - use direct calls to and 4-way stride

Uros Bizjak <ubizjak@gmail.com>
    crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/x86/crypto/aesni-intel_asm.S                  | 133 ++++++++++++---------
 arch/x86/crypto/aesni-intel_avx-x86_64.S           |  20 ++--
 arch/x86/crypto/aesni-intel_glue.c                 |  25 ++--
 drivers/infiniband/ulp/srp/ib_srp.c                | 110 +++++++----------
 drivers/net/dsa/b53/b53_common.c                   |  18 +++
 drivers/net/dsa/b53/b53_regs.h                     |   1 +
 drivers/net/dsa/bcm_sf2.c                          |  15 +--
 fs/fuse/fuse_i.h                                   |   1 +
 fs/locks.c                                         |   3 -
 fs/nfsd/nfs4state.c                                |  53 +++-----
 kernel/bpf/verifier.c                              |  33 +++--
 sound/usb/endpoint.c                               |   3 -
 sound/usb/pcm.c                                    |   5 +-
 .../selftests/bpf/verifier/bounds_deduction.c      |  27 +++--
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   4 +
 tools/testing/selftests/bpf/verifier/unpriv.c      |  15 ++-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  23 +++-
 18 files changed, 266 insertions(+), 227 deletions(-)


