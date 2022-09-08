Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2095B18C0
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 11:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIHJco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 05:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHJcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 05:32:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3438C8E4ED;
        Thu,  8 Sep 2022 02:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8ED4B82051;
        Thu,  8 Sep 2022 09:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A88C433C1;
        Thu,  8 Sep 2022 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662629558;
        bh=aaXBxbmZJiEjXarnB/idkzpwHYD7UBRVGFByUalwJx8=;
        h=From:To:Cc:Subject:Date:From;
        b=2meto/3aPB+CziEJx5ik0BR0Xhg4EDBJnW+zYqclkCfHnIZxiDuFoG8iA8xLTBniG
         /y1yFQSBeiDZtIbKQIj2WpNkOgTbUdPzoWzJ7bDe4egGqOAGMjHpuP6+YEApa1nM5i
         azvCN/4Db+l/+cr+Dr5Mg5+0ebyPDrmr1Doy+F/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.8
Date:   Thu,  8 Sep 2022 11:32:59 +0200
Message-Id: <1662629579112246@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.19.8 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm64/kernel/machine_kexec_file.c                     |    2 
 arch/powerpc/include/asm/firmware.h                        |    8 
 arch/powerpc/kernel/rtas_entry.S                           |    4 
 arch/powerpc/kernel/systbl.S                               |    1 
 arch/powerpc/platforms/pseries/papr_scm.c                  |   90 ++-----
 arch/riscv/include/asm/kvm_vcpu_sbi.h                      |   12 
 arch/riscv/kvm/vcpu_sbi.c                                  |   12 
 arch/riscv/mm/pageattr.c                                   |    4 
 arch/s390/include/asm/hugetlb.h                            |    6 
 arch/s390/kernel/vmlinux.lds.S                             |    1 
 arch/x86/kvm/vmx/vmx.c                                     |    3 
 arch/x86/kvm/x86.c                                         |   25 +
 drivers/android/binder.c                                   |   12 
 drivers/android/binder_alloc.c                             |    4 
 drivers/base/dd.c                                          |   10 
 drivers/base/firmware_loader/sysfs.c                       |    7 
 drivers/base/firmware_loader/sysfs.h                       |    5 
 drivers/base/firmware_loader/sysfs_upload.c                |   12 
 drivers/block/xen-blkback/common.h                         |    3 
 drivers/block/xen-blkback/xenbus.c                         |    6 
 drivers/block/xen-blkfront.c                               |   20 -
 drivers/clk/bcm/clk-raspberrypi.c                          |   15 -
 drivers/clk/clk.c                                          |    3 
 drivers/clk/ti/clk.c                                       |    1 
 drivers/dma-buf/dma-resv.c                                 |    3 
 drivers/gpio/gpio-pca953x.c                                |    8 
 drivers/gpio/gpio-realtek-otto.c                           |  166 ++++++-------
 drivers/gpu/drm/i915/display/intel_backlight.c             |   37 +-
 drivers/gpu/drm/i915/display/intel_bw.c                    |   16 -
 drivers/gpu/drm/i915/display/intel_dp.c                    |    2 
 drivers/gpu/drm/i915/display/intel_quirks.c                |    3 
 drivers/gpu/drm/i915/gt/intel_migrate.c                    |   44 +--
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c          |    7 
 drivers/gpu/drm/i915/gvt/handlers.c                        |    2 
 drivers/gpu/drm/i915/intel_gvt_mmio_table.c                |    3 
 drivers/gpu/drm/i915/intel_pm.c                            |    8 
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c                |    6 
 drivers/gpu/drm/msm/dp/dp_ctrl.c                           |    2 
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                          |    4 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c                      |    2 
 drivers/gpu/drm/msm/msm_drv.c                              |    2 
 drivers/gpu/drm/msm/msm_gpu_devfreq.c                      |    2 
 drivers/hwmon/gpio-fan.c                                   |    3 
 drivers/iio/adc/ad7292.c                                   |    4 
 drivers/iio/adc/mcp3911.c                                  |   28 +-
 drivers/iio/light/cm3605.c                                 |    6 
 drivers/input/joystick/iforce/iforce-serio.c               |    6 
 drivers/input/joystick/iforce/iforce-usb.c                 |    8 
 drivers/input/joystick/iforce/iforce.h                     |    6 
 drivers/input/misc/rk805-pwrkey.c                          |    1 
 drivers/media/rc/mceusb.c                                  |   35 +-
 drivers/misc/fastrpc.c                                     |   12 
 drivers/mmc/core/sd.c                                      |   46 +--
 drivers/net/dsa/xrs700x/xrs700x.c                          |    5 
 drivers/net/ethernet/cortina/gemini.c                      |   24 -
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h         |    4 
 drivers/net/ethernet/google/gve/gve_ethtool.c              |   16 -
 drivers/net/ethernet/google/gve/gve_main.c                 |   12 
 drivers/net/ethernet/huawei/hinic/hinic_rx.c               |    4 
 drivers/net/ethernet/huawei/hinic/hinic_tx.c               |    4 
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h      |    4 
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |  122 ++++++++-
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c        |    3 
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c      |    5 
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c      |    2 
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c       |    5 
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c        |    8 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c       |    8 
 drivers/net/ethernet/rocker/rocker_ofdpa.c                 |    2 
 drivers/net/ethernet/smsc/smsc911x.c                       |    6 
 drivers/net/ieee802154/adf7242.c                           |    3 
 drivers/net/netdevsim/netdev.c                             |    4 
 drivers/net/phy/micrel.c                                   |    8 
 drivers/peci/controller/peci-aspeed.c                      |    2 
 drivers/platform/mellanox/mlxreg-lc.c                      |   38 +-
 drivers/platform/x86/pmc_atom.c                            |    2 
 drivers/platform/x86/x86-android-tablets.c                 |   14 +
 drivers/soundwire/qcom.c                                   |    6 
 drivers/staging/r8188eu/os_dep/os_intfs.c                  |    1 
 drivers/staging/r8188eu/os_dep/usb_intf.c                  |    1 
 drivers/staging/rtl8712/rtl8712_cmd.c                      |   36 --
 drivers/thunderbolt/ctl.c                                  |    2 
 drivers/thunderbolt/switch.c                               |    6 
 drivers/tty/n_gsm.c                                        |   85 ++----
 drivers/tty/serial/atmel_serial.c                          |    4 
 drivers/tty/serial/fsl_lpuart.c                            |    5 
 drivers/tty/vt/vt.c                                        |   12 
 drivers/usb/cdns3/cdns3-gadget.c                           |    4 
 drivers/usb/class/cdc-acm.c                                |    3 
 drivers/usb/core/hub.c                                     |   10 
 drivers/usb/dwc2/platform.c                                |    8 
 drivers/usb/dwc3/core.c                                    |   19 -
 drivers/usb/dwc3/dwc3-pci.c                                |    4 
 drivers/usb/dwc3/gadget.c                                  |    8 
 drivers/usb/dwc3/host.c                                    |   10 
 drivers/usb/gadget/function/f_uac2.c                       |   16 +
 drivers/usb/gadget/function/storage_common.c               |    6 
 drivers/usb/gadget/udc/core.c                              |   26 +-
 drivers/usb/host/xhci-hub.c                                |   13 -
 drivers/usb/host/xhci-mtk-sch.c                            |   15 -
 drivers/usb/host/xhci-plat.c                               |   11 
 drivers/usb/host/xhci.c                                    |   19 -
 drivers/usb/host/xhci.h                                    |    4 
 drivers/usb/musb/Kconfig                                   |    2 
 drivers/usb/serial/ch341.c                                 |   16 +
 drivers/usb/serial/cp210x.c                                |    1 
 drivers/usb/serial/ftdi_sio.c                              |    2 
 drivers/usb/serial/ftdi_sio_ids.h                          |    6 
 drivers/usb/serial/option.c                                |   15 +
 drivers/usb/storage/unusual_devs.h                         |    7 
 drivers/usb/typec/altmodes/displayport.c                   |    4 
 drivers/usb/typec/mux/intel_pmc_mux.c                      |    9 
 drivers/usb/typec/tcpm/tcpm.c                              |    7 
 drivers/usb/typec/ucsi/ucsi.c                              |   53 +---
 drivers/xen/grant-table.c                                  |    3 
 fs/cachefiles/internal.h                                   |    1 
 fs/cachefiles/ondemand.c                                   |   22 +
 fs/cifs/smb2pdu.c                                          |   12 
 include/linux/bpf.h                                        |   13 +
 include/linux/platform_data/x86/pmc_atom.h                 |    6 
 include/linux/usb.h                                        |    2 
 include/linux/usb/typec_dp.h                               |    5 
 include/net/ip_tunnels.h                                   |    4 
 kernel/bpf/cgroup.c                                        |    4 
 kernel/bpf/core.c                                          |    2 
 kernel/bpf/syscall.c                                       |    2 
 kernel/bpf/verifier.c                                      |  112 +++++---
 mm/pagewalk.c                                              |   21 -
 mm/ptdump.c                                                |    4 
 mm/slab_common.c                                           |   45 ++-
 net/bluetooth/hci_event.c                                  |   13 -
 net/bluetooth/hci_sync.c                                   |   30 +-
 net/core/skmsg.c                                           |    4 
 net/ipv4/fib_frontend.c                                    |    4 
 net/ipv4/ip_gre.c                                          |    2 
 net/ipv4/ip_tunnel.c                                       |    7 
 net/ipv4/tcp_input.c                                       |    4 
 net/kcm/kcmsock.c                                          |   15 -
 net/mac80211/ibss.c                                        |    4 
 net/mac80211/scan.c                                        |   11 
 net/mac80211/sta_info.c                                    |    8 
 net/mac802154/rx.c                                         |    2 
 net/mpls/af_mpls.c                                         |    4 
 net/openvswitch/datapath.c                                 |    4 
 net/sched/sch_generic.c                                    |   31 +-
 net/sched/sch_tbf.c                                        |    4 
 net/smc/af_smc.c                                           |    1 
 net/wireless/debugfs.c                                     |    3 
 net/xdp/xsk_buff_pool.c                                    |   16 -
 security/landlock/fs.c                                     |   48 +--
 sound/core/memalloc.c                                      |   87 +++++-
 sound/core/seq/oss/seq_oss_midi.c                          |    2 
 sound/core/seq/seq_clientmgr.c                             |   12 
 sound/hda/intel-nhlt.c                                     |    8 
 sound/pci/hda/patch_realtek.c                              |   63 ++++
 tools/testing/selftests/landlock/fs_test.c                 |  155 +++++++++++-
 158 files changed, 1491 insertions(+), 812 deletions(-)

