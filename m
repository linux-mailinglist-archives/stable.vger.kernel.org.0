Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247732A1DB9
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 13:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgKAMDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 07:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgKAMDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 07:03:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C562084C;
        Sun,  1 Nov 2020 12:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604232220;
        bh=pihvkuKI0VuAbV2qANT1EA4HPIdmQHdPAXeJvRczIPs=;
        h=From:To:Cc:Subject:Date:From;
        b=f4Glf1uUnPXGWWof5xgmcJ9pc3a30sg+Wo9SUzQ9X5eKkgtbLy8YDV4lWur8kwVxl
         sEhu/CoJ8XLxpILsnstViWBe36l5TvRV0jaDQKnQjdzz+Eswhyff302S6ZUTpjWzZy
         W57T0JWW0JgkhH1AruV3oGIGXKuMQL5ZmlRqW9i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.18
Date:   Sun,  1 Nov 2020 13:04:22 +0100
Message-Id: <16042322186122@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.18 kernel.

All users of the 5.8 kernel series must upgrade.

NOTE, this is the LAST 5.8.y release to be made, this branch is now
end-of-life.  Please move to the 5.9.y kernel branch at this point in
time.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arm64/Makefile                                       |    4 
 arch/arm64/kernel/cpu_errata.c                            |   15 
 arch/openrisc/include/asm/uaccess.h                       |   35 -
 arch/powerpc/Kconfig                                      |    2 
 arch/powerpc/include/asm/string.h                         |    2 
 arch/powerpc/include/asm/uaccess.h                        |   40 -
 arch/powerpc/lib/Makefile                                 |    2 
 arch/powerpc/lib/copy_mc_64.S                             |  242 +++++++
 arch/powerpc/lib/memcpy_mcsafe_64.S                       |  242 -------
 arch/x86/Kconfig                                          |    2 
 arch/x86/Kconfig.debug                                    |    2 
 arch/x86/events/amd/ibs.c                                 |   15 
 arch/x86/include/asm/copy_mc_test.h                       |   75 ++
 arch/x86/include/asm/mce.h                                |    9 
 arch/x86/include/asm/mcsafe_test.h                        |   75 --
 arch/x86/include/asm/string_64.h                          |   32 
 arch/x86/include/asm/uaccess.h                            |    9 
 arch/x86/include/asm/uaccess_64.h                         |   20 
 arch/x86/kernel/cpu/mce/core.c                            |    8 
 arch/x86/kernel/quirks.c                                  |   10 
 arch/x86/kernel/traps.c                                   |    2 
 arch/x86/lib/Makefile                                     |    1 
 arch/x86/lib/copy_mc.c                                    |   96 ++
 arch/x86/lib/copy_mc_64.S                                 |  163 ++++
 arch/x86/lib/memcpy_64.S                                  |  115 ---
 arch/x86/lib/usercopy_64.c                                |   21 
 arch/x86/pci/intel_mid_pci.c                              |    1 
 arch/x86/xen/enlighten_pv.c                               |    9 
 drivers/ata/ahci.h                                        |    2 
 drivers/ata/ahci_mvebu.c                                  |    2 
 drivers/ata/libahci_platform.c                            |    2 
 drivers/ata/sata_rcar.c                                   |    2 
 drivers/base/firmware_loader/fallback_platform.c          |    2 
 drivers/crypto/chelsio/chtls/chtls_cm.c                   |   29 
 drivers/crypto/chelsio/chtls/chtls_io.c                   |    7 
 drivers/firmware/efi/libstub/arm64-stub.c                 |    8 
 drivers/firmware/efi/libstub/fdt.c                        |    4 
 drivers/gpu/drm/i915/i915_debugfs.c                       |    2 
 drivers/infiniband/core/addr.c                            |   11 
 drivers/md/dm-writecache.c                                |   15 
 drivers/misc/cardreader/rtsx_pcr.c                        |    4 
 drivers/misc/cxl/pci.c                                    |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 |   49 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                 |    1 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c         |   56 -
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h               |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    2 
 drivers/net/ethernet/ibm/ibmveth.c                        |    6 
 drivers/net/ethernet/ibm/ibmvnic.c                        |    8 
 drivers/net/ethernet/mellanox/mlxsw/core.c                |    2 
 drivers/net/ethernet/realtek/r8169_main.c                 |    4 
 drivers/net/ethernet/renesas/ravb_main.c                  |   10 
 drivers/net/gtp.c                                         |   16 
 drivers/net/ipa/gsi_trans.c                               |   21 
 drivers/net/wireless/intersil/p54/p54pci.c                |    4 
 drivers/nvdimm/claim.c                                    |    2 
 drivers/nvdimm/pmem.c                                     |    6 
 drivers/pci/controller/pci-aardvark.c                     |    4 
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c              |   14 
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c              |   14 
 drivers/tty/serial/amba-pl011.c                           |   11 
 drivers/tty/serial/qcom_geni_serial.c                     |    2 
 drivers/xen/gntdev.c                                      |   17 
 fs/efivarfs/super.c                                       |    3 
 fs/erofs/xattr.c                                          |    2 
 fs/exec.c                                                 |    6 
 fs/file.c                                                 |    2 
 fs/fuse/dev.c                                             |   28 
 fs/io-wq.c                                                |  172 ++---
 fs/io-wq.h                                                |    1 
 fs/io_uring.c                                             |  475 ++++++++++----
 include/linux/fs.h                                        |    1 
 include/linux/io_uring.h                                  |   53 +
 include/linux/mtd/pfow.h                                  |    2 
 include/linux/pm.h                                        |    2 
 include/linux/qcom-geni-se.h                              |    3 
 include/linux/sched.h                                     |    5 
 include/linux/string.h                                    |    9 
 include/linux/uaccess.h                                   |   13 
 include/linux/uio.h                                       |   10 
 include/net/netfilter/nf_tables.h                         |    6 
 include/uapi/linux/bpf.h                                  |    4 
 init/init_task.c                                          |    3 
 kernel/fork.c                                             |    6 
 lib/Kconfig                                               |    7 
 lib/iov_iter.c                                            |   48 -
 net/ipv4/tcp.c                                            |    2 
 net/ipv4/tcp_input.c                                      |    3 
 net/netfilter/nf_tables_api.c                             |    6 
 net/netfilter/nf_tables_offload.c                         |    4 
 net/sched/act_mpls.c                                      |    1 
 net/sched/cls_api.c                                       |    4 
 net/sched/sch_netem.c                                     |    9 
 net/tipc/msg.c                                            |    5 
 scripts/setlocalversion                                   |   21 
 security/integrity/evm/evm_main.c                         |    6 
 tools/arch/x86/include/asm/mcsafe_test.h                  |   13 
 tools/arch/x86/lib/memcpy_64.S                            |  115 ---
 tools/include/uapi/linux/bpf.h                            |    4 
 tools/objtool/check.c                                     |    5 
 tools/perf/bench/Build                                    |    1 
 tools/perf/bench/mem-memcpy-x86-64-lib.c                  |   24 
 tools/testing/nvdimm/test/nfit.c                          |   49 -
 tools/testing/selftests/powerpc/copyloops/.gitignore      |    2 
 tools/testing/selftests/powerpc/copyloops/Makefile        |    6 
 tools/testing/selftests/powerpc/copyloops/copy_mc_64.S    |  242 +++++++
 107 files changed, 1834 insertions(+), 1147 deletions(-)

