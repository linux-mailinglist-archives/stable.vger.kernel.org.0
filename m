Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1526795E8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390229AbfG2Tqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389666AbfG2Tqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0880820C01;
        Mon, 29 Jul 2019 19:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429607;
        bh=0s4DvMelg6Smp4RLpw6A8ZuXtL4h8E3Gry+9fNvSuQM=;
        h=From:To:Cc:Subject:Date:From;
        b=OEG1GT4TWhGLMbThY0PCWVQwaLHBZ3kTd05lSqjhC3XzupW6ZjdAzm+5ukZi7rqDu
         H8ACnFNYqSpD+myU/Dxpx8SzmsqF+uJX2q8XcOi6SrCObxF6HP9euYCm00ZxIoMEvD
         9vl9hq/0SAjV1Vc6D3ZwXZcy36Qk9x3p+I3eASFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 000/215] 5.2.5-stable review
Date:   Mon, 29 Jul 2019 21:19:56 +0200
Message-Id: <20190729190739.971253303@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.5-rc1
X-KernelTest-Deadline: 2019-07-31T19:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.5 release.
There are 215 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.5-rc1

Jens Axboe <axboe@kernel.dk>
    io_uring: don't use iov_iter_advance() for fixed buffers

Zhengyuan Liu <liuzhengyuan@kylinos.cn>
    io_uring: fix counter inc/dec mismatch in async_list

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure ->list is initialized for poll commands

Zhengyuan Liu <liuzhengyuan@kylinos.cn>
    io_uring: add a memory barrier before atomic_read

Linus Torvalds <torvalds@linux-foundation.org>
    access: avoid the RCU grace period for the temporary subjective credentials

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Make the semaphore saturation mask global

Arnd Bergmann <arnd@arndb.de>
    structleak: disable STRUCTLEAK_BYREF in combination with KASAN_STACK

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/region: Register badblocks before namespaces

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/bus: Prevent duplicate device_unregister() calls

Dan Williams <dan.j.williams@intel.com>
    drivers/base: Introduce kill_device()

Joerg Roedel <jroedel@suse.de>
    iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA

Chris Wilson <chris@chris-wilson.co.uk>
    iommu/iova: Remove stale cached32_node

Dmitry Safonov <dima@arista.com>
    iommu/vt-d: Don't queue_iova() if there is no flush queue

Zhengyuan Liu <liuzhengyuan@kylinos.cn>
    io_uring: fix the sequence comparison in io_sequence_defer

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    powerpc/pmu: Set pmcregs_in_use in paca when running as LPAR

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix oops on sigreturn on systems without TM

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    powerpc/mm: Limit rma_size to 1TB when running without HV mode

Gautham R. Shenoy <ego@linux.vnet.ibm.com>
    powerpc/xive: Fix loop exit-condition in xive_find_target_in_mask()

Shawn Anastasio <shawn@anastas.io>
    powerpc/dma: Fix invalid DMA mmap behavior

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Add a conexant codec entry to let mute led work

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix intermittent CORB/RIRB stall on Intel chips

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix refcount_inc() on zero usage

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ALSA: ac97: Fix double free of ac97_codec_device

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    drm/panel: Add support for Armadeus ST0700 Adapt

Kefeng Wang <wangkefeng.wang@huawei.com>
    hpet: Fix division by zero in hpet_time_div()

Arseny Solokha <asolokha@kb.kras.ru>
    eeprom: make older eeprom drivers select NVMEM_SYSFS

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add mule creek canyon (EHL) device ids

YueHaibing <yuehaibing@huawei.com>
    fpga-manager: altera-ps-spi: Fix build error

Hridya Valsaraju <hridya@google.com>
    binder: prevent transactions to context manager from its own process.

Martijn Coenen <maco@android.com>
    binder: Set end of SG buffer area properly.

Eiichi Tsukata <devel@etsukata.com>
    x86/stacktrace: Prevent access_ok() warnings in arch_stack_walk_user()

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86/speculation/mds: Apply more accurate check on hypervisor platform

Hans de Goede <hdegoede@redhat.com>
    x86/sysfb_efi: Add quirks for some devices with swapped width and height

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: check sidtab limit before adding a new entry

