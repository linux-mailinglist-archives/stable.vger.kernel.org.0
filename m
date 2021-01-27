Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF633059C9
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbhA0Lby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:31:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236714AbhA0L3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 06:29:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 004AD2076B;
        Wed, 27 Jan 2021 11:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611746935;
        bh=mCjdq0CO42cFZMe57e3C9FmGCxGuXk4ZLxAACHDkprE=;
        h=From:To:Cc:Subject:Date:From;
        b=exiPlsln9S/WpXSflJohJQ40o2/8qCikNcLA5NQFidDFvc6+HEYljY6feue5SyNd8
         iCcSzbKGzK/v3wgXk/jzPMyXQv5kaNle3UOo+pznnPYzJL1K07QEzAa/YwRaB52MyR
         Cup9mbhybJTM1UvBxlP+UPtF/6X7tl54zIFdV+dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.11
Date:   Wed, 27 Jan 2021 12:28:48 +0100
Message-Id: <16117469283166@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.11 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-class-devlink            |    4 
 Documentation/ABI/testing/sysfs-devices-consumer         |    5 
 Documentation/ABI/testing/sysfs-devices-supplier         |    5 
 Documentation/admin-guide/device-mapper/dm-integrity.rst |   12 -
 Documentation/admin-guide/kernel-parameters.txt          |    4 
 Makefile                                                 |    2 
 arch/arm/xen/enlighten.c                                 |    2 
 arch/arm64/include/asm/atomic.h                          |   10 -
 arch/arm64/kernel/signal.c                               |    7 
 arch/arm64/kernel/syscall.c                              |    9 
 arch/powerpc/include/asm/exception-64s.h                 |   13 +
 arch/powerpc/include/asm/feature-fixups.h                |   10 +
 arch/powerpc/kernel/entry_64.S                           |    2 
 arch/powerpc/kernel/exceptions-64s.S                     |   19 +
 arch/powerpc/kernel/vmlinux.lds.S                        |   32 +--
 arch/powerpc/lib/feature-fixups.c                        |   24 ++
 arch/riscv/Kconfig                                       |    6 
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts      |    2 
 arch/riscv/configs/defconfig                             |    2 
 arch/riscv/kernel/cacheinfo.c                            |   11 +
 arch/riscv/kernel/entry.S                                |    9 
 arch/riscv/kernel/time.c                                 |    3 
 arch/riscv/mm/init.c                                     |   16 +
 arch/sh/Kconfig                                          |    1 
 arch/sh/drivers/dma/Kconfig                              |    3 
 arch/x86/entry/common.c                                  |   10 -
 arch/x86/hyperv/hv_init.c                                |    4 
 arch/x86/include/asm/fpu/api.h                           |   15 +
 arch/x86/include/asm/mshyperv.h                          |    2 
 arch/x86/include/asm/topology.h                          |    4 
 arch/x86/kernel/cpu/amd.c                                |    4 
 arch/x86/kernel/cpu/mshyperv.c                           |   18 +
 arch/x86/kernel/cpu/topology.c                           |    2 
 arch/x86/kernel/fpu/core.c                               |    9 
 arch/x86/kernel/setup.c                                  |   20 --
 arch/x86/kernel/sev-es.c                                 |   14 +
 arch/x86/lib/mmx_32.c                                    |   20 +-
 arch/x86/xen/enlighten_hvm.c                             |   11 +
 arch/x86/xen/smp_hvm.c                                   |   29 +--
 crypto/xor.c                                             |    2 
 drivers/acpi/scan.c                                      |    2 
 drivers/base/core.c                                      |   44 +++-
 drivers/base/dd.c                                        |    2 
 drivers/clk/tegra/clk-tegra30.c                          |    2 
 drivers/counter/ti-eqep.c                                |   35 ---
 drivers/crypto/Kconfig                                   |    1 
 drivers/gpio/Kconfig                                     |    3 
 drivers/gpio/gpiolib-cdev.c                              |  145 +++++++--------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c               |    1 
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h                  |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c                    |   11 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c    |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c    |    4 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c    |    7 
 drivers/gpu/drm/drm_atomic_helper.c                      |    2 
 drivers/gpu/drm/drm_syncobj.c                            |    8 
 drivers/gpu/drm/i915/display/intel_ddi.c                 |    8 
 drivers/gpu/drm/i915/display/intel_dp.c                  |   33 +--
 drivers/gpu/drm/i915/display/intel_dp.h                  |    5 
 drivers/gpu/drm/i915/display/intel_dp_mst.c              |    2 
 drivers/gpu/drm/i915/display/intel_hdcp.c                |    9 
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c              |    9 
 drivers/gpu/drm/i915/gt/intel_lrc.c                      |    3 
 drivers/gpu/drm/i915/gt/intel_timeline.c                 |   10 -
 drivers/gpu/drm/i915/i915_request.h                      |   37 +++
 drivers/gpu/drm/nouveau/dispnv50/disp.c                  |    4 
 drivers/gpu/drm/nouveau/dispnv50/disp.h                  |    2 
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c              |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c        |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c       |    8 
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c         |   10 -
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c         |   10 -
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c           |    6 
 drivers/gpu/drm/vc4/vc4_hdmi.c                           |    1 
 drivers/hid/Kconfig                                      |    1 
 drivers/hid/hid-ids.h                                    |    1 
 drivers/hid/hid-input.c                                  |    2 
 drivers/hid/hid-logitech-dj.c                            |    4 
 drivers/hid/hid-logitech-hidpp.c                         |    2 
 drivers/hid/hid-multitouch.c                             |    4 
 drivers/hv/vmbus_drv.c                                   |    2 
 drivers/hwtracing/intel_th/pci.c                         |    5 
 drivers/hwtracing/stm/heartbeat.c                        |    6 
 drivers/i2c/busses/Kconfig                               |    1 
 drivers/i2c/busses/i2c-octeon-core.c                     |    2 
 drivers/i2c/busses/i2c-tegra-bpmp.c                      |    2 
 drivers/i2c/busses/i2c-tegra.c                           |    2 
 drivers/iio/adc/ti_am335x_adc.c                          |    6 
 drivers/iio/common/st_sensors/st_sensors_trigger.c       |   31 +--
 drivers/iio/dac/ad5504.c                                 |    4 
 drivers/iio/temperature/mlx90632.c                       |    6 
 drivers/infiniband/core/cma_configfs.c                   |    4 
 drivers/infiniband/core/ucma.c                           |  135 +++++++------
 drivers/infiniband/core/umem.c                           |    2 
 drivers/interconnect/imx/imx8mq.c                        |    2 
 drivers/irqchip/irq-mips-cpu.c                           |    7 
 drivers/lightnvm/core.c                                  |    3 
 drivers/md/Kconfig                                       |    1 
 drivers/md/dm-crypt.c                                    |    6 
 drivers/md/dm-integrity.c                                |   32 +++
 drivers/md/dm-table.c                                    |   15 +
 drivers/mmc/core/queue.c                                 |    4 
 drivers/mmc/host/sdhci-brcmstb.c                         |    6 
 drivers/mmc/host/sdhci-of-dwcmshc.c                      |   27 ++
 drivers/mmc/host/sdhci-xenon.c                           |    7 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c               |    2 
 drivers/mtd/nand/raw/nandsim.c                           |    7 
 drivers/net/can/dev.c                                    |    4 
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c               |    8 
 drivers/net/can/vxcan.c                                  |    6 
 drivers/net/dsa/b53/b53_common.c                         |    2 
 drivers/net/dsa/mv88e6xxx/global1_vtu.c                  |    4 
 drivers/net/ethernet/broadcom/bcmsysport.c               |    6 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c      |    6 
 drivers/net/ethernet/mscc/ocelot.c                       |   23 +-
 drivers/net/ethernet/mscc/ocelot_net.c                   |    4 
 drivers/net/ethernet/renesas/sh_eth.c                    |    4 
 drivers/nvme/host/pci.c                                  |  105 ++++++----
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c               |    2 
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c         |    4 
 drivers/pinctrl/pinctrl-ingenic.c                        |   26 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                       |   96 ++++++---
 drivers/pinctrl/qcom/pinctrl-msm.h                       |    2 
 drivers/platform/x86/hp-wmi.c                            |    3 
 drivers/platform/x86/i2c-multi-instantiate.c             |   31 ++-
 drivers/platform/x86/ideapad-laptop.c                    |   15 +
 drivers/platform/x86/intel-vbtn.c                        |    6 
 drivers/scsi/megaraid/megaraid_sas_base.c                |    6 
 drivers/scsi/qedi/qedi_main.c                            |    4 
 drivers/scsi/scsi_debug.c                                |    5 
 drivers/scsi/sd.c                                        |    4 
 drivers/scsi/ufs/Kconfig                                 |    1 
 drivers/scsi/ufs/ufshcd.c                                |   35 +--
 drivers/target/target_core_user.c                        |   11 -
 drivers/tty/n_tty.c                                      |    7 
 drivers/tty/serial/mvebu-uart.c                          |   10 -
 drivers/tty/serial/sifive.c                              |    1 
 drivers/tty/tty_io.c                                     |   51 ++---
 drivers/usb/cdns3/cdns3-imx.c                            |   17 -
 drivers/usb/gadget/udc/aspeed-vhub/epn.c                 |    5 
 drivers/usb/gadget/udc/bdc/Kconfig                       |    2 
 drivers/usb/gadget/udc/core.c                            |   13 +
 drivers/usb/gadget/udc/dummy_hcd.c                       |   10 -
 drivers/usb/host/ehci-hcd.c                              |   12 +
 drivers/usb/host/ehci-hub.c                              |    3 
 drivers/usb/host/xhci-ring.c                             |    2 
 drivers/usb/host/xhci-tegra.c                            |    7 
 drivers/xen/events/events_base.c                         |   10 -
 drivers/xen/platform-pci.c                               |    1 
 drivers/xen/xenbus/xenbus.h                              |    1 
 drivers/xen/xenbus/xenbus_comms.c                        |    8 
 drivers/xen/xenbus/xenbus_probe.c                        |   81 ++++++--
 fs/btrfs/backref.c                                       |    2 
 fs/btrfs/block-group.c                                   |    3 
 fs/btrfs/disk-io.c                                       |    2 
 fs/btrfs/extent-tree.c                                   |   10 -
 fs/btrfs/print-tree.c                                    |   10 -
 fs/btrfs/print-tree.h                                    |    2 
 fs/btrfs/send.c                                          |   15 +
 fs/btrfs/volumes.c                                       |    2 
 fs/cachefiles/rdwr.c                                     |    2 
 fs/cifs/transport.c                                      |    4 
 fs/fs-writeback.c                                        |   24 +-
 fs/io_uring.c                                            |   43 +++-
 fs/kernfs/file.c                                         |   65 ++----
 fs/nfsd/nfs4xdr.c                                        |   14 +
 fs/pipe.c                                                |    1 
 fs/proc/proc_sysctl.c                                    |    7 
 include/asm-generic/bitops/atomic.h                      |    6 
 include/linux/device.h                                   |   12 +
 include/linux/tty.h                                      |    1 
 include/net/inet_connection_sock.h                       |    3 
 include/net/sock.h                                       |   17 +
 include/xen/xenbus.h                                     |    2 
 kernel/bpf/bpf_inode_storage.c                           |    5 
 kernel/bpf/syscall.c                                     |    6 
 kernel/locking/lockdep.c                                 |    2 
 kernel/printk/printk.c                                   |    4 
 kernel/printk/printk_ringbuffer.c                        |    2 
 lib/iov_iter.c                                           |    2 
 mm/kasan/init.c                                          |   23 +-
 mm/memcontrol.c                                          |    4 
 mm/migrate.c                                             |   23 +-
 net/bpf/test_run.c                                       |    3 
 net/core/dev.c                                           |    5 
 net/core/devlink.c                                       |    4 
 net/core/gen_estimator.c                                 |   11 -
 net/core/skbuff.c                                        |    6 
 net/ipv4/inet_connection_sock.c                          |    1 
 net/ipv4/netfilter/ipt_rpfilter.c                        |    2 
 net/ipv4/tcp.c                                           |    1 
 net/ipv4/tcp_input.c                                     |    6 
 net/ipv4/tcp_ipv4.c                                      |   29 +--
 net/ipv4/tcp_output.c                                    |    1 
 net/ipv4/tcp_timer.c                                     |   36 +--
 net/ipv4/udp.c                                           |    3 
 net/ipv6/addrconf.c                                      |    3 
 net/sched/cls_flower.c                                   |   22 +-
 net/sched/cls_tcindex.c                                  |    8 
 net/sched/sch_api.c                                      |    3 
 net/sunrpc/svcsock.c                                     |   86 ++++++++
 net/xdp/xsk.c                                            |    4 
 sound/core/seq/oss/seq_oss_synth.c                       |    3 
 sound/pci/hda/hda_codec.c                                |   24 --
 sound/pci/hda/hda_tegra.c                                |    2 
 sound/pci/hda/patch_realtek.c                            |    8 
 sound/pci/hda/patch_via.c                                |    1 
 sound/soc/codecs/rt711.c                                 |    6 
 sound/soc/intel/boards/haswell.c                         |    1 
 sound/soc/sof/intel/hda-codec.c                          |   18 -
 sound/soc/sof/intel/hda-dsp.c                            |    6 
 tools/gpio/gpio-event-mon.c                              |    4 
 tools/gpio/gpio-watch.c                                  |    5 
 tools/lib/perf/evlist.c                                  |   17 -
 tools/lib/perf/tests/test-cpumap.c                       |    2 
 tools/lib/perf/tests/test-evlist.c                       |    3 
 tools/lib/perf/tests/test-evsel.c                        |    2 
 tools/lib/perf/tests/test-threadmap.c                    |    2 
 tools/testing/selftests/net/fib_tests.sh                 |    1 
 tools/testing/selftests/powerpc/mm/pkey_exec_prot.c      |    2 
 tools/testing/selftests/powerpc/mm/pkey_siginfo.c        |    2 
 221 files changed, 1591 insertions(+), 884 deletions(-)

