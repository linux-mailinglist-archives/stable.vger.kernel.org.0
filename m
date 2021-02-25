Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871A3324D4C
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbhBYJzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233225AbhBYJye (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:54:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EBE664EC8;
        Thu, 25 Feb 2021 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246833;
        bh=OX/hx33raozbkOYsqSXGp3xlkbyLCX4fQzhOoXEFnmg=;
        h=From:To:Cc:Subject:Date:From;
        b=bqpUDEaKx39A5I3LIvU98hz0R+bsbSL8NFp6C8w7ncq9G02ONOj4T8ghfJZhQuxhL
         BWxXyktmnN/3Vv30OnV+1tkJ+ddwT7AL0MlRyeVrlat3Z7BGYaDa5kbSl6yAA9cG9G
         6aRRMt2c126V6ukP42r12lu6SK2CNYOseF6O0atE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 00/12] 5.11.2-rc1 review
Date:   Thu, 25 Feb 2021 10:53:34 +0100
Message-Id: <20210225092515.015261674@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.11.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.2-rc1
X-KernelTest-Deadline: 2021-02-27T09:25+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.2 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.2-rc1

Sean Christopherson <seanjc@google.com>
    KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()

Paolo Bonzini <pbonzini@redhat.com>
    mm: provide a saner PTE walking API for modules

Paolo Bonzini <pbonzini@redhat.com>
    KVM: do not assume PTE is writable after follow_pfn

Sean Christopherson <seanjc@google.com>
    KVM: x86: Zap the oldest MMU pages, not the newest

Thomas Hebb <tommyhebb@gmail.com>
    hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist

Sameer Pujar <spujar@nvidia.com>
    arm64: tegra: Add power-domain for Tegra210 HDA

Hui Wang <hui.wang@canonical.com>
    Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working

Rustam Kovhaev <rkovhaev@gmail.com>
    ntfs: check for valid standard information attribute

Stefan Ursella <stefan.ursella@wolfvision.net>
    usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Johan Hovold <johan@kernel.org>
    USB: quirks: sort quirk entries

Will McVicker <willmcvicker@google.com>
    HID: make arrays usage and value to be the same

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix truncation handling for mod32 dst reg wrt zero


-------------

Diffstat:

 Makefile                                 |  4 ++--
 arch/arm64/boot/dts/nvidia/tegra210.dtsi |  1 +
 arch/s390/pci/pci_mmio.c                 |  4 ++--
 arch/x86/kvm/mmu/mmu.c                   |  2 +-
 drivers/bluetooth/btusb.c                |  7 ++++++
 drivers/hid/hid-core.c                   |  6 ++---
 drivers/hwmon/dell-smm-hwmon.c           |  7 ++++++
 drivers/usb/core/quirks.c                |  9 ++++---
 fs/dax.c                                 |  5 ++--
 fs/ntfs/inode.c                          |  6 +++++
 include/linux/mm.h                       |  6 +++--
 kernel/bpf/verifier.c                    | 10 ++++----
 mm/memory.c                              | 41 ++++++++++++++++++++++++++++----
 virt/kvm/kvm_main.c                      | 17 +++++++++----
 14 files changed, 97 insertions(+), 28 deletions(-)