Qu Wenruo <wqu@suse.com>
    btrfs: inode: Don't compress if NODATASUM or NODATACOW set

Hans Verkuil <hverkuil@xs4all.nl>
    media: videodev2.h: change V4L2_PIX_FMT_BGRA444 define: fourcc was already in use

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: fix rollback when kvmppc_xive_create fails

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    KVM: PPC: Book3S HV: Save and restore guest visible PSSCR bits on pseries

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    KVM: PPC: Book3S HV: Always save guest pmu for guest capable of nesting

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: Fix fpu state crash in kvm guest

Lucas Stach <l.stach@pengutronix.de>
    usb: usb251xb: Reallow swap-dx-lanes to apply to the upstream port

Lucas Stach <l.stach@pengutronix.de>
    Revert "usb: usb251xb: Add US port lanes inversion property"

Lucas Stach <l.stach@pengutronix.de>
    Revert "usb: usb251xb: Add US lanes inversion dts-bindings"

Ryan Kennedy <ryan5544@gmail.com>
    usb: pci-quirks: Correct AMD PLL quirk detection

Phong Tran <tranmanphong@gmail.com>
    usb: wusbcore: fix unbalanced get/put cluster_id

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb-storage: Add a limitation for blk_queue_max_hw_sectors()

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix crash if scatter gather is used with Immediate Data Transfer (IDT).

Arnd Bergmann <arnd@arndb.de>
    locking/lockdep: Hide unused 'class' variable

Huang Ying <ying.huang@intel.com>
    mm, swap: fix race between swapoff and some swap operations

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm: use down_read_killable for locking mmap_sem in access_remote_vm

Yuyang Du <duyuyang@gmail.com>
    locking/lockdep: Fix lock used or unused stats error

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/maps

Arnd Bergmann <arnd@arndb.de>
    cxgb4: reduce kernel stack usage in cudbg_collect_mem_region()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/map_files

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/clear_refs

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/pagemap

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/smaps_rollup

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    mm/mmu_notifier: use hlist_add_head_rcu()

Shakeel Butt <shakeelb@google.com>
    memcg, fsnotify: no oom-kill for remote memcg charging

Andy Lutomirski <luto@kernel.org>
    mm/gup.c: remove some BUG_ONs from get_gate_page()

Guenter Roeck <linux@roeck-us.net>
    mm/gup.c: mark undo_dev_pagemap as __maybe_unused

Huang Ying <ying.huang@intel.com>
    mm/mincore.c: fix race between swapoff and mincore

Christoph Hellwig <hch@lst.de>
    9p: pass the correct prototype to read_cache_page

Dmitry Vyukov <dvyukov@google.com>
    mm/kmemleak.c: fix check for softirq context

Sam Ravnborg <sam@ravnborg.org>
    sh: prevent warnings when using iounmap

Minwoo Im <minwoo.im.dev@gmail.com>
    nvme: fix NULL deref for fabrics options

Wenwen Wang <wenwen@cs.uga.edu>
    block/bio-integrity: fix a memory leak bug

YueHaibing <yuehaibing@huawei.com>
    platform/x86: Fix PCENGINES_APU2 Kconfig warning

Oliver O'Halloran <oohall@gmail.com>
    powerpc/eeh: Handle hugepages in ioremap space

David Windsor <dwindsor@redhat.com>
    dlm: check if workqueues are NULL before flushing/destroying

morten petersen <morten_bp@live.dk>
    mailbox: handle failed named mailbox channel request

Ocean Chen <oceanchen@google.com>
    f2fs: avoid out-of-range memory access

Heng Xiao <heng.xiao@unisoc.com>
    f2fs: fix to avoid long latency during umount

Gerd Rausch <gerd.rausch@oracle.com>
    rds: Accept peer connection reject messages due to incompatible version

Josef Bacik <josef@toxicpanda.com>
    block: init flush rq ref count to 1

Masahiro Yamada <yamada.masahiro@socionext.com>
    powerpc/boot: add {get, put}_unaligned_be32 to xz_config.h

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/irq: Don't WARN continuously in arch_local_irq_restore()

Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
    nvme-tcp: set the STABLE_WRITES flag when data digests are enabled