Adrian Hunter (1):
      perf evlist: Fix id index for heterogeneous systems

Aharon Landau (1):
      RDMA/umem: Avoid undefined behavior of rounddown_pow_of_two()

Al Cooper (1):
      mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend

Alan Stern (1):
      USB: gadget: dummy-hcd: Fix errors in port-reset handling

Alban Bedel (1):
      net: mscc: ocelot: Fix multicast to the CPU port

Alex Leibovich (1):
      mmc: sdhci-xenon: fix 1.8v regulator stabilization

Alexander Lobakin (1):
      skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Alexander Shishkin (1):
      intel_th: pci: Add Alder Lake-P support

Alexandru Ardelean (1):
      iio: adc: ti_am335x_adc: remove omitted iio_kfifo_free()

Andy Lutomirski (2):
      x86/fpu: Add kernel_fpu_begin_mask() to selectively initialize state
      x86/mmx: Use KFPU_387 for MMX string operations

Anshuman Gupta (2):
      drm/i915/hdcp: Update CP property in update_pipe
      drm/i915/hdcp: Get conn while content_type changed

Anthony Iliopoulos (1):
      dm integrity: select CRYPTO_SKCIPHER

Ariel Marcovitch (1):
      powerpc: Fix alignment bug within the init sections

Arnd Bergmann (4):
      HID: sony: select CONFIG_CRC32
      arm64: make atomic helpers __always_inline
      scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression
      crypto: omap-sham - Fix link error without crypto-engine

