Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D78696CC3
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjBNSZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbjBNSZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:25:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913582BF2C;
        Tue, 14 Feb 2023 10:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D82D61825;
        Tue, 14 Feb 2023 18:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A631C433EF;
        Tue, 14 Feb 2023 18:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676399108;
        bh=oGnca+6biImNHoEP6nA9NN/d8Tt2d5vA/RzWmCsu9iE=;
        h=From:To:Cc:Subject:Date:From;
        b=QX88y1t/GDAi4mGI/bKMANopFd0R0M2bw6d/CEiFvep5XMq576NSIY5I3ngJsWwDM
         14gSluqQYUS6MLyE4vReXJwFHD1xrCPQAcQQFqgan4o5PJi87brjf5W41vkcEnb8dq
         pVW1mG5zSP5zXekciuD0iVo6QN1a+J6es+3lZXIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.12
Date:   Tue, 14 Feb 2023 19:25:04 +0100
Message-Id: <167639910576204@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.12 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst             |   92 +++++++
 Documentation/admin-guide/hw-vuln/index.rst                        |    1 
 Makefile                                                           |    2 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                         |    4 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi                  |    6 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                          |    6 
 arch/arm64/boot/dts/mediatek/mt8195.dtsi                           |    4 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                           |    2 
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts                    |    2 
 arch/powerpc/kernel/interrupt.c                                    |    6 
 arch/riscv/kernel/probes/kprobes.c                                 |    8 
 arch/riscv/kernel/stacktrace.c                                     |    3 
 arch/riscv/mm/cacheflush.c                                         |    4 
 arch/x86/include/asm/cpufeatures.h                                 |    1 
 arch/x86/kernel/cpu/common.c                                       |    9 
 arch/x86/kvm/x86.c                                                 |   43 ++-
 drivers/clk/ingenic/jz4760-cgu.c                                   |   18 -
 drivers/clk/microchip/clk-mpfs-ccc.c                               |   10 
 drivers/cpufreq/qcom-cpufreq-hw.c                                  |   24 -
 drivers/cxl/core/region.c                                          |   12 
 drivers/firmware/efi/libstub/arm64-stub.c                          |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c                          |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c                          |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                  |   42 ++-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c          |    2 
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                                 |    2 
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h |    5 
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h |   29 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                       |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c               |    6 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c               |    1 
 drivers/gpu/drm/i915/display/intel_bios.c                          |   33 +-
 drivers/gpu/drm/i915/display/skl_watermark.c                       |    3 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c                     |   14 -
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c                          |    2 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                             |    5 
 drivers/hid/amd-sfh-hid/amd_sfh_client.c                           |   13 
 drivers/hid/amd-sfh-hid/amd_sfh_hid.h                              |    1 
 drivers/hid/hid-logitech-hidpp.c                                   |    3 
 drivers/infiniband/hw/hfi1/file_ops.c                              |    7 
 drivers/infiniband/hw/irdma/cm.c                                   |    3 
 drivers/infiniband/hw/usnic/usnic_uiom.c                           |    8 
 drivers/infiniband/ulp/ipoib/ipoib_main.c                          |    8 
 drivers/net/bonding/bond_debugfs.c                                 |    2 
 drivers/net/dsa/mt7530.c                                           |   26 +
 drivers/net/ethernet/cadence/macb_main.c                           |   31 +-
 drivers/net/ethernet/intel/ice/ice_main.c                          |    2 
 drivers/net/ethernet/intel/ice/ice_switch.c                        |    2 
 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c               |   16 +
 drivers/net/ethernet/intel/igc/igc_main.c                          |   25 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                        |    4 
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c                  |    5 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c           |    3 
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c            |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c                    |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                  |   90 +-----
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c               |    2 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c            |   13 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                     |   14 -
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                |   37 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c                    |    2 
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c                 |    4 
 drivers/net/ethernet/mscc/ocelot_flower.c                          |   24 -
 drivers/net/ethernet/mscc/ocelot_ptp.c                             |    8 
 drivers/net/ethernet/pensando/ionic/ionic_dev.c                    |    9 
 drivers/net/ethernet/pensando/ionic/ionic_dev.h                    |   12 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                    |   56 +++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h                    |    2 
 drivers/net/ethernet/pensando/ionic/ionic_main.c                   |   29 ++
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c                   |  110 +++++++-
 drivers/net/hyperv/netvsc.c                                        |    2 
 drivers/net/phy/meson-gxl.c                                        |    2 
 drivers/net/phy/phylink.c                                          |    5 
 drivers/net/usb/plusb.c                                            |    4 
 drivers/nvdimm/Kconfig                                             |   19 +
 drivers/nvdimm/nd.h                                                |    2 
 drivers/nvdimm/pfn_devs.c                                          |   42 ++-
 drivers/of/address.c                                               |   21 +
 drivers/of/platform.c                                              |   12 
 drivers/pci/pci.c                                                  |    7 
 drivers/pci/pci.h                                                  |    4 
 drivers/pci/pcie/aspm.c                                            |  111 ++------
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                            |   13 
 drivers/pinctrl/intel/pinctrl-intel.c                              |   16 -
 drivers/pinctrl/mediatek/pinctrl-mt8195.c                          |    4 
 drivers/pinctrl/pinctrl-single.c                                   |    2 
 drivers/pinctrl/qcom/pinctrl-sm8450-lpass-lpi.c                    |    2 
 drivers/spi/spi-dw-core.c                                          |    2 
 drivers/usb/core/quirks.c                                          |    3 
 drivers/usb/typec/altmodes/displayport.c                           |    8 
 drivers/video/fbdev/nvidia/nvidia.c                                |   81 +++---
 fs/btrfs/tree-log.c                                                |   23 +
 fs/btrfs/tree-log.h                                                |    2 
 fs/btrfs/volumes.c                                                 |   22 +
 fs/btrfs/zlib.c                                                    |    2 
 fs/ceph/mds_client.c                                               |    6 
 fs/cifs/file.c                                                     |    4 
 include/linux/mlx5/driver.h                                        |   13 
 include/linux/trace_events.h                                       |    1 
 include/trace/stages/stage4_event_fields.h                         |    3 
 include/uapi/drm/virtgpu_drm.h                                     |    1 
 include/uapi/linux/ip.h                                            |    1 
 include/uapi/linux/ipv6.h                                          |    1 
 kernel/cgroup/cpuset.c                                             |   18 -
 kernel/locking/rtmutex.c                                           |    5 
 kernel/trace/trace.c                                               |    3 
 kernel/trace/trace.h                                               |    1 
 kernel/trace/trace_events.c                                        |   39 ++
 kernel/trace/trace_export.c                                        |    3 
 mm/page_alloc.c                                                    |    5 
 net/can/j1939/address-claim.c                                      |   40 +++
 net/core/sock.c                                                    |    3 
 net/ipv4/af_inet.c                                                 |    1 
 net/ipv4/inet_connection_sock.c                                    |    3 
 net/ipv6/af_inet6.c                                                |    1 
 net/mptcp/protocol.c                                               |    9 
 net/mptcp/subflow.c                                                |   10 
 net/rds/message.c                                                  |    6 
 net/xfrm/xfrm_compat.c                                             |    4 
 net/xfrm/xfrm_input.c                                              |    3 
 net/xfrm/xfrm_policy.c                                             |   11 
 net/xfrm/xfrm_state.c                                              |   10 
 sound/pci/hda/patch_realtek.c                                      |    9 
 sound/pci/lx6464es/lx_core.c                                       |   11 
 sound/soc/codecs/tas5805m.c                                        |  131 ++++++----
 sound/soc/fsl/fsl_sai.c                                            |    1 
 sound/soc/soc-topology.c                                           |    8 
 sound/synth/emux/emux_nrpn.c                                       |    3 
 tools/testing/selftests/net/forwarding/lib.sh                      |    4 
 tools/testing/selftests/net/mptcp/mptcp_join.sh                    |   22 +
 tools/testing/selftests/net/test_vxlan_vnifiltering.sh             |   18 -
 132 files changed, 1211 insertions(+), 615 deletions(-)