Jackie Liu <liuyun01@kylinos.cn>
    io_uring: fix io_sq_thread_stop running in front of io_sq_thread

Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
    nvme-tcp: don't use sendpage for SLAB pages

Christoph Hellwig <hch@lst.de>
    nvme-pci: limit max_hw_sectors based on the DMA max mapping size

Alan Mikhak <alan.mikhak@sifive.com>
    nvme-pci: check for NULL return from pci_alloc_p2pmem()

Dag Moxnes <dag.moxnes@oracle.com>
    RDMA/core: Fix race when resolving IP address

Leo Yan <leo.yan@linaro.org>
    perf intel-bts: Fix potential NULL pointer dereference found by the smatch tool

YueHaibing <yuehaibing@huawei.com>
    PCI: dwc: pci-dra7xx: Fix compilation when !CONFIG_GPIOLIB

Konstantin Taranov <konstantin.taranov@inf.ethz.ch>
    RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM

Leo Yan <leo.yan@linaro.org>
    perf hists browser: Fix potential NULL pointer dereference found by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf annotate: Fix dereferencing freed memory found by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf map: Fix potential NULL pointer dereference found by smatch tool

Leo Yan <leo.yan@linaro.org>
    perf session: Fix potential NULL pointer dereference found by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf trace: Fix potential NULL pointer dereference found by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf top: Fix potential NULL pointer dereference detected by the smatch tool

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq/selftests: Fix Thumb mode build failure on arm32

Leo Yan <leo.yan@linaro.org>
    perf stat: Fix use-after-freed pointer detected by the smatch tool

Numfor Mbiziwo-Tiapo <nums@google.com>
    perf test mmap-thread-lookup: Initialize variable to suppress memory sanitizer warning

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Use the 1st inbound window for MEM inbound transactions

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Initialize Primary/Secondary/Subordinate bus numbers

Vasily Gorbik <gor@linux.ibm.com>
    kallsyms: exclude kasan local symbols on s390

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Fix the Class Code field

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Fix PCI base address in MEM/IO outbound windows

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Stash L1's CR3 in vmcs01.GUEST_CR3 on nested entry w/o EPT

James Morse <james.morse@arm.com>
    arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM64_HAS_RAS

Valentine Fatiev <valentinef@mellanox.com>
    IB/ipoib: Add child to parent list only if device initialized

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm: Handle page table allocation failures

Parav Pandit <parav@mellanox.com>
    IB/mlx5: Fixed reporting counters on 2nd port for Dual port RoCE

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Fix TX DMA buffer flushing and workqueue races

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Terminate TX DMA during buffer flushing

Liu, Changcheng <changcheng.liu@intel.com>
    RDMA/i40iw: Set queue pair state when being queried

Masahiro Yamada <yamada.masahiro@socionext.com>
    powerpc/mm: mark more tlb functions as __always_inline

Christian Lamparter <chunkeey@gmail.com>
    powerpc/4xx/uic: clear pending interrupt after irq type/pol change

Mathieu Malaterre <malat@debian.org>
    powerpc: silence a -Wcast-function-type warning in dawr_write_file_bool

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: fix is_idle() check for discard type

Johannes Berg <johannes.berg@intel.com>
    um: Silence lockdep complaint about mmap_sem

Ira Weiny <ira.weiny@intel.com>
    mm/swap: fix release_pages() when releasing devmap pages

Axel Lin <axel.lin@ingics.com>
    mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init_mmio_clk

Arnd Bergmann <arnd@arndb.de>
    mfd: arizona: Fix undefined behavior

Robert Hancock <hancock@sedsystems.ca>
    mfd: core: Set fwnode for created devices

Daniel Gomez <dagmcr@gmail.com>
    mfd: madera: Add missing of table registration

Gwendal Grignou <gwendal@chromium.org>
    mfd: cros_ec: Register cros_ec_lid_angle driver when presented

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    recordmcount: Fix spurious mcount entries on powerpc

Masahiro Yamada <yamada.masahiro@socionext.com>
    fixdep: check return value of printf() and putchar()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: retry when cpu offline races with suspend/migration

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/xmon: Fix disabling tracing while in xmon