Aleksandr Nogikh (1):
      netem: fix zero division in tabledist

Alex Elder (1):
      net: ipa: command payloads already mapped

Andrew Gabbasov (1):
      ravb: Fix bit fields checking in ravb_hwtstamp_get()

Ard Biesheuvel (1):
      efi/arm64: libstub: Deal gracefully with EFI_RNG_PROTOCOL failure

Arjun Roy (1):
      tcp: Prevent low rmem stalls with SO_RCVLOWAT.

Chris Wilson (1):
      drm/i915/gem: Serialise debugfs i915_gem_objects with ctx->mutex

Dan Williams (2):
      x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()
      x86/copy_mc: Introduce copy_mc_enhanced_fast_string()

Frederic Barrat (1):
      cxl: Rework error message for incompatible slots

Gao Xiang (1):
      erofs: avoid duplicated permission check for "trusted." xattrs

Geert Uytterhoeven (1):
      ata: sata_rcar: Fix DMA boundary mask

Greg Kroah-Hartman (1):
      Linux 5.8.18

Grygorii Strashko (1):
      PM: runtime: Fix timer_expires data type on 32-bit arches

Guillaume Nault (1):
      net/sched: act_mpls: Add softdep on mpls_gso.ko

Gustavo A. R. Silva (1):
      mtd: lpddr: Fix bad logic in print_drs_error

Heiner Kallweit (1):
      r8169: fix issue with forced threading in combination with shared interrupts

