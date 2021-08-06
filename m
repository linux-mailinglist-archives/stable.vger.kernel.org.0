Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783753E251C
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhHFIRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243920AbhHFIQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AFDD61181;
        Fri,  6 Aug 2021 08:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237754;
        bh=wJbSi2VrxDSNRrIaBd1ZGQbgwZ637EJiWu087HNO7+k=;
        h=From:To:Cc:Subject:Date:From;
        b=HI7IxOi5Ledz54kC9Dk/lyVRgZtWyXfV1+Mt3I8OjDJV905VdpeiHRYuvUo70PJBi
         lUNlitBWIf7aXka0IUnMlLJBYbuSl+h7fsezxcGybt4YQWEv6irbTOddls+vaY+hfs
         z5cUfXJ8G4GfKF5LP8UOar8fzLkmgDz3Cf6q60ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/11] 4.14.243-rc1 review
Date:   Fri,  6 Aug 2021 10:14:43 +0200
Message-Id: <20210806081110.511221879@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.243-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.243-rc1
X-KernelTest-Deadline: 2021-08-08T08:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.243 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.243-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.243-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"

Sean Christopherson <seanjc@google.com>
    KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()

Nicholas Piggin <npiggin@gmail.com>
    KVM: do not allow mapping valid but non-reference-counted pages

Paolo Bonzini <pbonzini@redhat.com>
    KVM: do not assume PTE is writable after follow_pfn

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "spi: mediatek: fix fifo rx mode"

Pravin B Shelar <pshelar@ovn.org>
    net: Fix zero-copy head len calculation.

Jia He <justin.he@arm.com>
    qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

Takashi Iwai <tiwai@suse.de>
    r8152: Fix potential PM refcount imbalance

Axel Lin <axel.lin@ingics.com>
    regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: mark compressed range uptodate only if all bio succeed


-------------

Diffstat:

 Makefile                                  |  4 ++--
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 23 ++++++++++++++------
 drivers/net/usb/r8152.c                   |  3 ++-
 drivers/spi/spi-mt65xx.c                  | 16 +++-----------
 drivers/watchdog/iTCO_wdt.c               | 12 +++--------
 fs/btrfs/compression.c                    |  2 +-
 include/linux/mfd/rt5033-private.h        |  4 ++--
 net/bluetooth/hci_core.c                  | 16 +++++++-------
 net/core/skbuff.c                         |  5 ++++-
 virt/kvm/kvm_main.c                       | 36 +++++++++++++++++++++++++------
 10 files changed, 72 insertions(+), 49 deletions(-)