Qian Cai <cai@lca.pw>
    powerpc/cacheflush: fix variable set but not used

Brian Masney <masneyb@onstation.org>
    dt-bindings: backlight: lm3630a: correct schema validation

Bastien Nocera <hadess@hadess.net>
    iio: iio-utils: Fix possible incorrect mask calculation

Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
    PCI: xilinx-nwl: Fix Multi MSI data programming

Neil Armstrong <narmstrong@baylibre.com>
    phy: meson-g12a-usb3-pcie: disable locking for cr_regmap

Will Deacon <will@kernel.org>
    genksyms: Teach parser about 128-bit built-in types

Nathan Chancellor <natechancellor@gmail.com>
    kbuild: Add -Werror=unknown-warning-option to CLANG_FLAGS

Nathan Huckleberry <nhuck@google.com>
    net/ipv4: fib_trie: Avoid cryptic ternary expressions

Fabrice Gasnier <fabrice.gasnier@st.com>
    i2c: stm32f7: fix the get_irq error cases

Marek Vasut <marek.vasut+renesas@gmail.com>
    PCI: sysfs: Ignore lockdep for remove attribute

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: fix imbalance powered flag

Stefan Roese <sr@denx.de>
    serial: mctrl_gpio: Check if GPIO property exisits before requesting it

Sean Paul <seanpaul@chromium.org>
    drm/msm: Depopulate platform on probe failure

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pci/of: Fix OF flags parsing for 64bit BARs

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm/adreno: Ensure that the zap shader region is big enough

Eugene Korenevsky <ekorenevsky@gmail.com>
    kvm: vmx: segment limit check: use access length

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Intercept VMWRITEs to GUEST_{CS,SS}_AR_BYTES

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci: sdhci-pci-o2micro: Check if controller supports 8-bit width

Eugene Korenevsky <ekorenevsky@gmail.com>
    kvm: vmx: fix limit checking in get_vmx_mem_address()

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    usb: dwc3: Fix core validation in probe, move after clocks are enabled

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    usb: gadget: Zero ffs_io_data

Serge Semin <fancer.lancer@gmail.com>
    tty: serial_core: Set port active bit in uart_port_activate

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    serial: uartps: Use the same dynamic major number for all ports

Sergey Organov <sorganov@gmail.com>
    serial: imx: fix locking in set_termios()

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: adxl372: fix iio_triggered_buffer_{pre,post}enable positions

Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>
    platform/x86: asus-wmi: Increase input buffer size of WMI methods

Douglas Anderson <dianders@chromium.org>
    drm/rockchip: Properly adjust to a true clock in adjusted_mode

Florian Fainelli <f.fainelli@gmail.com>
    dma-remap: Avoid de-referencing NULL atomic_pool

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: prevent cpu hotplug during DT update

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/bridge: tfp410: fix use of cancel_delayed_work_sync

John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    sunhv: Fix device naming inconsistency between sunhv_console and sunhv_reg

Hariprasad Kelam <hariprasad.kelam@gmail.com>
    drm/amd/display: fix compilation error

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen2: Fix memory leak at error paths

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: set link->dongle_max_pix_clk to 0 on a disconnect

David Riley <davidriley@chromium.org>
    drm/virtio: Add memory barriers for capset cache.

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Update link rate from DPCD 10

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Always allocate initial connector state state

Alan Mikhak <alan.mikhak@sifive.com>
    PCI: endpoint: Allocate enough space for fixed size BAR

Rautkoski Kimmo EXT <ext-kimmo.rautkoski@vaisala.com>
    serial: 8250: Fix TX interrupt handling condition

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    tty: serial: msm_serial: avoid system lockup condition

Kefeng Wang <wangkefeng.wang@huawei.com>
    tty/serial: digicolor: Fix digicolor-usart already registered warning

Wang Hai <wanghai26@huawei.com>
    memstick: Fix error cleanup path of memstick_init

Sebastian Reichel <sebastian.reichel@collabora.com>
    drm/omap: don't check dispc timings for DSI

Jason Gunthorpe <jgg@ziepe.ca>
    mm/hmm: fix use after free with struct hmm in the mmu notifiers