Abhinav Kumar (1):
      drm/msm/dpu: populate wb or intf before reset_intf_cfg

Adrian Hunter (2):
      mmc: core: Fix UHS-I SD 1.8V workaround branch
      mmc: core: Fix inconsistent sd3_bus_mode at UHS-I SD voltage switch failure

Alan Stern (3):
      media: mceusb: Use new usb_control_msg_*() routines
      USB: core: Prevent nested device-reset calls
      USB: gadget: Fix obscure lockdep violation for udc_mutex

Alex Williamson (1):
      drm/i915/gvt: Fix Comet Lake

Andrey Zhadchenko (1):
      openvswitch: fix memory leak at failed datapath creation

Andy Shevchenko (1):
      platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Archie Pusaka (1):
      Bluetooth: hci_event: Fix checking conn for le_conn_complete_evt

Armin Wolf (1):
      hwmon: (gpio-fan) Fix array out of bounds access

Arnd Bergmann (1):
      musb: fix USB_MUSB_TUSB6010 dependency

Arun R Murthy (1):
      drm/i915/display: avoid warnings when registering dual panel backlight

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Return ENOTSUPP for power supply prop writes

Bjorn Andersson (1):
      drm/msm/gpu: Drop qos request if devm_devfreq_add_device() fails

Carlos Llamas (2):
      binder: fix UAF of ref->proc caused by race condition
      binder: fix alloc->vma_vm_mm null-ptr dereference

