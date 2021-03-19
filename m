Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D71341C1C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhCSMTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhCSMSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:18:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC3E64F6B;
        Fri, 19 Mar 2021 12:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156313;
        bh=lThyQ9QYgd9MZQVa9dAL+2MTC4LQveUHougX4A+Vf3U=;
        h=From:To:Cc:Subject:Date:From;
        b=pGIVxUA0F+zz5eokJmhyWxCRsg1nXED90ItuHhiXprn4nFclZwlAqfBG7LZjOZu6k
         FmkcRby3XitkM5DUGUSgbnBSN9MqPWFWBAlJKHXe7ZN1Xv44K6iLKMOKeiMxwvyDcO
         uKZ133M1IB7tCAF6bEyPEg+V7iYrJynrfvDWbrCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 0/8] 4.19.182-rc1 review
Date:   Fri, 19 Mar 2021 13:18:19 +0100
Message-Id: <20210319121744.114946147@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.182-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.182-rc1
X-KernelTest-Deadline: 2021-03-21T12:17+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.182 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.182-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.182-rc1

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Support setting learning on port

DENG Qingfang <dqfext@gmail.com>
    net: dsa: tag_mtk: fix 802.1ad VLAN egress

Piotr Krysiuk <piotras@gmail.com>
    bpf: Add sanity check for upper ptr_limit

Piotr Krysiuk <piotras@gmail.com>
    bpf: Simplify alu_limit masking for pointer arithmetic

Piotr Krysiuk <piotras@gmail.com>
    bpf: Fix off-by-one for area size in creating mask to left

Piotr Krysiuk <piotras@gmail.com>
    bpf: Prohibit alu ops for pointer types not defining ptr_limit

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: nvhe: Save the SPE context early

Jan Kara <jack@suse.cz>
    ext4: check journal inode extents more carefully


-------------

Diffstat:

 Makefile                         |  4 ++--
 arch/arm64/include/asm/kvm_hyp.h |  3 +++
 arch/arm64/kvm/hyp/debug-sr.c    | 24 +++++++++++++---------
 arch/arm64/kvm/hyp/switch.c      |  4 +++-
 drivers/net/dsa/b53/b53_common.c | 19 ++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        |  5 -----
 fs/ext4/block_validity.c         | 43 ++++++++++++++++++++--------------------
 fs/ext4/ext4.h                   |  6 +++---
 fs/ext4/extents.c                | 16 ++++++---------
 fs/ext4/indirect.c               |  6 ++----
 fs/ext4/inode.c                  |  5 ++---
 fs/ext4/mballoc.c                |  4 ++--
 kernel/bpf/verifier.c            | 33 +++++++++++++++++++-----------
 net/dsa/tag_mtk.c                | 19 ++++++++++++------
 15 files changed, 114 insertions(+), 78 deletions(-)