Ajay Gupta <ajayg@nvidia.com>
    i2c: nvidia-gpu: resume ccgx i2c client

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/vkms: Forward timer right after drm_crtc_handle_vblank

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/crc-debugfs: Also sprinkle irqrestore over early exits

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Increase maximum DMA segment size

Daniel Rosenberg <drosen@google.com>
    f2fs: Lower threshold for disable_cp_again

Daniel Rosenberg <drosen@google.com>
    f2fs: Fix accounting for unusable blocks

Eryk Brol <eryk.brol@amd.com>
    drm/amd/display: Increase Backlight Gain Step Size

Krunoslav Kovac <Krunoslav.Kovac@amd.com>
    drm/amd/display: CS_TFM_1D only applied post EOTF

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Reset planes for color management changes

Jyri Sarha <jsarha@ti.com>
    drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/bridge: tc358767: read display_props in get_modes()

Mao Wenan <maowenan@huawei.com>
    staging: kpc2000: report error status to spi core

Alex Williamson <alex.williamson@redhat.com>
    PCI: Return error if cannot probe VF

Alan Mikhak <alan.mikhak@sifive.com>
    tools: PCI: Fix broken pcitest compilation

Gen Zhang <blackgod016574@gmail.com>
    drm/edid: Fix a missing-check bug in drm_load_edid_firmware()

Oak Zeng <Oak.Zeng@amd.com>
    drm/amdkfd: Fix sdma queue map issue

Oak Zeng <ozeng@amd.com>
    drm/amdkfd: Fix a potential memory leak

Paul Hsieh <paul.hsieh@amd.com>
    drm/amd/display: Disable ABM before destroy ABM struct

Tiecheng Zhou <Tiecheng.Zhou@amd.com>
    drm/amdgpu/sriov: Need to initialize the HDP_NONSURFACE_BAStE

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid deadloop if data_flush is on

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdgpu: Reserve shared fence for eviction fence

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fill plane attrs only for valid pxl format

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Disable cursor when offscreen in negative direction

Sean Paul <seanpaul@chromium.org>
    drm/msm/a6xx: Avoid freeing gmu resources multiple times

Anthony Koo <anthony.koo@amd.com>
    drm/amd/display: fix multi display seamless boot case

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fill prescale_params->scale for RGB565

Kefeng Wang <wangkefeng.wang@huawei.com>
    ipmi_ssif: fix unexpected driver unregister warning

Sean Paul <seanpaul@chromium.org>
    drm/msm/a6xx: Check for ERR or NULL before iounmap

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to check layout on last valid checkpoint park

Christophe Leroy <christophe.leroy@c-s.fr>
    tty: serial: cpm_uart - fix init when SMC is relocated

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: rockchip: fix leaked of_node references

Serge Semin <fancer.lancer@gmail.com>
    tty: max310x: Fix invalid baudrate divisors calculator

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: core: hub: Disable hub-initiated U1/U2

Sam Bobroff <sbobroff@linux.ibm.com>
    drm/bochs: Fix connector leak during driver unload

Quentin Deslandes <quentin.deslandes@itdev.co.uk>
    staging: vt6656: use meaningful error code during buffer allocation

Kefeng Wang <wangkefeng.wang@huawei.com>
    ipmi_si: fix unexpected driver unregister warning

Jeremy Sowden <jeremy@azazel.net>
    staging: kpc2000: added missing clean-up to probe_core_uio.

Chia-I Wu <olvaffe@gmail.com>
    drm/virtio: set seqno for dma-fence

Fabien Dessenne <fabien.dessenne@st.com>
    iio: adc: stm32-dfsdm: missing error case during probe

Fabien Dessenne <fabien.dessenne@st.com>
    iio: adc: stm32-dfsdm: manage the get_irq error case

Peter Ujfalusi <peter.ujfalusi@ti.com>
    drm/panel: simple: Fix panel_simple_dsi_probe

Peter Griffin <peter.griffin@linaro.org>
    drm/lima: handle shared irq case for lima_pp_bcast_irq_handler

Arnd Bergmann <arnd@arndb.de>
    btrfs: shut up bogus -Wmaybe-uninitialized warning

Anders Roxell <anders.roxell@linaro.org>
    media: drivers: media: coda: fix warning same module names

