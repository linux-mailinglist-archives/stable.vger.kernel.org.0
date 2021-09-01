Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F443FDBF0
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344263AbhIAMp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345439AbhIAMoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1476F6121E;
        Wed,  1 Sep 2021 12:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499911;
        bh=7pILs2UVUM1GEz3EYDz1r+9S2Sr+halamAWy1PKI/hk=;
        h=From:To:Cc:Subject:Date:From;
        b=Tumx1nEIQFmQxUEMDStnGeg1N9jMtV3HYxYHUywgdhHnoQlEkM1b9g8MqrDdAIvWd
         5qwcCbCXTQG+a14r70pP+hFz+5vIifOzoKz1UN+egoKJrUcK6D4UOXcqYybMVQAoqz
         Je8g4siYX1pBSSQCQ60Ykg8LB34lSG7+nP5SmHjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/113] 5.13.14-rc1 review
Date:   Wed,  1 Sep 2021 14:27:15 +0200
Message-Id: <20210901122301.984263453@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.14-rc1
X-KernelTest-Deadline: 2021-09-03T12:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.14 release.
There are 113 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.14-rc1

Richard Guy Briggs <rgb@redhat.com>
    audit: move put_tree() to avoid trim_trees refcount underflow and UAF

Peter Collingbourne <pcc@google.com>
    net: don't unconditionally copy_from_user a struct ifreq for socket ioctls

Helge Deller <deller@gmx.de>
    Revert "parisc: Add assembly implementations for memset, strlen, strcpy, strncpy and strcat"

Eric Biggers <ebiggers@google.com>
    ubifs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    f2fs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    ext4: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    fscrypt: add fscrypt_symlink_getattr() for computing st_size

Denis Efremov <efremov@linux.com>
    Revert "floppy: reintroduce O_NDELAY fix"

Qu Wenruo <wqu@suse.com>
    btrfs: fix NULL pointer dereference when deleting device by invalid id

Petr Vorel <petr.vorel@gmail.com>
    arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix VLAN traffic leaks again

Pauli Virtanen <pav@iki.fi>
    Bluetooth: btusb: check conditions before enabling USB ALT 3 for WBS

Linus Torvalds <torvalds@linux-foundation.org>
    vt_kdsetmode: extend console locking

Xin Long <lucien.xin@gmail.com>
    tipc: call tipc_wait_for_connect only when dlen is not 0

Linus Torvalds <torvalds@linux-foundation.org>
    pipe: do FASYNC notifications for every pipe IO, not just state changes

Linus Torvalds <torvalds@linux-foundation.org>
    pipe: avoid unnecessary EPOLLET wakeups under normal loads

Mark Rutland <mark.rutland@arm.com>
    arm64: initialize all of CNTHCTL_EL2

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: dma_map_sg is entitled to merge entries

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: gigabyte-wmi: add support for B450M S2H V2

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/nv50: workaround EFI GOP window channel format differences

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/disp: power down unused DP links during init

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: recognise GA107

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: gigabyte-wmi: add support for X570 GAMING X

Mark Yacoub <markyacoub@google.com>
    drm: Copy drm_wait_vblank to user before returning

Ming Lei <ming.lei@redhat.com>
    blk-mq: don't grab rq's refcount in blk_mq_check_expired()

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: change the workload type for some cards

Kenneth Feng <kenneth.feng@amd.com>
    Revert "drm/amd/pm: fix workload mismatch on vega10"

Shai Malin <smalin@marvell.com>
    qed: Fix null-pointer dereference in qed_rdma_create_qp()

Shai Malin <smalin@marvell.com>
    qed: qed ll2 race condition fixes

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Add tablet_mode_sw=lid-flip quirk for the TP200s

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Allow configuring SW_TABLET_MODE method with a module option

Michael S. Tsirkin <mst@redhat.com>
    tools/virtio: fix build

Neeraj Upadhyay <neeraju@codeaurora.org>
    vringh: Use wiov->used to check for read/write desc order

Vincent Whitchurch <vincent.whitchurch@axis.com>
    virtio_vdpa: reject invalid vq indices

Parav Pandit <parav@nvidia.com>
    virtio_pci: Support surprise removal of virtio pci device

Parav Pandit <parav@nvidia.com>
    virtio: Improve vq->broken access to avoid any compiler optimization

Thara Gopinath <thara.gopinath@linaro.org>
    cpufreq: blocklist Qualcomm sm8150 in cpufreq-dt-platdev

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    opp: remove WARN when no valid OPPs remain

Yaara Baruch <yaara.baruch@intel.com>
    iwlwifi: add new so-jf devices