Atish Patra (2):
      RISC-V: Set current memblock limit
      RISC-V: Fix maximum allowed phsyical memory for RV32

Ben Skeggs (5):
      drm/nouveau/bios: fix issue shadowing expansion ROMs
      drm/nouveau/privring: ack interrupts the same way as RM
      drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields
      drm/nouveau/mmu: fix vram heap sizing
      drm/nouveau/kms/nv50-: fix case where notifier buffer is at offset 0

Billy Tsai (1):
      pinctrl: aspeed: g6: Fix PWMG0 pinctrl setting

Borislav Petkov (1):
      x86/topology: Make __max_die_per_package available unconditionally

Can Guo (1):
      scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Cezary Rojewski (1):
      ASoC: Intel: haswell: Add missing pm_ops

Chris Chiu (1):
      ALSA: hda/realtek - Limit int mic boost on Acer Aspire E5-575T

Chris Wilson (2):
      drm/i915/gt: Prevent use of engine->wa_ctx after error
      drm/i915: Check for rq->hwsp validity after acquiring RCU lock

Christoph Hellwig (6):
      iov_iter: fix the uaccess area in copy_compat_iovec_from_user
      nvme-pci: refactor nvme_unmap_data
      nvme-pci: fix error unwind in nvme_map_data
      kernfs: implement ->read_iter
      kernfs: implement ->write_iter
      kernfs: wire up ->splice_read and ->splice_write