Casper Andersson (1):
      net: sparx5: fix handling uneven length packets in manual extraction

Chen-Yu Tsai (2):
      clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops
      clk: core: Fix runtime PM sequence in clk_core_unprepare()

Christian König (1):
      dma-buf/dma-resv: check if the new fence is really later

Christophe JAILLET (1):
      iio: light: cm3605: Fix an error handling path in cm3605_probe()

Chunfeng Yun (2):
      usb: xhci-mtk: relax TT periodic bandwidth allocation
      usb: xhci-mtk: fix bandwidth release issue

Colin Ian King (1):
      drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"

Cong Wang (1):
      kcm: fix strp_init() order and cleanup

Conor Dooley (1):
      riscv: kvm: move extern sbi_ext declarations to a header

Dan Carpenter (4):
      wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()
      net: lan966x: improve error handle in lan966x_fdma_rx_get_frame()
      staging: rtl8712: fix use after free bugs
      xen/grants: prevent integer overflow in gnttab_dma_alloc_pages()

Daniele Ceraolo Spurio (1):
      drm/i915/guc: clear stalled request after a reset

David Thompson (1):
      mlxbf_gige: compute MDIO period based on i1clk

Diego Santa Cruz (1):
      drm/i915/glk: ECS Liva Q2 needs GLK HDMI port timing quirk