Hillf Danton (1):
      io-wq: fix use-after-free in io_wq_worker_running

Ido Schimmel (1):
      mlxsw: core: Fix memory leak on module removal

Jason Gunthorpe (1):
      RDMA/addr: Fix race with netevent_callback()/rdma_addr_cancel()

Jens Axboe (10):
      io_uring: don't run task work on an exiting task
      io_uring: allow timeout/poll/files killing to take task into account
      io_uring: move dropping of files into separate helper
      io_uring: stash ctx task reference for SQPOLL
      io_uring: unconditionally grab req->task
      io_uring: return cancelation status from poll/timeout/files handlers
      io_uring: enable task/files specific overflow flushing
      io_uring: don't rely on weak ->files references
      io_uring: reference ->nsproxy for file table commands
      io_uring: no need to call xa_destroy() on empty xarray

Jia-Ju Bai (1):
      p54: avoid accessing the data mapped to streaming DMA

Juergen Gross (1):
      x86/xen: disable Firmware First mode for correctable memory errors

Kees Cook (1):
      fs/kernel_read_file: Remove FIRMWARE_EFI_EMBEDDED enum

Kim Phillips (1):
      arch/x86/amd/ibs: Fix re-arming IBS Fetch

Leon Romanovsky (1):
      net: protect tcf_block_unbind with block lock

Lijun Pan (1):
      ibmvnic: fix ibmvnic_set_mac

Marc Zyngier (2):
      arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs
      arm64: Run ARCH_WORKAROUND_2 enabling code on all CPUs

Masahiro Fujiwara (1):
      gtp: fix an use-before-init in gtp_newlink()

Matthew Wilcox (Oracle) (3):
      io_uring: Fix use of XArray in __io_uring_files_cancel
      io_uring: Fix XArray usage in io_uring_add_task_file
      io_uring: Convert advanced XArray uses to the normal API

Michael Chan (1):
      bnxt_en: Check abort error state in bnxt_open_nic().

Michael Schaller (1):
      efivarfs: Replace invalid slashes with exclamation marks in dentries.

Miklos Szeredi (1):
      fuse: fix page dereference after free

Nick Desaulniers (1):
      arm64: link with -z norelro regardless of CONFIG_RELOCATABLE

Pali Rohár (3):
      PCI: aardvark: Fix initialization with old Marvell's Arm Trusted Firmware
      ata: ahci: mvebu: Make SATA PHY optional for Armada 3720
      phy: marvell: comphy: Convert internal SMCC firmware return codes to errno

Paras Sharma (1):
      serial: qcom_geni_serial: To correct QUP Version detection logic

Peter Zijlstra (1):
      serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt

Raju Rangoju (1):
      cxgb4: set up filter action after rewrites

Randy Dunlap (1):
      x86/PCI: Fix intel_mid_pci.c build error when ACPI is not enabled

Rasmus Villemoes (1):
      scripts/setlocalversion: make git describe output more reliable

Ricky Wu (1):
      misc: rtsx: do not setting OC_POWER_DOWN reg in rtsx_pci_init_ocp()

Roberto Sassu (1):
      evm: Check size of security.evm before using it

Saeed Mirzamohammadi (1):
      netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create

Sebastian Andrzej Siewior (1):
      io_wq: Make io_wqe::lock a raw_spinlock_t

Song Liu (1):
      bpf: Fix comment for helper bpf_current_task_under_cgroup()

Souptick Joarder (1):
      xen/gntdev.c: Mark pages as dirty

Stafford Horne (1):
      openrisc: Fix issue with get_user for 64-bit values

Thomas Bogendoerfer (1):
      ibmveth: Fix use of ibmveth in a bridge.

Thomas Gleixner (1):
      x86/traps: Fix #DE Oops message regression

Tung Nguyen (1):
      tipc: fix memory leak caused by tipc_buf_append()

Vasundhara Volam (4):
      bnxt_en: Fix regression in workqueue cleanup logic in bnxt_remove_one().
      bnxt_en: Invoke cancel_delayed_work_sync() for PFs also.
      bnxt_en: Re-write PCI BARs after PCI fatal error.
      bnxt_en: Send HWRM_FUNC_RESET fw command unconditionally.

Vinay Kumar Yadav (3):
      chelsio/chtls: fix deadlock issue
      chelsio/chtls: fix memory leaks in CPL handlers
      chelsio/chtls: fix tls record info to user

Zenghui Yu (1):
      net: hns3: Clear the CMDQ registers before unmapping BAR region

