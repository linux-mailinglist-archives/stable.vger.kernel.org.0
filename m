Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19543A2A53
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 13:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFJLhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 07:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhFJLhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 947A861406;
        Thu, 10 Jun 2021 11:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623324913;
        bh=x8Lvi+syrDzfNfPwKUxJtlx51oE4l0Z62zQnIy9Gt0U=;
        h=From:To:Cc:Subject:Date:From;
        b=OCJzc3tME1+R0ZVhh2sWWdG9aWaD/1O3Bd/zbdbk/fTvmy2cNHnq+Lu9ElirnazE+
         1SNNL/5UMZtH/JnktblTzD9R8y9V/Ljc2DHNOWzb1DUditHVnSJ+RGAXLA0Sytieh6
         R6gRmMG1WiYmXoekB3BMKty8/twEMCsE96mjfamA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.236
Date:   Thu, 10 Jun 2021 13:35:06 +0200
Message-Id: <162332490712962@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.236 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 
 arch/x86/kvm/svm.c                           |    8 
 drivers/firmware/efi/cper.c                  |    4 
 drivers/firmware/efi/memattr.c               |    5 
 drivers/hid/i2c-hid/i2c-hid-core.c           |    4 
 drivers/hid/usbhid/hid-pidff.c               |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |    1 
 drivers/net/usb/cdc_ncm.c                    |   12 
 drivers/vfio/pci/Kconfig                     |    1 
 drivers/vfio/pci/vfio_pci_config.c           |    2 
 drivers/vfio/platform/vfio_platform_common.c |    2 
 drivers/xen/xen-pciback/vpci.c               |   14 -
 fs/btrfs/file-item.c                         |   10 
 fs/btrfs/tree-log.c                          |   13 
 fs/ext4/extents.c                            |   43 +--
 fs/ocfs2/file.c                              |   55 +++-
 include/linux/bpf_verifier.h                 |    5 
 include/linux/usb/usbnet.h                   |    2 
 include/net/caif/caif_dev.h                  |    2 
 include/net/caif/cfcnfg.h                    |    2 
 include/net/caif/cfserl.h                    |    1 
 init/main.c                                  |    2 
 kernel/bpf/verifier.c                        |  369 ++++++++++++++++-----------
 kernel/sched/fair.c                          |    7 
 mm/hugetlb.c                                 |   14 -
 net/bluetooth/hci_core.c                     |    7 
 net/bluetooth/hci_sock.c                     |    4 
 net/caif/caif_dev.c                          |   13 
 net/caif/caif_usb.c                          |   14 -
 net/caif/cfcnfg.c                            |   16 -
 net/caif/cfserl.c                            |    5 
 net/ieee802154/nl-mac.c                      |    4 
 net/ieee802154/nl-phy.c                      |    4 
 net/netfilter/ipvs/ip_vs_ctl.c               |    2 
 net/netfilter/nfnetlink_cthelper.c           |    8 
 net/nfc/llcp_sock.c                          |    2 
 sound/core/timer.c                           |    3 
 tools/testing/selftests/bpf/test_align.c     |   26 -
 tools/testing/selftests/bpf/test_verifier.c  |  114 ++++----
 39 files changed, 500 insertions(+), 303 deletions(-)

Alexei Starovoitov (4):
      bpf: do not allow root to mangle valid pointers
      bpf/verifier: disallow pointer subtraction
      selftests/bpf: fix test_align
      selftests/bpf: make 'dubious pointer arithmetic' test useful

Arnd Bergmann (1):
      HID: i2c-hid: fix format string mismatch

Cheng Jian (1):
      sched/fair: Optimize select_idle_cpu

Daniel Borkmann (12):
      bpf: Move off_reg into sanitize_ptr_alu
      bpf: Ensure off_reg has no mixed signed bounds for all types
      bpf: Rework ptr_limit into alu_limit and add common error path
      bpf: Improve verifier error messages for users
      bpf: Refactor and streamline bounds check into helper
      bpf: Move sanitize_val_alu out of op switch
      bpf: Tighten speculative pointer arithmetic mask
      bpf: Update selftests to reflect new error states
      bpf: Fix leakage of uninitialized bpf stack under speculation
      bpf: Wrap aux data inside bpf_sanitize_info container
      bpf: Fix mask direction swap upon off reg sign change
      bpf: No need to simulate speculative domain for immediates

Grant Grundler (1):
      net: usb: cdc_ncm: don't spew notifications

Greg Kroah-Hartman (1):
      Linux 4.14.236

Heiner Kallweit (1):
      efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared

Jan Beulich (1):
      xen-pciback: redo VF placement in the virtual topology

Josef Bacik (2):
      btrfs: fix error handling in btrfs_del_csums
      btrfs: fixup error handling in fixup_inode_link_counts

Julian Anastasov (1):
      ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Junxiao Bi (1):
      ocfs2: fix data corruption by fallocate

Krzysztof Kozlowski (1):
      nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

Lin Ma (2):
      Bluetooth: fix the erroneous flush_work() order
      Bluetooth: use correct lock to prevent UAF of hdev object

Mark Rutland (1):
      pid: take a reference when initializing `cad_pid`

Max Gurtovoy (1):
      vfio/platform: fix module_put call in error flow

Michael Chan (1):
      bnxt_en: Remove the setting of dev_port.

Mina Almasry (1):
      mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

Pavel Skripkin (4):
      net: caif: added cfserl_release function
      net: caif: add proper error handling
      net: caif: fix memory leak in caif_device_notify
      net: caif: fix memory leak in cfusbl_device_notify

Piotr Krysiuk (1):
      bpf, selftests: Fix up some test_verifier cases for unprivileged

Randy Dunlap (1):
      vfio/pci: zap_vma_ptes() needs MMU

Rasmus Villemoes (1):
      efi: cper: fix snprintf() use in cper_dimm_err_location()

Sean Christopherson (1):
      KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode

Takashi Iwai (1):
      ALSA: timer: Fix master timer notification

Wei Yongjun (1):
      ieee802154: fix error return code in ieee802154_llsec_getparams()

Ye Bin (1):
      ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed

Zhen Lei (3):
      vfio/pci: Fix error return code in vfio_ecap_init()
      HID: pidff: fix error return code in hid_pidff_init()
      ieee802154: fix error return code in ieee802154_add_iface()