Adham Faris (1):
      net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change

Alan Stern (1):
      net: USB: Fix wrong-direction WARNING in plusb.c

Alex Deucher (1):
      drm/amd/display: properly handling AGP aperture in vm setup

Alexander Potapenko (1):
      btrfs: zlib: zero-initialize zlib workspace

Allen Hubbe (1):
      ionic: missed doorbell workaround

Amadeusz Sławiński (1):
      ASoC: topology: Return -ENOMEM on memory allocation failure

Amir Tzin (1):
      net/mlx5e: Fix crash unsetting rx-vlan-filter in switchdev mode

Anand Jain (1):
      btrfs: free device in btrfs_close_devices for a single device filesystem

Anastasia Belova (1):
      xfrm: compat: change expression for switch in xfrm_xlate64

Andy Chi (1):
      ALSA: hda/realtek: fix mute/micmute LEDs don't work for a HP platform.

Andy Shevchenko (1):
      pinctrl: intel: Restore the pins that used to be in Direct IRQ mode

Anirudh Venkataramanan (1):
      ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Aravind Iddamsetty (1):
      drm/i915: Initialize the obj flags for shmem objects

Arnaud Ferraris (1):
      arm64: dts: rockchip: fix input enable pinconf on rk3399

Artemii Karasev (1):
      ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Bastien Nocera (1):
      HID: logitech: Disable hi-res scrolling on USB