Chuck Lever (1):
      SUNRPC: Handle TCP socket sends with kernel_sendpage() again

Cong Wang (1):
      cls_flower: call nla_ok() before nla_next()

Damien Le Moal (3):
      riscv: Fix kernel time_init()
      riscv: Fix sifive serial driver
      riscv: Enable interrupts during syscalls with M-Mode

Dan Carpenter (1):
      net: dsa: b53: fix an off by one in checking "vlan->vid"

Daniel Vetter (1):
      drm/syncobj: Fix use-after-free

David Lechner (1):
      counter:ti-eqep: remove floor

David Woodhouse (3):
      xen: Fix event channel callback via INTX/GSI
      x86/xen: Add xen_no_vector_callback option to test PCI INTX delivery
      x86/xen: Fix xen_hvm_smp_init() when vector callback not available

Dexuan Cui (1):
      x86/hyperv: Fix kexec panic/hang issues

Dinghao Liu (1):
      scsi: scsi_debug: Fix memleak in scsi_debug_init()

Douglas Anderson (4):
      pinctrl: qcom: Allow SoCs to specify a GPIO function that's not 0
      pinctrl: qcom: No need to read-modify-write the interrupt status
      pinctrl: qcom: Properly clear "intr_ack_high" interrupts when unmasking
      pinctrl: qcom: Don't clear pending interrupts when enabling

