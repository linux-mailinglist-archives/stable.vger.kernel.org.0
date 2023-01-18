Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C632671B12
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 12:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjARLpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 06:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjARLoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 06:44:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FC1366B9;
        Wed, 18 Jan 2023 03:05:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 136C761783;
        Wed, 18 Jan 2023 11:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A3C433F0;
        Wed, 18 Jan 2023 11:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674039915;
        bh=Vod6O729LLg34Bfo12PVtWB0vX/MbOn6kRTTtBdm6SY=;
        h=From:To:Cc:Subject:Date:From;
        b=VePyxehFWCN8qtPdvJC1V4iT736FycphvweBnT4KBMuNe4dlEdh45NoZQKTDH6crt
         Oh0d3Bed+iKd/wxDBfhtbmHwA50VuI5Q63DBYfgOI6PHa9gDQQ0ai27VCo9Z86XFf0
         9EECiupR2VK8Z9/+QFm3r2Ek7bpCy55r7boZR9hE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.164
Date:   Wed, 18 Jan 2023 12:05:08 +0100
Message-Id: <1674039908216189@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.164 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt           |   51 +-
 Documentation/sphinx/load_config.py                       |    6 
 Documentation/virt/kvm/api.rst                            |   60 ++
 Makefile                                                  |    2 
 arch/arm64/include/asm/atomic_ll_sc.h                     |  114 ++---
 arch/arm64/include/asm/atomic_lse.h                       |   16 
 arch/arm64/include/asm/kvm_emulate.h                      |   22 -
 arch/powerpc/include/asm/imc-pmu.h                        |    2 
 arch/powerpc/perf/imc-pmu.c                               |  136 +++---
 arch/s390/include/asm/cpu_mf.h                            |   31 -
 arch/s390/include/asm/percpu.h                            |    2 
 arch/s390/kernel/machine_kexec_file.c                     |    5 
 arch/s390/kernel/perf_cpum_sf.c                           |  101 ++--
 arch/x86/boot/bioscall.S                                  |    4 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                    |   26 -
 arch/x86/kvm/cpuid.c                                      |   32 -
 drivers/bus/mhi/core/pm.c                                 |    3 
 drivers/clk/imx/clk-imx8mp.c                              |   23 -
 drivers/edac/edac_device.c                                |   17 
 drivers/edac/edac_module.h                                |    2 
 drivers/firmware/efi/efi.c                                |    9 
 drivers/gpu/drm/msm/adreno/adreno_gpu.h                   |   10 
 drivers/gpu/drm/msm/dp/dp_aux.c                           |    4 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                    |   10 
 drivers/iommu/amd/init.c                                  |   89 +++-
 drivers/iommu/mtk_iommu_v1.c                              |   26 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c              |   14 
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c           |   17 
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h           |    6 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c           |  134 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h           |    4 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c       |   15 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c       |   21 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c       |    2 
 drivers/nfc/pn533/usb.c                                   |   44 +-
 drivers/platform/x86/sony-laptop.c                        |   21 
 drivers/regulator/da9211-regulator.c                      |   11 
 drivers/tty/hvc/hvc_xen.c                                 |   46 +-
 drivers/usb/host/xhci-mem.c                               |    4 
 drivers/usb/host/xhci-ring.c                              |  297 +++++++-------
 drivers/usb/host/xhci.h                                   |    6 
 fs/cifs/link.c                                            |    1 
 fs/ext4/super.c                                           |    1 
 include/dt-bindings/clock/imx8mp-clock.h                  |   10 
 include/linux/tpm_eventlog.h                              |    4 
 io_uring/io-wq.c                                          |    6 
 mm/memblock.c                                             |    8 
 net/ipv6/raw.c                                            |    4 
 net/netfilter/ipset/ip_set_bitmap_ip.c                    |    4 
 net/netfilter/nft_payload.c                               |    2 
 net/sched/act_mpls.c                                      |    8 
 net/tipc/node.c                                           |   12 
 net/xfrm/xfrm_user.c                                      |    7 
 sound/pci/hda/patch_realtek.c                             |   23 +
 sound/soc/codecs/wm8904.c                                 |    7 
 sound/soc/qcom/lpass-cpu.c                                |    5 
 tools/perf/util/auxtrace.c                                |    2 
 58 files changed, 1014 insertions(+), 537 deletions(-)

Aaron Thompson (1):
      mm: Always release pages to the buddy allocator in memblock_free_late().

Adrian Hunter (1):
      perf auxtrace: Fix address filter duplicate symbol selection

Alexander Egorenkov (1):
      s390/kexec: fix ipl report address for kdump

Angela Czubak (1):
      octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable

Ard Biesheuvel (1):
      efi: tpm: Avoid READ_ONCE() for accessing the event log

Brian Norris (1):
      ASoC: qcom: lpass-cpu: Fix fallback SD line index handling

Christophe JAILLET (1):
      iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()

Eliav Farber (1):
      EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Emanuele Ghidoli (1):
      ASoC: wm8904: fix wrong outputs volume after power reactivation

Ferry Toth (2):
      usb: ulpi: defer ulpi_register on ulpi_read_id timeout
      Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Gavin Li (1):
      net/mlx5e: Don't support encap rules with gbp option

Gavrilov Ilia (1):
      netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Greg Kroah-Hartman (1):
      Linux 5.10.164

Hans de Goede (1):
      platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Heiko Carstens (2):
      s390/cpum_sf: add READ_ONCE() semantics to compare and swap loops
      s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Herbert Xu (1):
      ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Ido Schimmel (1):
      net/sched: act_mpls: Fix warning during failed attribute validation

Jens Axboe (2):
      io_uring/io-wq: free worker if task_work creation is canceled
      io_uring/io-wq: only free worker if it was allocated for creation

Johan Hovold (1):
      efi: fix NULL-deref in init error path

Jonathan Corbet (1):
      docs: Fix the docs build with Sphinx 6.0

Kajol Jain (1):
      powerpc/imc-pmu: Fix use of mutex in IRQs disabled section

Kim Phillips (1):
      iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options

Konrad Dybcio (1):
      drm/msm/adreno: Make adreno quirks not overwrite each other

Kuogee Hsieh (1):
      drm/msm/dp: do not complete dp_aux_cmd_fifo_tx() if irq is not for aux transfer

Li Jun (2):
      dt-bindings: clocks: imx8mp: Add ID for usb suspend clock
      clk: imx: imx8mp: add shared clk gate for usb suspend clk

Lucas Stach (1):
      clk: imx8mp: add clkout1/2 support

Luka Guzenko (1):
      ALSA: hda/realtek: Enable mute/micmute LEDs on HP Spectre x360 13-aw0xxx

Marc Zyngier (1):
      KVM: arm64: Fix S1PTW handling on RO memslots

Marek Vasut (1):
      clk: imx8mp: Add DISP2 pixel clock

Mark Rutland (3):
      arm64: atomics: format whitespace consistently
      arm64: atomics: remove LL/SC trampolines
      arm64: cmpxchg_double*: hazard against entire exchange variable

Mathias Nyman (8):
      xhci: Avoid parsing transfer events several times
      xhci: get isochronous ring directly from endpoint structure
      xhci: adjust parameters passed to cleanup_halted_endpoint()
      xhci: Add xhci_reset_halted_ep() helper function
      xhci: move xhci_td_cleanup so it can be called by more functions
      xhci: store TD status in the td struct instead of passing it along
      xhci: move and rename xhci_cleanup_halted_endpoint()
      xhci: Prevent infinite loop in transaction errors recovery for streams

Minsuk Kang (1):
      nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Nicolas Dichtel (1):
      xfrm: fix rcu lock in xfrm_notify_userpolicy()

Pablo Neira Ayuso (1):
      netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits

Paolo Bonzini (2):
      Documentation: KVM: add API issues section
      KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID

Peter Newman (1):
      x86/resctrl: Fix task CLOSID/RMID update race

Peter Zijlstra (1):
      x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Qiang Yu (1):
      bus: mhi: host: Fix race between channel preparation and M0 event

Rahul Rameshbabu (1):
      net/mlx5: Fix ptp max frequency adjustment range

Reinette Chatre (1):
      x86/resctrl: Use task_curr() instead of task_struct->on_cpu to prevent unnecessary IPI

Ricardo Ribalda (1):
      regulator: da9211: Use irq handler when ready

Rob Clark (1):
      drm/virtio: Fix GEM handle creation UAF

Roger Pau Monne (1):
      hvc/xen: lock console list traversal

Subbaraya Sundeep (2):
      octeontx2-af: Update get/set resource count functions
      octeontx2-af: Map NIX block from CGX connection

Suravee Suthikulpanit (1):
      iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands

Tung Nguyen (1):
      tipc: fix unexpected link reset due to discovery messages

Volker Lendecke (1):
      cifs: Fix uninitialized memory read for smb311 posix symlink create

Yang Yingliang (1):
      ixgbe: fix pci device refcount leak

Ye Bin (1):
      ext4: fix uninititialized value in 'ext4_evict_inode'

Yong Wu (1):
      iommu/mediatek-v1: Add error handle for mtk_iommu_probe