Bjorn Helgaas (2):
      Revert "PCI/ASPM: Save L1 PM Substates Capability for suspend/resume"
      Revert "PCI/ASPM: Refactor L1 PM Substates Control Register programming"

Brett Creeley (1):
      ice: Fix disabling Rx VLAN filtering with port VLAN enabled

Casper Andersson (1):
      net: microchip: sparx5: fix PTP init/deinit not checking all ports

Chen-Yu Tsai (1):
      arm64: dts: mediatek: mt8195: Fix vdosys* compatible strings

Christian Hopps (1):
      xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Clément Léger (1):
      net: phylink: move phy_device_free() to correctly release phy device

Dan Carpenter (1):
      ALSA: pci: lx6464es: fix a debug loop

Dan Johansen (1):
      arm64: dts: rockchip: set sdmmc0 speed to sd-uhs-sdr50 on rock-3a

Dan Williams (2):
      cxl/region: Fix passthrough-decoder detection
      nvdimm: Support sizeof(struct page) > MAX_STRUCT_PAGE_SIZE

Daniel Beer (2):
      ASoC: tas5805m: rework to avoid scheduling while atomic.
      ASoC: tas5805m: add missing page switch.

Darren Hart (1):
      arm64: efi: Force the use of SetVirtualAddressMap() on eMAG and Altra Max machines

Dave Airlie (1):
      nvidiafb: detect the hardware support before removing console.

David Chen (1):
      Fix page corruption caused by racy check in __free_pages

Dean Luick (1):
      IB/hfi1: Restore allocated resources on failed copyout

Devid Antonio Filoni (1):
      can: j1939: do not wait 250 ms if the same addr was already claimed

Douglas Anderson (1):
      cpufreq: qcom-hw: Fix cpufreq_driver->get() for non-LMH systems

Dragos Tatulea (2):
      IB/IPoIB: Fix legacy IPoIB due to wrong number of queues
      net/mlx5e: IPoIB, Show unknown speed instead of error

Edson Juliano Drosdeck (1):
      ALSA: hda/realtek: Add Positivo N14KP6-TG

Elvis Angelaccio (1):
      ALSA: hda/realtek: Enable mute/micmute LEDs on HP Elitebook, 645 G9

Eric Dumazet (2):
      xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()
      xfrm: annotate data-race around use_time

Evan Quan (3):
      drm/amd/pm: add SMU 13.0.7 missing GetPptLimit message mapping
      drm/amd/pm: bump SMU 13.0.0 driver_if header version
      drm/amd/pm: bump SMU 13.0.7 driver_if header version

Fan Ni (1):
      cxl/region: Fix null pointer dereference for resetting decoder

Filipe Manana (1):
      btrfs: simplify update of last_dir_index_offset when logging a directory

Friedrich Vock (1):
      drm/amdgpu: Use the TGID for trace_amdgpu_vm_update_ptes

Geert Uytterhoeven (1):
      clk: microchip: mpfs-ccc: Use devm_kasprintf() for allocating formatted strings

Greg Kroah-Hartman (1):
      Linux 6.1.12

Guilherme G. Piccoli (1):
      drm/amdgpu/fence: Fix oops due to non-matching drm_sched init/fini

Guillaume Pinot (1):
      ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro 360

Guo Ren (2):
      riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte
      riscv: kprobe: Fixup misaligned load text

Guodong Liu (1):
      pinctrl: mediatek: Fix the drive register definition of some Pins

Hangbin Liu (1):
      selftests: forwarding: lib: quote the sysctl values

Heiner Kallweit (4):
      net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY
      arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive
      arm64: dts: meson-g12-common: Make mmc host controller interrupts level-sensitive
      arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive

Herton R. Krzesinski (1):
      uapi: add missing ip/ipv6 header dependencies for linux/stddef.h

Ido Schimmel (1):
      selftests: Fix failing VXLAN VNI filtering test

Jane Jian (1):
      drm/amdgpu/smu: skip pptable init under sriov

Joel Stanley (2):
      pinctrl: aspeed: Fix confusing types in return value
      pinctrl: aspeed: Revert "Force to disable the function's signal"

Josef Bacik (1):
      btrfs: limit device extents to the device size