Enke Chen (1):
      tcp: fix TCP_USER_TIMEOUT with zero window

Eric Biggers (1):
      fs: fix lazytime expiration handling in __writeback_single_inode()

Eric Dumazet (4):
      net_sched: gen_estimator: support large ewma log
      net_sched: avoid shift-out-of-bounds in tcindex_set_parms()
      net_sched: reject silly cell_log in qdisc_get_rtab()
      tcp: do not mess with cloned skbs in tcp_add_backlog()

Eugene Korenevsky (1):
      ehci: fix EHCI host controller initialization sequence

Ewan D. Milne (1):
      scsi: sd: Suppress spurious errors when WRITE SAME is being disabled

Filipe Laíns (1):
      HID: logitech-dj: add the G602 receiver

Filipe Manana (1):
      btrfs: send: fix invalid clone operations when cloning from the same file and root

Geert Uytterhoeven (1):
      sh_eth: Fix power down vs. is_opened flag ordering

Greg Kroah-Hartman (1):
      Linux 5.10.11

Guillaume Nault (2):
      netfilter: rpfilter: mask ecn bits before fib lookup
      udp: mask TOS bits in udp_v4_early_demux()

Hangbin Liu (1):
      selftests: net: fib_tests: remove duplicate log test

Hannes Reinecke (1):
      dm: avoid filesystem lookup in dm_get_dev_t()