Douglas Anderson (2):
      drm/msm/dsi: Fix number of regulators for msm8996_dsi_cfg
      drm/msm/dsi: Fix number of regulators for SDM660

Duoming Zhou (1):
      ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler

Enzo Matsumiya (1):
      cifs: fix small mempool leak in SMB2_negotiate()

Eric Dumazet (1):
      tcp: annotate data-race around challenge_timestamp

Eyal Birger (1):
      ip_tunnel: Respect tunnel key's "flow_flags" in IP tunnels

Fedor Pchelkin (2):
      tty: n_gsm: replace kicktimer with delayed_work
      tty: n_gsm: avoid call of sleeping functions from atomic context

Florian Fainelli (1):
      net: smsc911x: Stop and start PHY during suspend and resume

Gerald Schaefer (1):
      s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages

Greg Kroah-Hartman (1):
      Linux 5.19.8

Grzegorz Szymaszek (1):
      staging: r8188eu: add firmware dependency

Haibo Chen (1):
      gpio: pca953x: Add mutex_lock for regcache sync in PM

Hans de Goede (2):
      platform/x86: x86-android-tablets: Fix broken touchscreen on Chuwi Hi8 with Windows BIOS
      Bluetooth: hci_event: Fix vendor (unknown) opcode status handling

Heikki Krogerus (1):
      usb: dwc3: pci: Add support for Intel Raptor Lake

Heiner Kallweit (1):
      usb: dwc2: fix wrong order of phy_power_on and phy_init

Helge Deller (1):
      vt: Clear selection before changing the font

Horatiu Vultur (1):
      net: phy: micrel: Make the GPIO to be non-exclusive

Isaac J. Manjarres (1):
      driver core: Don't probe devices after bus_type.match() probe deferral

Jakub Kicinski (1):
      Revert "sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb"

Jim Mattson (2):
      KVM: VMX: Heed the 'msr' argument in msr_write_intercepted()
      KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES

Jing Leng (1):
      usb: gadget: f_uac2: fix superspeed transfer

Joanne Koong (1):
      bpf: Tidy up verifier check_func_arg()