Kent Russell (1):
      drm/amdgpu: Add unique_id support for GC 11.0.1/2

Kevin Yang (1):
      txhash: fix sk->sk_txrehash default

Krzysztof Kozlowski (1):
      pinctrl: qcom: sm8450-lpass-lpi: correct swr_rx_data group

Liu Shixin (1):
      riscv: stacktrace: Fix missing the first frame

Maher Sanalla (2):
      net/mlx5: Store page counters in a single array
      net/mlx5: Expose SF firmware pages counter

Mario Limonciello (1):
      HID: amd_sfh: if no sensors are enabled, clean up

Mark Brown (1):
      of/address: Return an error when no valid dma-ranges are found

Mark Pearson (1):
      usb: core: add quirk for Alcor Link AK9563 smartcard reader

Matthieu Baerts (1):
      selftests: mptcp: stop tests earlier

Maxim Korotkov (1):
      pinctrl: single: fix potential NULL dereference

Melissa Wen (1):
      drm/amd/display: fix cursor offset on rotation 180

Michael Kelley (1):
      hv_netvsc: Allocate memory in netvsc_dma_map() with GFP_ATOMIC

Michal Suchanek (1):
      of: Make OF framebuffer device names unique

Neel Patel (2):
      ionic: clean interrupt before enabling queue to avoid credit race
      ionic: refactor use of ionic_rx_fill()

Nicholas Piggin (1):
      powerpc/64s/interrupt: Fix interrupt exit race with security mitigation switch

Nikita Zhandarovich (1):
      RDMA/irdma: Fix potential NULL-ptr-dereference

Paolo Abeni (3):
      mptcp: do not wait for bare sockets' timeout
      mptcp: be careful on subflow status propagation on errors
      selftests: mptcp: allow more slack for slow test-case

Paul Cercueil (1):
      clk: ingenic: jz4760: Update M/N/OD calculation algorithm

Pietro Borrello (1):
      rds: rds_rm_zerocopy_callback() use list_first_entry()

Prashant Malani (1):
      usb: typec: altmodes/displayport: Fix probe pin assign check

Qi Zheng (1):
      bonding: fix error checking in bond_debug_reregister()

Radhey Shyam Pandey (1):
      net: macb: Perform zynqmp dynamic configuration only for SGMII interface

Rob Clark (1):
      drm/i915: Move fd_install after last use of fence

Ryan Neph (1):
      drm/virtio: exbuf->fence_fd unmodified on interrupted wait

Sasha Neftin (1):
      igc: Add ndo_tx_timeout support

Serge Semin (1):
      spi: dw: Fix wrong FIFO level setting for long xfers

Shay Drory (3):
      net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
      net/mlx5: fw_tracer, Zero consumer index when reloading the tracer
      net/mlx5: Serialize module cleanup with reload and remove

Shengjiu Wang (1):
      ASoC: fsl_sai: fix getting version from VERID

Shiju Jose (1):
      tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw

Stefan Binding (1):
      ALSA: hda/realtek: Add quirk for ASUS UM3402 using CS35L41

Tariq Toukan (1):
      net: ethernet: mtk_eth_soc: fix wrong parameters order in __xdp_rxq_info_reg()

Tom Lendacky (3):
      x86/speculation: Identify processors vulnerable to SMT RSB predictions
      KVM: x86: Mitigate the cross-thread return address predictions bug
      Documentation/hw-vuln: Add documentation for Cross-Thread Return Predictions

Ville Syrjälä (2):
      drm/i915: Don't do the WM0->WM1 copy w/a if WM1 is already enabled
      drm/i915: Fix VBT DSI DVO port handling

Vlad Buslov (1):
      net/mlx5: Bridge, fix ageing of peer FDB entries

Vladimir Oltean (3):
      net: dsa: mt7530: don't change PVC_EG_TAG when CPU port becomes VLAN-aware
      net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"
      net: mscc: ocelot: fix all IPv6 getting trapped to CPU when PTP timestamping is used

Wander Lairson Costa (1):
      rtmutex: Ensure that the top waiter is always woken up

Will Deacon (1):
      cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task

Xiubo Li (1):
      ceph: flush cap releases when the session is flushed

Yafang Shao (1):
      tracing: Fix TASK_COMM_LEN in trace event format file

Yang Yingliang (1):
      RDMA/usnic: use iommu_map_atomic() under spin_lock()

Zhang Changzhong (1):
      ice: switch: fix potential memleak in ice_add_adv_recipe()

ZhaoLong Wang (1):
      cifs: Fix use-after-free in rdata->read_into_pages()