Yaara Baruch <yaara.baruch@intel.com>
    iwlwifi: add new SoF with JF devices

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pnvm: accept multiple HW-type TLVs

Adam Ford <aford173@gmail.com>
    clk: renesas: rcar-usb2-clock-sel: Fix kernel NULL pointer dereference

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    sched: Fix get_push_task() vs migrate_disable()

Colin Ian King <colin.king@canonical.com>
    perf/x86/intel/uncore: Fix integer overflow on 23 bit left shift of a u32

Jerome Brunet <jbrunet@baylibre.com>
    usb: gadget: u_audio: fix race condition on endpoint stop

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    net: stmmac: fix kernel panic due to NULL pointer dereference of plat->est

Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
    net: stmmac: add mutex lock to protect est parameters

Ulf Hansson <ulf.hansson@linaro.org>
    Revert "mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on BCM2711"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    media: ipu3-cio2: Drop reference on error path in cio2_bridge_connect_sensor()

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix get wrong pfc_en when query PFC configuration

Guojia Liao <liaoguojia@huawei.com>
    net: hns3: fix duplicate node in VLAN list

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix speed unknown issue in bond 4

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: add waiting time before cmdq memory is released

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: clear hardware resource when loading driver

Andrey Ignatov <rdna@fb.com>
    rtnetlink: Return correct error on changing device netns

Kurt Kanzenbach <kurt@linutronix.de>
    net: dsa: hellcreek: Adjust schedule look ahead window

Kurt Kanzenbach <kurt@linutronix.de>
    net: dsa: hellcreek: Fix incorrect setting of GCL

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: dont touch blocked freelist bitmap after free

Eric Dumazet <edumazet@google.com>
    ipv4: use siphash instead of Jenkins in fnhe_hashfun()

Eric Dumazet <edumazet@google.com>
    ipv6: use siphash in rt6_exception_hash()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix XPT_BUSY flag leakage in svc_handle_xprt()...

Davide Caratti <dcaratti@redhat.com>
    net/sched: ets: fix crash when flipping from 'strict' to 'quantum'

Alexey Gladkov <legion@kernel.org>
    ucounts: Increase ucounts reference counter before the security hook

Maxim Kiselev <bigunclemax@gmail.com>
    net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    ip_gre: add validation for csum_start

Gal Pressman <galpress@amazon.com>
    RDMA/efa: Free IRQ vectors on error flow

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Do not take care about recovery NVM checksum

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix the max snoop/no-snoop latency for 10M

Toshiki Nishioka <toshiki.nishioka@intel.com>
    igc: Use num_tx_queues when iterating over tx_ring queue

Aaron Ma <aaron.ma@canonical.com>
    igc: fix page fault when thunderbolt is unplugged

Petko Manolov <petko.manolov@konsulko.com>
    net: usb: pegasus: fixes of set_register(s) return value evaluation;

Jacob Keller <jacob.e.keller@intel.com>
    ice: do not abort devlink info if board identifier can't be found

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix memory allocation while in a spin lock

Dinghao Liu <dinghao.liu@zju.edu.cn>
    RDMA/bnxt_re: Remove unpaired rtnl unlock in bnxt_re_dev_init()

Tuo Li <islituo@gmail.com>
    IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()

Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
    RDMA/bnxt_re: Add missing spin lock initialization

Gal Pressman <galpress@amazon.com>
    RDMA/uverbs: Track dmabuf memory regions

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Fix crash when unbind multiport slave

Li Jinlin <lijinlin3@huawei.com>
    scsi: core: Fix hang of freezing queue between blocking and running device

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Stop EP0 transfers during pullup disable

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

Kyle Tso <kyletso@google.com>
    usb: typec: tcpm: Raise vdm_sm_running flag only when VDM SM is running

Takashi Iwai <tiwai@suse.de>
    usb: renesas-xhci: Prefer firmware loading on unknown ROM state

Zhengjun Zhang <zhangzhengjun@aicrobo.com>
    USB: serial: option: add new VID/PID to support Fibocom FG150

Johan Hovold <johan@kernel.org>
    Revert "USB: serial: ch341: fix character loss at high transfer rates"

Borislav Petkov <bp@suse.de>
    drm/amdgpu: Fix build with missing pm_suspend_target_state module export

Christian König <christian.koenig@amd.com>
    drm/amdgpu: use the preferred pin domain after the check

Michel Dänzer <mdaenzer@redhat.com>
    drm/amdgpu: Cancel delayed work when GFXOFF is disabled

Swati Sharma <swati2.sharma@intel.com>
    drm/i915/dp: Drop redundant debug print