Anders Roxell <anders.roxell@linaro.org>
    regulator: 88pm800: fix warning same module names


-------------

Diffstat:

 .../display/panel/armadeus,st0700-adapt.txt        |   9 ++
 .../bindings/leds/backlight/lm3630a-backlight.yaml |  21 ++-
 Documentation/devicetree/bindings/usb/usb251xb.txt |   6 +-
 Makefile                                           |   5 +-
 arch/arm64/include/asm/assembler.h                 |   4 +
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/boot/xz_config.h                      |  20 +++
 arch/powerpc/include/asm/cacheflush.h              |   7 +-
 arch/powerpc/include/asm/pmc.h                     |   5 +-
 arch/powerpc/kernel/Makefile                       |   3 +-
 arch/powerpc/kernel/dma-common.c                   |  17 +++
 arch/powerpc/kernel/eeh.c                          |  15 +-
 arch/powerpc/kernel/hw_breakpoint.c                |   7 +-
 arch/powerpc/kernel/irq.c                          |   6 +-
 arch/powerpc/kernel/pci_of_scan.c                  |   2 +
 arch/powerpc/kernel/rtas.c                         |   7 +-
 arch/powerpc/kernel/signal_32.c                    |   3 +
 arch/powerpc/kernel/signal_64.c                    |   5 +
 arch/powerpc/kvm/book3s_hv.c                       |  13 ++
 arch/powerpc/kvm/book3s_xive.c                     |   4 +-
 arch/powerpc/kvm/book3s_xive_native.c              |   4 +-
 arch/powerpc/mm/book3s64/hash_native.c             |   2 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |   9 ++
 arch/powerpc/mm/book3s64/radix_tlb.c               |  32 ++---
 arch/powerpc/mm/hugetlbpage.c                      |   8 ++
 arch/powerpc/platforms/4xx/uic.c                   |   1 +
 arch/powerpc/platforms/pseries/mobility.c          |   9 ++
 arch/powerpc/sysdev/xive/common.c                  |   7 +-
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/sh/include/asm/io.h                           |   6 +-
 arch/um/include/asm/mmu_context.h                  |   2 +-
 arch/x86/include/uapi/asm/vmx.h                    |   1 -
 arch/x86/kernel/cpu/bugs.c                         |   2 +-
 arch/x86/kernel/stacktrace.c                       |   2 +-
 arch/x86/kernel/sysfb_efi.c                        |  46 ++++++
 arch/x86/kvm/vmx/nested.c                          |  87 +++++++-----
 arch/x86/kvm/vmx/nested.h                          |   2 +-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h              |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |   3 +-
 arch/x86/kvm/x86.c                                 |   9 +-
 block/bio-integrity.c                              |   8 +-
 block/blk-core.c                                   |   1 +
 drivers/android/binder.c                           |   5 +-
 drivers/base/core.c                                |  27 ++--
 drivers/char/hpet.c                                |   3 +-
 drivers/char/ipmi/ipmi_si_platform.c               |   6 +-
 drivers/char/ipmi/ipmi_ssif.c                      |   5 +-
 drivers/fpga/Kconfig                               |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   4 +
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   3 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  21 +--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  30 ++--
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  14 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   6 +
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   9 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c       |   2 +
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c      |   3 +
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h      |   2 +
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |   3 +
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   1 +
 .../drm/amd/display/modules/color/color_gamma.c    |   3 +-
 drivers/gpu/drm/bochs/bochs_drv.c                  |   2 +
 drivers/gpu/drm/bridge/sii902x.c                   |   5 +-
 drivers/gpu/drm/bridge/tc358767.c                  |   7 +
 drivers/gpu/drm/bridge/ti-tfp410.c                 |   3 +-
 drivers/gpu/drm/drm_debugfs_crc.c                  |   9 +-
 drivers/gpu/drm/drm_edid_load.c                    |   2 +
 drivers/gpu/drm/i915/i915_request.c                |   4 +-
 drivers/gpu/drm/i915/intel_context.c               |   1 -
 drivers/gpu/drm/i915/intel_context_types.h         |   2 -
 drivers/gpu/drm/i915/intel_engine_cs.c             |   1 +
 drivers/gpu/drm/i915/intel_engine_types.h          |   2 +
 drivers/gpu/drm/lima/lima_pp.c                     |   8 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  20 ++-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h              |   1 +
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   8 +-
 drivers/gpu/drm/msm/msm_drv.c                      |  14 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c                |  18 ++-
 drivers/gpu/drm/panel/panel-simple.c               |  38 ++++-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   3 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   1 -
 drivers/gpu/drm/virtio/virtgpu_fence.c             |  17 ++-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   3 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   2 +
 drivers/gpu/drm/vkms/vkms_crtc.c                   |  22 ++-
 drivers/gpu/host1x/bus.c                           |   3 +
 drivers/i2c/busses/i2c-nvidia-gpu.c                |  14 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  26 ++--
 drivers/iio/accel/adxl372.c                        |  27 ++--
 drivers/iio/adc/stm32-dfsdm-adc.c                  |   6 +
 drivers/iio/adc/stm32-dfsdm-core.c                 |   8 +-
 drivers/infiniband/core/addr.c                     |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |   2 +
 drivers/infiniband/hw/mlx5/mad.c                   |  60 ++++----
 drivers/infiniband/sw/rxe/rxe_resp.c               |   5 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  34 +++--
 drivers/iommu/intel-iommu.c                        |   3 +-
 drivers/iommu/iova.c                               |  23 ++-
 drivers/mailbox/mailbox.c                          |   6 +-
 drivers/media/platform/coda/Makefile               |   4 +-
 drivers/memstick/core/memstick.c                   |  13 +-
 drivers/mfd/arizona-core.c                         |   2 +-
 drivers/mfd/cros_ec_dev.c                          |  13 +-
 drivers/mfd/hi655x-pmic.c                          |   2 +
 drivers/mfd/madera-core.c                          |   1 +
 drivers/mfd/mfd-core.c                             |   1 +
 drivers/misc/eeprom/Kconfig                        |   3 +
 drivers/misc/mei/hw-me-regs.h                      |   3 +
 drivers/misc/mei/pci-me.c                          |   3 +
 drivers/mmc/host/sdhci-pci-o2micro.c               |  12 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  19 ++-
 drivers/nvdimm/bus.c                               | 121 +++++++++++-----
 drivers/nvdimm/nd-core.h                           |   3 +-
 drivers/nvdimm/region.c                            |  22 +--
 drivers/nvme/host/core.c                           |   5 +
 drivers/nvme/host/pci.c                            |  17 ++-
 drivers/nvme/host/tcp.c                            |   9 +-
 drivers/pci/controller/dwc/pci-dra7xx.c            |   1 +
 drivers/pci/controller/pcie-mobiveil.c             |  22 ++-
 drivers/pci/controller/pcie-xilinx-nwl.c           |  11 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   8 +-
 drivers/pci/pci-driver.c                           |  13 +-
 drivers/pci/pci-sysfs.c                            |   2 +-
 drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c     |   2 +-
 drivers/phy/renesas/phy-rcar-gen2.c                |   2 +
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  19 ++-
 drivers/pinctrl/pinctrl-rockchip.c                 |   1 +
 drivers/platform/x86/Kconfig                       |   2 +-
 drivers/platform/x86/asus-wmi.c                    |  10 +-
 .../regulator/{88pm800.c => 88pm800-regulator.c}   |   0
 drivers/regulator/Makefile                         |   2 +-
 drivers/staging/kpc2000/TODO                       |   1 -
 drivers/staging/kpc2000/kpc2000/cell_probe.c       |   3 +
 drivers/staging/kpc2000/kpc_spi/spi_driver.c       |   8 +-
 drivers/staging/vt6656/main_usb.c                  |  42 ++++--
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |  17 ++-
 drivers/tty/serial/digicolor-usart.c               |   6 +-
 drivers/tty/serial/imx.c                           |  23 +--
 drivers/tty/serial/max310x.c                       |  51 ++++---
 drivers/tty/serial/msm_serial.c                    |   4 +
 drivers/tty/serial/serial_core.c                   |   7 +-
 drivers/tty/serial/serial_mctrl_gpio.c             |  14 ++
 drivers/tty/serial/sh-sci.c                        |  33 +++--
 drivers/tty/serial/sunhv.c                         |   2 +-
 drivers/tty/serial/xilinx_uartps.c                 |   5 +-
 drivers/usb/core/hub.c                             |  28 ++--
 drivers/usb/dwc3/core.c                            |  12 +-
 drivers/usb/gadget/function/f_fs.c                 |   6 +-
 drivers/usb/host/hwa-hc.c                          |   2 +-
 drivers/usb/host/pci-quirks.c                      |  31 +++--
 drivers/usb/host/xhci.h                            |   3 +-
 drivers/usb/misc/usb251xb.c                        |  15 +-
 drivers/usb/storage/scsiglue.c                     |  11 ++
 fs/9p/vfs_addr.c                                   |   6 +-
 fs/btrfs/inode.c                                   |  24 +++-
 fs/btrfs/props.c                                   |   2 +-
 fs/dlm/lowcomms.c                                  |  18 ++-
 fs/f2fs/checkpoint.c                               |  11 --
 fs/f2fs/data.c                                     |   3 +
 fs/f2fs/f2fs.h                                     |  18 ++-
 fs/f2fs/segment.c                                  |  21 ++-
 fs/f2fs/super.c                                    |  10 ++
 fs/io_uring.c                                      |  60 +++++++-
 fs/notify/fanotify/fanotify.c                      |   5 +-
 fs/notify/inotify/inotify_fsnotify.c               |   8 +-
 fs/open.c                                          |  19 +++
 fs/proc/base.c                                     |  28 +++-
 fs/proc/task_mmu.c                                 |  23 ++-
 fs/proc/task_nommu.c                               |   6 +-
 include/linux/cred.h                               |   8 +-
 include/linux/device.h                             |   1 +
 include/linux/hmm.h                                |   1 +
 include/linux/host1x.h                             |   2 +
 include/linux/iova.h                               |   6 +
 include/linux/swap.h                               |  13 +-
 include/uapi/linux/videodev2.h                     |   8 +-
 kernel/cred.c                                      |  21 ++-
 kernel/dma/remap.c                                 |   3 +
 kernel/locking/lockdep_proc.c                      |   8 +-
 mm/gup.c                                           |  12 +-
 mm/hmm.c                                           |  23 ++-
 mm/kmemleak.c                                      |   2 +-
 mm/memory.c                                        |   6 +-
 mm/mincore.c                                       |  12 +-
 mm/mmu_notifier.c                                  |   2 +-
 mm/nommu.c                                         |   3 +-
 mm/swap.c                                          |  13 +-
 mm/swap_state.c                                    |  16 ++-
 mm/swapfile.c                                      | 154 ++++++++++++++++-----
 net/rds/rdma_transport.c                           |   5 +-
 scripts/Makefile.extrawarn                         |   1 -
 scripts/basic/fixdep.c                             |  51 +++++--
 scripts/genksyms/keywords.c                        |   4 +
 scripts/genksyms/parse.y                           |   2 +
 scripts/kallsyms.c                                 |   3 +
 scripts/recordmcount.h                             |   3 +-
 security/Kconfig.hardening                         |   7 +
 security/selinux/ss/sidtab.c                       |   5 +
 sound/ac97/bus.c                                   |  13 +-
 sound/core/pcm_native.c                            |   9 +-
 sound/pci/hda/hda_intel.c                          |   5 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/usb/line6/podhd.c                            |   2 +-
 tools/iio/iio_utils.c                              |   4 +-
 tools/pci/pcitest.c                                |   6 +-
 tools/perf/builtin-stat.c                          |   2 +-
 tools/perf/builtin-top.c                           |   8 +-
 tools/perf/builtin-trace.c                         |   6 +-
 tools/perf/tests/mmap-thread-lookup.c              |   2 +-
 tools/perf/ui/browsers/hists.c                     |  15 +-
 tools/perf/util/annotate.c                         |   6 +-
 tools/perf/util/intel-bts.c                        |   5 +-
 tools/perf/util/map.c                              |   7 +-
 tools/perf/util/session.c                          |   3 +
 tools/testing/selftests/rseq/rseq-arm.h            |  61 ++++----
 218 files changed, 1785 insertions(+), 679 deletions(-)