Hans de Goede (3):
      ACPI: scan: Make acpi_bus_get_device() clear return pointer on error
      platform/x86: intel-vbtn: Drop HP Stream x360 Convertible PC 11 from allow-list
      platform/x86: hp-wmi: Don't log a warning on HPWMI_RET_UNKNOWN_COMMAND errors

Heikki Krogerus (1):
      platform/x86: i2c-multi-instantiate: Don't create platform device for INT3515 ACPI nodes

Hsin-Yi Wang (1):
      pinctrl: mediatek: Fix fallback call path

Huang Rui (1):
      drm/amdgpu: remove gpu info firmware of green sardine

Hyunwook (Wooky) Baek (1):
      x86/sev-es: Handle string port IO to kernel memory properly

Ian Rogers (2):
      libperf tests: If a test fails return non-zero
      libperf tests: Fail when failing to get a tracepoint id

Ignat Korchagin (1):
      dm crypt: fix copy and paste bug in crypt_alloc_req_aead

JC Kuo (1):
      xhci: tegra: Delay for disabling LFPS detector

Jaegeuk Kim (1):
      scsi: ufs: Fix tm request when non-fatal error happens

Jason Gunthorpe (1):
      RDMA/ucma: Do not miss ctx destruction steps in some cases

Jens Axboe (2):
      io_uring: iopoll requests should also wake task ->in_idle state
      io_uring: fix SQPOLL IORING_OP_CLOSE cancelation state

Jeremy Cline (1):
      drm/amdkfd: Fix out-of-bounds read in kdf_create_vcrat_image_cpu()

Jiaxun Yang (1):
      platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634

Jinyang He (1):
      sh: Remove unused HAVE_COPY_THREAD_TLS macro

Jiri Olsa (1):
      bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach

Jisheng Zhang (1):
      mmc: sdhci-of-dwcmshc: fix rpmb access

Johannes Berg (1):
      fs/pipe: allow sendfile() to pipe again

John Ogness (2):
      printk: ringbuffer: fix line counting
      printk: fix kmsg_dump_get_buffer length calulations

Josef Bacik (5):
      btrfs: don't get an EINTR during drop_snapshot for reloc
      btrfs: do not double free backref nodes on error
      btrfs: fix lockdep splat in btrfs_recover_relocation
      btrfs: don't clear ret in btrfs_start_dirty_block_groups
      btrfs: print the actual offset in btrfs_root_name

KP Singh (1):
      bpf: Local storage helpers should check nullness of owner ptr passed

Kai Vehmanen (1):
      ASoC: SOF: Intel: fix page fault at probe if i915 init fails

Kai-Heng Feng (3):
      HID: multitouch: Enable multi-input for Synaptics pointstick/touchpad device
      ALSA: hda: Balance runtime/system PM if direct-complete is disabled
      ASoC: SOF: Intel: hda: Avoid checking jack on system suspend

Kefeng Wang (1):
      riscv: cacheinfo: Fix using smp_processor_id() in preemptible

Kent Gibson (3):
      gpiolib: cdev: fix frame size warning in gpio_ioctl()
      tools: gpio: fix %llu warning in gpio-event-mon.c
      tools: gpio: fix %llu warning in gpio-watch.c

Kirill Tkhai (1):
      crypto: xor - Fix divide error in do_xor_speed()

Krzysztof Kozlowski (1):
      i2c: sprd: depend on COMMON_CLK to fix compile tests

Kuniyuki Iwashima (1):
      tcp: Fix potential use-after-free due to double kfree()

Lars-Peter Clausen (1):
      iio: ad5504: Fix setting power-down state

