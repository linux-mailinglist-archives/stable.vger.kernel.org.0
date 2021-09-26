Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBD84188D9
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbhIZMwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231673AbhIZMwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ACC060FC2;
        Sun, 26 Sep 2021 12:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632660624;
        bh=hGAVSD5X5H+S2l/cFAII9psgohoE7SA/nnRRg66I8AI=;
        h=From:To:Cc:Subject:Date:From;
        b=ewAVBcxyFJeoDeHMQDTZFVLSTpbcyEkihqoBYbmbQTc+7NKYvHqPOazMeN9Nuh/9T
         u3ySmEDO4MWPymt/xlC1e3K1AnT3432LdoDixwSm40M/5gBNuBNVuo/nBzTgJ/0uSh
         g2ohvQYGOlBX3O14yrw3rF2v883xAyErbM8O6qi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.8
Date:   Sun, 26 Sep 2021 14:50:05 +0200
Message-Id: <1632660605165200@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.8 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/driver-api/cxl/memory-devices.rst             |    2 
 Makefile                                                    |    2 
 arch/arm64/kernel/cacheinfo.c                               |    7 
 arch/arm64/mm/init.c                                        |   16 
 arch/mips/kernel/cacheinfo.c                                |    7 
 arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts |    6 
 arch/riscv/kernel/cacheinfo.c                               |    7 
 arch/s390/include/asm/stacktrace.h                          |   20 
 arch/s390/include/asm/unwind.h                              |    8 
 arch/s390/kernel/entry.S                                    |    4 
 arch/s390/kernel/setup.c                                    |   10 
 arch/um/drivers/virtio_uml.c                                |    4 
 arch/um/kernel/skas/clone.c                                 |    3 
 arch/x86/kernel/cpu/cacheinfo.c                             |    7 
 arch/x86/um/shared/sysdep/stub_32.h                         |   12 
 arch/x86/um/shared/sysdep/stub_64.h                         |   12 
 arch/x86/um/stub_segv.c                                     |    3 
 block/blk-mq.c                                              |   14 
 block/blk-throttle.c                                        |    1 
 block/genhd.c                                               |    9 
 drivers/acpi/x86/s2idle.c                                   |   67 
 drivers/base/power/main.c                                   |    2 
 drivers/block/n64cart.c                                     |    4 
 drivers/cxl/Makefile                                        |    4 
 drivers/cxl/core.c                                          | 1067 ------------
 drivers/cxl/core/Makefile                                   |    5 
 drivers/cxl/core/bus.c                                      | 1067 ++++++++++++
 drivers/cxl/cxlmem.h                                        |   96 +
 drivers/cxl/mem.h                                           |   81 
 drivers/cxl/pci.c                                           |   67 
 drivers/cxl/pmem.c                                          |    2 
 drivers/dma-buf/Kconfig                                     |    2 
 drivers/dma/Kconfig                                         |    4 
 drivers/dma/acpi-dma.c                                      |   10 
 drivers/dma/idxd/device.c                                   |   98 -
 drivers/dma/idxd/idxd.h                                     |    6 
 drivers/dma/idxd/irq.c                                      |   16 
 drivers/dma/idxd/submit.c                                   |    2 
 drivers/dma/idxd/sysfs.c                                    |   22 
 drivers/dma/sprd-dma.c                                      |    1 
 drivers/dma/xilinx/xilinx_dma.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c            |   50 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fdinfo.c                  |   11 
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c     |    6 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c         |   17 
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c           |    2 
 drivers/gpu/drm/ttm/ttm_bo.c                                |    6 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                  |    1 
 drivers/infiniband/hw/mlx5/mr.c                             |    2 
 drivers/iommu/amd/init.c                                    |   31 
 drivers/iommu/intel/svm.c                                   |   15 
 drivers/misc/habanalabs/common/command_buffer.c             |    2 
 drivers/misc/habanalabs/common/debugfs.c                    |    2 
 drivers/misc/habanalabs/common/device.c                     |    3 
 drivers/misc/habanalabs/common/habanalabs.h                 |    2 
 drivers/misc/habanalabs/common/habanalabs_drv.c             |    8 
 drivers/misc/habanalabs/common/memory.c                     |    2 
 drivers/misc/habanalabs/common/mmu/mmu_v1.c                 |   12 
 drivers/misc/habanalabs/common/sysfs.c                      |   20 
 drivers/misc/habanalabs/gaudi/gaudi.c                       |    6 
 drivers/misc/habanalabs/goya/goya.c                         |    6 
 drivers/nvme/target/configfs.c                              |    3 
 drivers/of/property.c                                       |    3 
 drivers/parisc/dino.c                                       |   18 
 drivers/pci/controller/pci-aardvark.c                       |   67 
 drivers/pci/pci-bridge-emul.h                               |    2 
 drivers/platform/chrome/Makefile                            |    2 
 drivers/platform/chrome/cros_ec_sensorhub_ring.c            |   14 
 drivers/platform/chrome/cros_ec_trace.h                     |   94 +
 drivers/pwm/pwm-ab8500.c                                    |   17 
 drivers/pwm/pwm-img.c                                       |   16 
 drivers/pwm/pwm-lpc32xx.c                                   |   10 
 drivers/pwm/pwm-mxs.c                                       |   13 
 drivers/pwm/pwm-rockchip.c                                  |   14 
 drivers/pwm/pwm-stm32-lp.c                                  |    2 
 drivers/rtc/Kconfig                                         |    1 
 drivers/staging/rtl8192u/r8192U_core.c                      |    2 
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c              |    6 
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c                    |    6 
 drivers/thermal/rcar_gen3_thermal.c                         |    7 
 drivers/thermal/samsung/exynos_tmu.c                        |    1 
 drivers/tty/vt/vt.c                                         |   31 
 fs/btrfs/ioctl.c                                            |   15 
 fs/btrfs/volumes.c                                          |   48 
 fs/btrfs/volumes.h                                          |    3 
 fs/ceph/caps.c                                              |   75 
 fs/ceph/file.c                                              |   32 
 fs/ceph/mds_client.c                                        |   32 
 fs/ceph/metric.c                                            |    4 
 fs/ceph/super.h                                             |    6 
 fs/cifs/smb2ops.c                                           |   20 
 fs/coredump.c                                               |    4 
 fs/io_uring.c                                               |    2 
 fs/nilfs2/sysfs.c                                           |   26 
 fs/nilfs2/the_nilfs.c                                       |    9 
 include/linux/cacheinfo.h                                   |   18 
 include/linux/thermal.h                                     |    5 
 include/uapi/misc/habanalabs.h                              |    4 
 init/initramfs.c                                            |    2 
 init/main.c                                                 |    1 
 init/noinitramfs.c                                          |    2 
 kernel/profile.c                                            |   21 
 kernel/sched/idle.c                                         |    4 
 kernel/sys.c                                                |    7 
 kernel/trace/trace_boot.c                                   |    6 
 lib/Kconfig.debug                                           |    4 
 net/9p/trans_virtio.c                                       |    4 
 net/sunrpc/svc_xprt.c                                       |   13 
 security/selinux/hooks.c                                    |    4 
 security/smack/smack_lsm.c                                  |    4 
 sound/soc/generic/audio-graph-card.c                        |    6 
 tools/bootconfig/scripts/ftrace2bconf.sh                    |    4 
 tools/perf/tests/bpf.c                                      |    2 
 tools/perf/util/dso.c                                       |   10 
 tools/perf/util/symbol.c                                    |   20 
 115 files changed, 2117 insertions(+), 1612 deletions(-)