Matthew Brost <matthew.brost@intel.com>
    drm/i915: Fix syncmap memory leak

Song Yoong Siang <yoong.siang.song@intel.com>
    net: stmmac: fix kernel panic due to NULL pointer dereference of buf->xdp

Song Yoong Siang <yoong.siang.song@intel.com>
    net: stmmac: fix kernel panic due to NULL pointer dereference of xsk_pool

Qu Wenruo <wqu@suse.com>
    Revert "btrfs: compression: don't try to compress if we don't have enough pages"

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory_hotplug: fix potential permanent lru cache disable

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    powerpc: Re-enable ARCH_ENABLE_SPLIT_PMD_PTLOCK

Vincent Chen <vincent.chen@sifive.com>
    riscv: Ensure the value of FP registers in the core dump file is up to date

Rob Herring <robh@kernel.org>
    dt-bindings: sifive-l2-cache: Fix 'select' matching

Xiubo Li <xiubli@redhat.com>
    ceph: correctly handle releasing an embedded cap flush

Stefan Mätje <stefan.maetje@esd.eu>
    can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Mark Brown <broonie@kernel.org>
    net: mscc: Fix non-GPL export of regmap APIs

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix uninitialized pointer read in ovl_lookup_real_one()

Ming Lei <ming.lei@redhat.com>
    blk-iocost: fix lockdep warning on blkcg->lock

Jens Axboe <axboe@kernel.dk>
    io_uring: rsrc ref lock needs to be IRQ safe

Kefeng Wang <wangkefeng.wang@huawei.com>
    once: Fix panic when module unload

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: collect all entries in one cycle

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Limit the maximal range of consecutive elements to add/delete

Guenter Roeck <linux@roeck-us.net>
    ARC: Fix CONFIG_STACKDEPOT

Hans de Goede <hdegoede@redhat.com>
    platform/x86: Add and use a dual_accel_detect() helper

Mark Brown <broonie@kernel.org>
    ASoC: component: Remove misplaced prefix handling in pin control functions

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5682: Adjust headset volume button threshold

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix ringbuf helper function compatibility

Xiaolong Huang <butterflyhuangxx@gmail.com>
    net: qrtr: fix another OOB Read in qrtr_endpoint_post


-------------