Johan Hovold (7):
      misc: fastrpc: fix memory corruption on probe
      misc: fastrpc: fix memory corruption on open
      usb: dwc3: disable USB core PHY management
      usb: dwc3: fix PHY disable sequence
      USB: serial: ch341: fix lost character on LCR updates
      USB: serial: ch341: fix disabled rx timer on older devices
      USB: serial: cp210x: add Decagon UCA device id

Josh Poimboeuf (1):
      s390: fix nospec table alignments

Jouni Högander (1):
      drm/i915/backlight: Disable pps power hook for aux based backlight

Kacper Michajłow (1):
      ALSA: hda/realtek: Add speaker AMP init for Samsung laptops with ALC298

Kajol Jain (1):
      powerpc/papr_scm: Fix nvdimm event mappings

Krishna Kurapati (1):
      usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS

Kumar Kartikeya Dwivedi (1):
      bpf: Do mark_chain_precision for ARG_CONST_ALLOC_SIZE_OR_ZERO

Kuniyuki Iwashima (1):
      bpf: Fix a data-race around bpf_jit_limit.

Kuogee Hsieh (2):
      drm/msm/dp: make eDP panel as the first connected connector
      drm/msm/dp: delete DP_RECOVERED_CLOCK_OUT_EN to fix tps4

Larry Finger (1):
      staging: r8188eu: Add Rosewill USB-N150 Nano to device tables

Levi Yun (1):
      arm64/kexec: Fix missing extra range for crashkres_low.

Lin Ma (1):
      ieee802154/adf7242: defer destroy_workqueue call

Liu Jian (1):
      skmsg: Fix wrong last sg check in sk_msg_recvmsg()

Luiz Augusto von Dentz (1):
      Bluetooth: hci_sync: Fix suspend performance regression

Lv Ruyi (1):
      peci: aspeed: fix error check return value of platform_get_irq()

Magnus Karlsson (1):
      xsk: Fix corrupted packets for XDP_SHARED_UMEM

Marcus Folkesson (3):
      iio: adc: mcp3911: make use of the sign bit
      iio: adc: mcp3911: correct "microchip,device-addr" property
      iio: adc: mcp3911: use correct formula for AD conversion

Masahiro Yamada (1):
      powerpc: align syscall table for ppc32

Mathias Nyman (3):
      xhci: Fix null pointer dereference in remove if xHC has only one roothub
      Revert "xhci: turn off port power in shutdown"
      xhci: Add grace period after xHC start to prevent premature runtime suspend.

Matthew Auld (1):
      drm/i915/ttm: fix CCS handling

Matti Vaittinen (1):
      iio: ad7292: Prevent regulator double disable

Maxim Mikityanskiy (1):
      bpf: Allow helpers to accept pointers with a fixed size

Mazin Al Haddad (1):
      tty: n_gsm: add sanity check for gsm->receive in gsm_receive_buf()

Michael Ellerman (2):
      Revert "powerpc: Remove unused FW_FEATURE_NATIVE references"
      powerpc/rtas: Fix RTAS MSR[HV] handling for Cell

Mickaël Salaün (1):
      landlock: Fix file reparenting without explicit LANDLOCK_ACCESS_FS_REFER

Mika Westerberg (2):
      thunderbolt: Use the actual buffer in tb_async_error()
      thunderbolt: Check router generation before connecting xHCI

Miquel Raynal (1):
      net: mac802154: Fix a condition in the receive path

Nathan Chancellor (1):
      powerpc/papr_scm: Ensure rc is always initialized in papr_scm_pmu_register()

Nicolas Dichtel (1):
      ip: fix triggering of 'icmp redirect'

Niek Nooijens (1):
      USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Pablo Sun (1):
      usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles

Pawel Laszczak (2):
      usb: cdns3: fix issue with rearming ISO OUT endpoint
      usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer

Peter Robinson (1):
      Input: rk805-pwrkey - fix module autoloading

Peter Ujfalusi (1):
      ALSA: hda: intel-nhlt: Correct the handling of fmt_config flexible array