Anand Jain (1):
      btrfs: fix lockdep warning while mounting sprout fs

Andy Shevchenko (1):
      dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Anson Jacob (1):
      drm/amd/display: Fix memory leak reported by coverity

Ard Biesheuvel (1):
      arm64: mm: limit linear region to 51 bits for KVM in nVHE mode

Arnd Bergmann (1):
      thermal/core: Fix thermal_cooling_device_register() prototype

Ben Widawsky (1):
      cxl: Move cxl_core to new directory

Cyrill Gorcunov (1):
      prctl: allow to setup brk for et_dyn executables

Dan Carpenter (1):
      thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()

Dan Williams (1):
      cxl/pci: Introduce cdevm_file_operations

Dave Jiang (5):
      dmanegine: idxd: cleanup all device related bits after disabling device
      dmaengine: idxd: have command status always set
      dmaengine: idxd: fix wq slot allocation index check
      dmaengine: idxd: fix abort status check
      dmaengine: idxd: clear block on fault flag when clear wq

Enzo Matsumiya (1):
      cifs: properly invalidate cached root handle when closing it

Fabio Aiuto (1):
      staging: rtl8723bs: fix wpa_set_auth_algs() function

Fenghua Yu (2):
      iommu/vt-d: Fix PASID leak in intel_svm_unbind_mm()
      iommu/vt-d: Fix a deadlock in intel_svm_drain_prq()