Diffstat:

 .../devicetree/bindings/riscv/sifive-l2-cache.yaml |   8 +-
 Makefile                                           |   4 +-
 arch/arc/kernel/vmlinux.lds.S                      |   2 +
 .../arm64/boot/dts/qcom/msm8994-angler-rev-101.dts |   4 +
 arch/arm64/include/asm/el2_setup.h                 |   3 +-
 arch/parisc/include/asm/string.h                   |  15 ---
 arch/parisc/kernel/parisc_ksyms.c                  |   4 -
 arch/parisc/lib/Makefile                           |   4 +-
 arch/parisc/lib/memset.c                           |  72 +++++++++++
 arch/parisc/lib/string.S                           | 136 ---------------------
 arch/powerpc/platforms/Kconfig.cputype             |   2 +-
 arch/riscv/kernel/ptrace.c                         |   4 +
 arch/x86/events/intel/uncore_snbep.c               |   2 +-
 block/blk-iocost.c                                 |   8 +-
 block/blk-mq.c                                     |  30 +----
 drivers/block/floppy.c                             |  30 ++---
 drivers/bluetooth/btusb.c                          |  22 ++--
 drivers/clk/renesas/rcar-usb2-clock-sel.c          |   2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  36 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  10 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  15 ++-
 drivers/gpu/drm/drm_ioc32.c                        |   4 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   9 +-
 drivers/gpu/drm/i915/gt/intel_timeline.c           |   9 ++
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  27 ++++
 drivers/gpu/drm/nouveau/dispnv50/head.c            |  13 +-
 drivers/gpu/drm/nouveau/dispnv50/head.h            |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |  21 ++++
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c      |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h      |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c    |   9 ++
 drivers/infiniband/core/uverbs_std_types_mr.c      |   3 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   1 +
 drivers/infiniband/hw/bnxt_re/main.c               |   1 -
 drivers/infiniband/hw/efa/efa_main.c               |   1 +
 drivers/infiniband/hw/hfi1/sdma.c                  |   9 +-
 drivers/infiniband/hw/mlx5/main.c                  |   3 +-
 drivers/infiniband/sw/rxe/rxe_mcast.c              |   2 +-
 drivers/media/pci/intel/ipu3/cio2-bridge.c         |   2 +-
 drivers/mmc/host/sdhci-iproc.c                     |   3 +-
 drivers/net/can/usb/esd_usb2.c                     |   4 +-
 drivers/net/dsa/hirschmann/hellcreek.c             |   8 +-
 drivers/net/dsa/mt7530.c                           |   5 +-
 drivers/net/ethernet/apm/xgene-v2/main.c           |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   7 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   4 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  13 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  34 +++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  32 +++--
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   3 +
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   4 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  36 +++---
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   3 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/mscc/ocelot_io.c              |  16 +--
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |  20 +++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  20 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c   |  12 +-
 drivers/net/usb/pegasus.c                          |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  25 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  70 ++++++++++-
 drivers/opp/of.c                                   |   5 +-
 drivers/platform/x86/Kconfig                       |   3 +
 drivers/platform/x86/asus-nb-wmi.c                 |  28 +++++
 drivers/platform/x86/dual_accel_detect.h           |  75 ++++++++++++
 drivers/platform/x86/gigabyte-wmi.c                |   2 +
 drivers/platform/x86/intel-hid.c                   |  21 +---
 drivers/platform/x86/intel-vbtn.c                  |  18 ++-
 drivers/platform/x86/thinkpad_acpi.c               |   3 +-
 drivers/scsi/scsi_sysfs.c                          |   9 +-
 drivers/tty/vt/vt_ioctl.c                          |  10 +-
 drivers/usb/dwc3/gadget.c                          |  23 ++--
 drivers/usb/gadget/function/u_audio.c              |   5 +-
 drivers/usb/host/xhci-pci-renesas.c                |  35 ++++--
 drivers/usb/serial/ch341.c                         |   1 -
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/typec/tcpm/tcpm.c                      |  81 ++++++------
 drivers/vhost/vringh.c                             |   2 +-
 drivers/virtio/virtio_pci_common.c                 |   7 ++
 drivers/virtio/virtio_ring.c                       |   6 +-
 drivers/virtio/virtio_vdpa.c                       |   3 +
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/volumes.c                                 |   2 +-
 fs/ceph/caps.c                                     |  21 ++--
 fs/ceph/mds_client.c                               |   7 +-
 fs/ceph/snap.c                                     |   3 +
 fs/ceph/super.h                                    |   3 +-
 fs/crypto/hooks.c                                  |  44 +++++++
 fs/ext4/symlink.c                                  |  12 +-
 fs/f2fs/namei.c                                    |  12 +-
 fs/io_uring.c                                      |  19 +--
 fs/overlayfs/export.c                              |   2 +-
 fs/pipe.c                                          |  33 +++--
 fs/ubifs/file.c                                    |  13 +-
 include/linux/fscrypt.h                            |   7 ++
 include/linux/netdevice.h                          |   4 +
 include/linux/netfilter/ipset/ip_set.h             |   3 +
 include/linux/once.h                               |   4 +-
 include/linux/pipe_fs_i.h                          |   2 +
 include/linux/stmmac.h                             |   1 +
 kernel/audit_tree.c                                |   2 +-
 kernel/bpf/verifier.c                              |   8 +-
 kernel/cred.c                                      |  12 +-
 kernel/sched/sched.h                               |   3 +
 lib/once.c                                         |  11 +-
 mm/memory_hotplug.c                                |   1 +
 net/core/rtnetlink.c                               |   3 +-
 net/ipv4/ip_gre.c                                  |   2 +
 net/ipv4/route.c                                   |  12 +-
 net/ipv6/route.c                                   |  20 ++-
 net/netfilter/ipset/ip_set_hash_ip.c               |   9 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c           |  10 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |   3 +
 net/netfilter/ipset/ip_set_hash_ipportip.c         |   3 +
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |   3 +
 net/netfilter/ipset/ip_set_hash_net.c              |  11 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |  10 +-
 net/netfilter/ipset/ip_set_hash_netnet.c           |  16 ++-
 net/netfilter/ipset/ip_set_hash_netport.c          |  11 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c       |  16 ++-
 net/netfilter/nf_conntrack_core.c                  |  71 ++++-------
 net/qrtr/qrtr.c                                    |   2 +-
 net/rds/ib_frmr.c                                  |   4 +-
 net/sched/sch_ets.c                                |   7 ++
 net/socket.c                                       |   6 +-
 net/sunrpc/svc_xprt.c                              |   3 +-
 net/tipc/socket.c                                  |   2 +-
 sound/soc/codecs/rt5682.c                          |   1 +
 sound/soc/soc-component.c                          |  63 ++++------
 tools/virtio/Makefile                              |   3 +-
 tools/virtio/linux/spinlock.h                      |  56 +++++++++
 tools/virtio/linux/virtio.h                        |   2 +
 142 files changed, 1181 insertions(+), 641 deletions(-)