Pu Lehui (1):
      bpf, cgroup: Fix kernel BUG in purge_effective_progs

Russ Weight (2):
      firmware_loader: Fix use-after-free during unregister
      firmware_loader: Fix memory leak in firmware upload

Sander Vanheule (1):
      gpio: realtek-otto: switch to 32-bit I/O

Sebastian Andrzej Siewior (2):
      net: dsa: xrs700x: Use irqsave variant for u64 stats update
      net: Use u64_stats_fetch_begin_irq() for stats fetch.

SeongJae Park (3):
      xen-blkback: Advertise feature-persistent as user requested
      xen-blkfront: Advertise feature-persistent as user requested
      xen-blkfront: Cache feature_persistent value before advertisement

Sergiu Moga (1):
      tty: serial: atmel: Preserve previous USART mode if RS485 disabled

Shenwei Wang (1):
      serial: fsl_lpuart: RS485 RTS polariy is inverse

Sherry Sun (1):
      tty: serial: lpuart: disable flow control while waiting for the transmit engine to complete

Siddh Raman Pant (2):
      wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected
      wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV32-WA/WB RmNet mode

Srinivas Kandagatla (1):
      soundwire: qcom: fix device status array range

Stefan Wahren (3):
      clk: bcm: rpi: Fix error handling of raspberrypi_fw_get_rate
      clk: bcm: rpi: Prevent out-of-bounds access
      clk: bcm: rpi: Add missing newline

Stephen Boyd (1):
      Revert "clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops"

Steven Price (1):
      mm: pagewalk: Fix race between unmap and page walker

Sun Ke (1):
      cachefiles: fix error return code in cachefiles_ondemand_copen()

Takashi Iwai (4):
      Revert "usb: typec: ucsi: add a common function ucsi_unregister_connectors()"
      ALSA: memalloc: Revive x86-specific WC page allocations again
      ALSA: seq: oss: Fix data-race for max_midi_devs access
      ALSA: seq: Fix data-race at module auto-loading

Tetsuo Handa (2):
      Input: iforce - wake up after clearing IFORCE_XMIT_RUNNING flag
      tty: n_gsm: initialize more members at gsm_alloc_mux()

Thierry GUIBERT (1):
      USB: cdc-acm: Add Icom PMR F3400 support (0c26:0020)

Tianyu Yuan (1):
      nfp: flower: fix ingress police using matchall filter

Toke Høiland-Jørgensen (1):
      sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb

Tony Lindgren (1):
      clk: ti: Fix missing of_node_get() ti_find_clock_provider()

Utkarsh Patel (1):
      usb: typec: intel_pmc_mux: Add new ACPI ID for Meteor Lake IOM device

Vadim Pasternak (2):
      platform/mellanox: mlxreg-lc: Fix coverity warning
      platform/mellanox: mlxreg-lc: Fix locking issue

Ville Syrjälä (1):
      drm/i915: Skip wm/ddb readout for disabled pipes

Waiman Long (1):
      mm/slab_common: Deleting kobject in kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock

Wang Hai (1):
      net/sched: fix netdevice reference leaks in attach_default_qdiscs()

Wesley Cheng (1):
      usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop

Witold Lipieta (1):
      usb-storage: Add ignore-residue quirk for NXP PN7462AU

Xin Yin (1):
      cachefiles: make on-demand request distribution fairer

Yacan Liu (1):
      net/smc: Remove redundant refcount increase

Yan Xinyu (1):
      USB: serial: option: add support for OPPO R11 diag port

YiFei Zhu (1):
      bpf: Restrict bpf_sys_bpf to CAP_PERFMON

Yonglin Tan (1):
      USB: serial: option: add Quectel EM060K modem

Zhengchao Shao (1):
      net: sched: tbf: don't call qdisc_put() while holding tree lock

Zhengping Jiang (1):
      Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn

sunliming (1):
      drm/msm/dsi: fix the inconsistent indenting

Łukasz Bartosik (1):
      drm/i915: fix null pointer dereference