Geert Uytterhoeven (4):
      math: RATIONAL_KUNIT_TEST should depend on RATIONAL instead of selecting it
      dma-buf: DMABUF_MOVE_NOTIFY should depend on DMA_SHARED_BUFFER
      dma-buf: DMABUF_DEBUG should depend on DMA_SHARED_BUFFER
      riscv: dts: microchip: mpfs-icicle: Fix serial console

Greg Kroah-Hartman (1):
      Linux 5.14.8

Guenter Roeck (2):
      parisc: Move pci_dev_is_behind_card_dino to where it is used
      drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Gwendal Grignou (2):
      platform/chrome: sensorhub: Add trace events for sample
      platform/chrome: cros_ec_trace: Fix format warnings

Hannes Reinecke (1):
      nvmet: fixup buffer overrun in nvmet_subsys_attr_serial()

Hao Xu (1):
      io_uring: fix off-by-one in BUILD_BUG_ON check of __REQ_F_LAST_BIT

Heiko Carstens (1):
      s390/entry: make oklabel within CHKSTG macro local

Jeff Layton (4):
      ceph: cancel delayed work instead of flushing on mdsc teardown
      ceph: fix memory leak on decode error in ceph_handle_caps
      ceph: request Fw caps before updating the mtime in ceph_write_iter
      ceph: lockdep annotations for try_nonblocking_invalidate

Johannes Berg (4):
      um: fix stub location calculation
      um: virtio_uml: fix memory leak on init failures
      dmaengine: idxd: depends on !UML
      dmaengine: ioat: depends on !UML

Josef Bacik (2):
      btrfs: update the bdev time directly when closing
      btrfs: delay blkdev_put until after the device remove

Koba Ko (1):
      drm/amdgpu: Disable PCIE_DPM on Intel RKL Platform

Kuninori Morimoto (1):
      ASoC: audio-graph: respawn Platform Support

Li Jinlin (1):
      blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Luben Tuikov (1):
      drm/amdgpu: Fixes to returning VBIOS RAS EEPROM address

Lukas Bulwahn (1):
      Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Mario Limonciello (1):
      ACPI: PM: s2idle: Run both AMD and Microsoft methods if both are supported

Masami Hiramatsu (2):
      tools/bootconfig: Fix tracing_on option checking in ftrace2bconf.sh
      tracing/boot: Fix to loop on only subkeys

Matthias Kaehlcke (1):
      thermal/drivers/qcom/spmi-adc-tm5: Don't abort probing if a sensor is not used

Michael Petlan (1):
      perf test: Fix bpf test sample mismatch reporting

Namhyung Kim (1):
      perf tools: Allow build-id with trailing zeros