Lecopzer Chen (2):
      kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow
      kasan: fix incorrect arguments passing in kasan_add_zero_shadow

Li, Roman (1):
      drm/amd/display: disable dcn10 pipe split by default

Linus Torvalds (3):
      tty: implement write_iter
      tty: fix up hung_up_tty_write() conversion
      Revert "mm: fix initialization of struct page for holes in memory layout"

Longfang Liu (1):
      USB: ehci: fix an interrupt calltrace error

Lorenzo Bianconi (1):
      iio: common: st_sensors: fix possible infinite loop in st_sensors_irq_thread

Marcelo Diop-Gonzalez (1):
      io_uring: flush timeouts that should already have expired

Mark Rutland (1):
      arm64: entry: remove redundant IRQ flag tracing

Martin Kepplinger (1):
      interconnect: imx8mq: Use icc_sync_state

Mathias Kresin (1):
      irqchip/mips-cpu: Set IPI domain parent chip

Mathias Nyman (1):
      xhci: make sure TRB is fully written before giving it to the controller

Matteo Croce (2):
      ipv6: create multicast route with RTPROT_KERNEL
      ipv6: set multicast flag on the multicast route

Maxim Mikityanskiy (1):
      xsk: Clear pool even for inactive queues

Meng Li (1):
      drivers core: Free dma_range_map when driver probe failed

Mike Rapoport (2):
      x86/setup: don't remove E820_TYPE_RAM for pfn 0
      mm: fix initialization of struct page for holes in memory layout

Mikko Perttunen (2):
      i2c: tegra: Wait for config load atomically while in ISR
      i2c: bpmp-tegra: Ignore unknown I2C_M flags

Mikulas Patocka (2):
      dm integrity: fix a crash if "recalculate" used without "internal_hash"
      dm integrity: conditionally disable "recalculate" feature

Miquel Raynal (1):
      mtd: rawnand: nandsim: Fix the logic when selecting Hamming soft ECC engine

Necip Fazil Yildiran (1):
      sh: dma: fix kconfig dependency for G2_DMA

Neta Ostrovsky (1):
      RDMA/cma: Fix error flow in default_roce_mode_store

Nicholas Miell (1):
      HID: logitech-hidpp: Add product ID for MX Ergo in Bluetooth mode

Nicholas Piggin (1):
      powerpc/64s: fix scv entry fallback flush vs interrupt

Nicolas Saenz Julienne (1):
      drm/vc4: Unify PCM card's driver_name

Nilesh Javali (1):
      scsi: qedi: Correct max length of CHAP secret

Oleksandr Mazur (1):
      net: core: devlink: use right genl user_ptr when handling port param get/set

Pali Rohár (1):
      serial: mvebu-uart: fix tx lost characters at power off

Pan Bian (3):
      drm/atomic: put state on error path
      lightnvm: fix memory leak when submit fails
      net: systemport: free dev before on error path

Patrik Jakobsson (1):
      usb: bdc: Make bdc pci driver depend on BROKEN

Paul Cercueil (1):
      pinctrl: ingenic: Fix JZ4760 support

Pavel Begunkov (1):
      io_uring: fix short read retries for non-reg files

Peter Chen (2):
      usb: cdns3: imx: fix writing read-only memory issue
      usb: cdns3: imx: fix can't create core device the second time issue

Peter Collingbourne (1):
      mmc: core: don't initialize block size from ext_csd if not present

Peter Geis (2):
      clk: tegra30: Add hda clock default rates to clock driver
      ALSA: hda/tegra: fix tegra-hda on tegra30 soc

Peter Zijlstra (3):
      x86/entry: Fix noinstr fail
      locking/lockdep: Cure noinstr fail
      x86/sev: Fix nonistr violation

Rafael J. Wysocki (1):
      driver core: Extend device_is_dependent()

Randy Dunlap (3):
      x86/xen: fix 'nopvspin' build error
      scsi: ufs: ufshcd-pltfrm depends on HAS_IOMEM
      gpio: sifive: select IRQ_DOMAIN_HIERARCHY rather than depend on it

