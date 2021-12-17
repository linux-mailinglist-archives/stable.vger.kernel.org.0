Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8464788A4
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 11:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhLQKVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 05:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbhLQKVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 05:21:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29386C061574;
        Fri, 17 Dec 2021 02:21:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C061E620E1;
        Fri, 17 Dec 2021 10:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC95C36AE5;
        Fri, 17 Dec 2021 10:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639736468;
        bh=wcKMaeTGHgPR1PxGNoomApsF/kSUy/bHyGtrv2JA8dQ=;
        h=From:To:Cc:Subject:Date:From;
        b=je9zhtvYbNTZ1wRHNDaL5bkmliATw8sQVIhJY6abWzdVnLRmuTyP8/sEzSpVVsdcF
         VN2uwkk4Ntj38l6xy8LnG68ScodiubM0g8mfkiFh9UMiT0tEGK/DGU/esqOa77muLT
         zYoBZUsKkAb83fSxS0NG4wTUoIGJbcnd8KNs4KdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.87
Date:   Fri, 17 Dec 2021 11:21:01 +0100
Message-Id: <163973646218123@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.87 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm/mm/init.c                                    |   37 +++++---
 arch/arm/mm/ioremap.c                                 |    4 
 arch/arm64/kvm/hyp/include/hyp/switch.h               |    6 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h            |    7 +
 arch/s390/lib/test_unwind.c                           |    5 -
 arch/x86/kvm/hyperv.c                                 |    7 +
 drivers/char/agp/parisc-agp.c                         |    6 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c |    8 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c     |    4 
 drivers/gpu/drm/msm/dsi/dsi_host.c                    |    2 
 drivers/hwmon/dell-smm-hwmon.c                        |    7 +
 drivers/i2c/busses/i2c-rk3x.c                         |    4 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c       |    6 -
 drivers/staging/most/dim2/dim2.c                      |   55 ++++++-----
 drivers/tty/serial/fsl_lpuart.c                       |    1 
 fs/fuse/dir.c                                         |    8 +
 fs/fuse/file.c                                        |   15 +++
 fs/fuse/fuse_i.h                                      |    1 
 fs/fuse/inode.c                                       |    3 
 kernel/bpf/devmap.c                                   |    4 
 kernel/trace/tracing_map.c                            |    3 
 mm/memblock.c                                         |    3 
 net/core/sock_map.c                                   |    2 
 net/ethtool/netlink.h                                 |    3 
 net/netlink/af_netlink.c                              |    5 +
 net/nfc/netlink.c                                     |    6 -
 sound/pci/hda/hda_intel.c                             |   12 ++
 sound/pci/hda/patch_hdmi.c                            |    3 
 tools/perf/builtin-inject.c                           |    2 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c   |   83 +++++++++++-------
 tools/perf/util/intel-pt.c                            |    1 
 32 files changed, 223 insertions(+), 92 deletions(-)

Adrian Hunter (8):
      perf inject: Fix itrace space allowed for new attributes
      perf intel-pt: Fix some PGE (packet generation enable/control flow packets) usage
      perf intel-pt: Fix sync state when a PSB (synchronization) packet is found
      perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type
      perf intel-pt: Fix state setting when receiving overflow (OVF) packet
      perf intel-pt: Fix next 'err' value, walking trace
      perf intel-pt: Fix missing 'instruction' events with 'q' option
      perf intel-pt: Fix error timestamp setting on the decoder error path

Alexander Stein (1):
      Revert "tty: serial: fsl_lpuart: drop earlycon entry for i.MX8QXP"

Antoine Tenart (1):
      ethtool: do not perform operations on net devices being unregistered

Armin Wolf (1):
      hwmon: (dell-smm) Fix warning on /proc/i8k creation error

Bui Quang Minh (1):
      bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc

Chen Jun (1):
      tracing: Fix a kmemleak false positive in tracing_map

Erik Ekman (1):
      net/mlx4_en: Update reported link modes for 1/10G

Greg Kroah-Hartman (1):
      Linux 5.10.87

Harshit Mogalapalli (1):
      net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Helge Deller (1):
      parisc/agp: Annotate parisc agp init functions with __init

Ilie Halip (1):
      s390/test_unwind: use raw opcode instead of invalid instruction

Kai Vehmanen (2):
      ALSA: hda: Add Intel DG2 PCI ID and HDMI codec vid
      ALSA: hda/hdmi: fix HDA codec entry table order for ADL-P

Marc Zyngier (1):
      KVM: arm64: Save PSTATE early on exit

Mike Rapoport (5):
      memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER
      memblock: align freed memory map on pageblock boundaries with SPARSEMEM
      memblock: ensure there is no overflow in memblock_overlaps_region()
      arm: extend pfn_valid to take into account freed memory map alignment
      arm: ioremap: don't abuse pfn_valid() to check if pfn is in RAM

Miklos Szeredi (1):
      fuse: make sure reclaim doesn't write the inode

Mustapha Ghaddar (1):
      drm/amd/display: Fix for the no Audio bug with Tiled Displays

Nikita Yushchenko (1):
      staging: most: dim2: use device release method

Ondrej Jirman (1):
      i2c: rk3x: Handle a spurious start completion interrupt flag

Perry Yuan (1):
      drm/amd/display: add connector type check for CRC source set

Philip Chen (1):
      drm/msm/dsi: set default num_data_lanes

Sean Christopherson (1):
      KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req

Tadeusz Struk (1):
      nfc: fix segfault in nfc_genl_dump_devices_done