Nanyong Sun (6):
      nilfs2: fix memory leak in nilfs_sysfs_create_device_group
      nilfs2: fix NULL pointer in nilfs_##name##_attr_release
      nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
      nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
      nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

Nathan Chancellor (1):
      staging: rtl8192u: Fix bitwise vs logical operator in TranslateRxSignalStuff819xUsb()

NeilBrown (1):
      SUNRPC: don't pause on incomplete allocation

Niklas Schnelle (1):
      RDMA/mlx5: Fix xlt_chunk_align calculation

Niklas Söderlund (1):
      thermal/drivers/rcar_gen3_thermal: Store TSC id as unsigned int

Ofir Bitton (1):
      habanalabs: add validity check for event ID received from F/W

Omer Shpigelman (1):
      habanalabs: add "in device creation" status

Pali Rohár (2):
      PCI: pci-bridge-emul: Add PCIe Root Capabilities Register
      PCI: aardvark: Fix reporting CRS value

Paul Moore (1):
      selinux,smack: fix subjective/objective credential use mixups

Pavel Skripkin (1):
      profiling: fix shift-out-of-bounds bugs

Philip Yang (1):
      drm/amdgpu: fix fdinfo race with process exit

Prasad Sodagudi (1):
      PM: sleep: core: Avoid setting power.must_resume to false

QiuXi (1):
      coredump: fix memleak in dump_vma_snapshot()

Radhey Shyam Pandey (1):
      dmaengine: xilinx_dma: Set DMA mask for coherent APIs

Rasmus Villemoes (1):
      init: move usermodehelper_enable() to populate_rootfs()

Remi Bernon (1):
      perf symbol: Look for ImageBase in PE file to compute .text offset

Saravana Kannan (1):
      of: property: Disable fw_devlink DT support for X86

Sebastian Andrzej Siewior (1):
      sched/idle: Make the idle timer expire in hard interrupt context

Song Liu (1):
      blk-mq: allow 4x BLK_MAX_REQUEST_COUNT at blk_plug for multiple_queues

Sven Schnelle (1):
      s390: add kmemleak annotation in stack_alloc()

Tetsuo Handa (1):
      block: genhd: don't call blkdev_show() with major_names_lock held

Thomas Gleixner (1):
      drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()

Tomer Tayar (1):
      habanalabs: fix nullifying of destroyed mmu pgt pool

Uwe Kleine-König (6):
      pwm: ab8500: Fix register offset calculation to not depend on probe order
      pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered
      pwm: mxs: Don't modify HW state in .probe() after the PWM chip was registered
      pwm: img: Don't modify HW state in .remove() callback
      pwm: rockchip: Don't modify HW state in .remove() callback
      pwm: stm32-lp: Don't modify HW state in .remove() callback

Vasily Gorbik (1):
      s390/unwind: use current_frame_address() to unwind current task

Wei Huang (1):
      iommu/amd: Relocate GAMSup check to early_enable_iommus

Xie Yongji (1):
      9p/trans_virtio: Remove sysfs file on probe failure

Xiubo Li (1):
      ceph: remove the capsnaps when removing caps

Yang Yingliang (1):
      n64cart: fix return value check in n64cart_probe()

Yixing Liu (1):
      RDMA/hns: Enable stash feature of HIP09

Yu-Tung Chang (1):
      rtc: rx8010: select REGMAP_I2C

Yuri Nudelman (1):
      habanalabs: fix mmu node address resolution in debugfs

Zhen Lei (1):
      nilfs2: use refcount_dec_and_lock() to fix potential UAF

Zou Wei (1):
      dmaengine: sprd: Add missing MODULE_DEVICE_TABLE

farah kassabri (1):
      habanalabs: cannot sleep while holding spinlock

nick black (1):
      console: consume APC, DM, DCS

xinhui pan (1):
      drm/ttm: Fix a deadlock if the target BO is not idle during swap