Rasmus Villemoes (1):
      net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext

Roman Gushchin (1):
      mm: memcg/slab: optimize objcg stock draining

Ronnie Sahlberg (1):
      cifs: do not fail __smb_send_rqst if non-fatal signals are pending

Ryan Chen (1):
      usb: gadget: aspeed: fix stop dma register setting.

Sagar Shrikant Kadam (3):
      dts: phy: fix missing mdio device and probe failure of vsc8541-01 device
      dts: phy: add GPIO number and active state used for phy reset
      riscv: defconfig: enable gpio support for HiFive Unleashed

Sami Tolvanen (1):
      Commit 9bb48c82aced ("tty: implement write_iter") converted the tty layer to use write_iter. Fix the redirected_tty_write declaration also in n_tty and change the comparisons to use write_iter instead of write. also in n_tty and change the comparisons to use write_iter instead of write.

Sandipan Das (1):
      selftests/powerpc: Fix exit status of pkey tests

Saravana Kannan (1):
      driver core: Fix device link device name collision

Sean Nyekjaer (1):
      mtd: rawnand: gpmi: fix dst bit offset when extracting raw payload

Seth Miller (1):
      HID: Ignore battery for Elan touchscreen on ASUS UX550

Shakeel Butt (2):
      mm: memcg: fix memcg file_dirty numa stat
      mm: fix numa stats for thp migration

Shin'ichiro Kawasaki (1):
      scsi: target: tcmu: Fix use-after-free of se_cmd->priv

Shuming Fan (1):
      ASoC: rt711: mutex between calibration and power state changes

Slaveyko Slaveykov (1):
      drivers: iio: temperature: Add delay after the addressed reset command in mlx90632.c

Song Liu (1):
      bpf: Reject too big ctx_size_in for raw_tp test run

Stanley Chu (1):
      scsi: ufs: Relax the condition of UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL

Sung Lee (1):
      drm/amd/display: DCN2X Find Secondary Pipe properly in MPO + ODM Case

Takashi Iwai (3):
      ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()
      ALSA: hda/via: Add minimum mute flag
      cachefiles: Drop superfluous readpages aops NULL check

Tariq Toukan (1):
      net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled

Thinh Nguyen (1):
      usb: udc: core: Use lock when write to soft_connect

Trond Myklebust (2):
      nfsd: Fixes for nfsd4_encode_read_plus_data()
      nfsd: Don't set eof on a truncated READ_PLUS

Victor Zhao (1):
      drm/amdgpu/psp: fix psp gfx ctrl cmds

Ville Syrjälä (2):
      drm/i915: s/intel_dp_sink_dpms/intel_dp_set_power/
      drm/i915: Only enable DFP 4:4:4->4:2:0 conversion when outputting YCbCr 4:4:4

Vincent Mailhol (3):
      can: dev: can_restart: fix use after free bug
      can: vxcan: vxcan_xmit: fix use after free bug
      can: peak_usb: fix use after free bugs

Vladimir Oltean (1):
      net: mscc: ocelot: allow offloading of bridge on top of LAG

Wang Hui (1):
      stm class: Fix module init return on allocation failure

Wayne Lin (1):
      drm/amd/display: Fix to be able to stop crc calculation

Wolfram Sang (1):
      i2c: octeon: check correct size of maximum RECV_LEN packet

Xiaoming Ni (1):
      proc_sysctl: fix oops caused by incorrect command parameters

Yazen Ghannam (1):
      x86/cpu/amd: Set __max_die_per_package on AMD

Yingjie Wang (1):
      octeontx2-af: Fix missing check bugs in rvu_cgx.c

Youling Tang (1):
      powerpc: Use the common INIT_DATA_SECTION macro in vmlinux.lds.S

Yuchung Cheng (1):
      tcp: fix TCP socket rehash stats mis-accounting

