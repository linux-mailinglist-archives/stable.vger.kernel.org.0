Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD813FFC91
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348617AbhICJCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348493AbhICJCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4305D60E9B;
        Fri,  3 Sep 2021 09:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659694;
        bh=UTckr1Gj/cFIclkEDqH04B0S9hPTIZpu2gi2XsflgLc=;
        h=From:To:Cc:Subject:Date:From;
        b=fCRHu7HFKRHOCgIcLwCgtNEN1HxkWx7hxu0QzIR8QGuEQn8hvA6ycrA16BlFRrjM4
         D4xkQRv86ZFD3JYCTpPzO/7JaR4bhuCx697m+5C7W0qswJ0d0mXuxfLZIEO0stG9AQ
         rgJRASkkRQcYiQxcU4384mS1cphheBQAW/4j2SBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.206
Date:   Fri,  3 Sep 2021 11:01:25 +0200
Message-Id: <163065968590247@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.206 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arc/kernel/vmlinux.lds.S                          |    2 
 arch/x86/kvm/mmu.c                                     |   11 ++
 drivers/block/floppy.c                                 |   27 +++---
 drivers/gpu/drm/drm_ioc32.c                            |    4 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c          |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h          |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c        |    9 ++
 drivers/infiniband/hw/hfi1/sdma.c                      |    9 --
 drivers/net/can/usb/esd_usb2.c                         |    4 
 drivers/net/ethernet/apm/xgene-v2/main.c               |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   13 ---
 drivers/net/ethernet/intel/e1000e/ich8lan.c            |   14 +++
 drivers/net/ethernet/intel/e1000e/ich8lan.h            |    3 
 drivers/net/ethernet/marvell/mvneta.c                  |    2 
 drivers/net/ethernet/qlogic/qed/qed_ll2.c              |   20 ++++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c             |    3 
 drivers/opp/of.c                                       |    5 -
 drivers/tty/vt/vt_ioctl.c                              |   11 +-
 drivers/usb/dwc3/gadget.c                              |   23 ++---
 drivers/usb/gadget/function/u_audio.c                  |    5 -
 drivers/usb/serial/ch341.c                             |    1 
 drivers/usb/serial/option.c                            |    2 
 drivers/vhost/vringh.c                                 |    2 
 drivers/video/fbdev/core/fbmem.c                       |    4 
 drivers/virtio/virtio_pci_common.c                     |    7 +
 drivers/virtio/virtio_ring.c                           |    6 -
 include/linux/filter.h                                 |   24 +++++
 include/linux/netdevice.h                              |    4 
 include/linux/once.h                                   |    4 
 kernel/bpf/core.c                                      |   32 +++----
 kernel/bpf/verifier.c                                  |   27 +++---
 lib/once.c                                             |   11 +-
 net/ipv4/ip_gre.c                                      |    2 
 net/netfilter/nf_conntrack_core.c                      |   71 +++++------------
 net/qrtr/qrtr.c                                        |    2 
 net/rds/ib_frmr.c                                      |    4 
 net/socket.c                                           |    6 +
 38 files changed, 227 insertions(+), 156 deletions(-)

Ben Skeggs (1):
      drm/nouveau/disp: power down unused DP links during init

Christophe JAILLET (1):
      xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'

Daniel Borkmann (3):
      bpf: Do not use ax register in interpreter on div/mod
      bpf: Fix 32 bit src register truncation on div/mod
      bpf: Fix truncation handling for mod32 dst reg wrt zero

Denis Efremov (1):
      Revert "floppy: reintroduce O_NDELAY fix"

Florian Westphal (1):
      netfilter: conntrack: collect all entries in one cycle

George Kennedy (1):
      fbmem: add margin check to fb_check_caps()

Gerd Rausch (1):
      net/rds: dma_map_sg is entitled to merge entries

Greg Kroah-Hartman (1):
      Linux 4.19.206

Guangbin Huang (1):
      net: hns3: fix get wrong pfc_en when query PFC configuration

Guenter Roeck (1):
      ARC: Fix CONFIG_STACKDEPOT

Jerome Brunet (1):
      usb: gadget: u_audio: fix race condition on endpoint stop

Johan Hovold (1):
      Revert "USB: serial: ch341: fix character loss at high transfer rates"

Kefeng Wang (1):
      once: Fix panic when module unload

Linus Torvalds (1):
      vt_kdsetmode: extend console locking

Mark Yacoub (1):
      drm: Copy drm_wait_vblank to user before returning

Maxim Kiselev (1):
      net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Michał Mirosław (1):
      opp: remove WARN when no valid OPPs remain

Neeraj Upadhyay (1):
      vringh: Use wiov->used to check for read/write desc order

Parav Pandit (2):
      virtio: Improve vq->broken access to avoid any compiler optimization
      virtio_pci: Support surprise removal of virtio pci device

Peter Collingbourne (1):
      net: don't unconditionally copy_from_user a struct ifreq for socket ioctls

Sasha Neftin (1):
      e1000e: Fix the max snoop/no-snoop latency for 10M

Sean Christopherson (1):
      KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs

Shai Malin (2):
      qed: qed ll2 race condition fixes
      qed: Fix null-pointer dereference in qed_rdma_create_qp()

Shreyansh Chouhan (1):
      ip_gre: add validation for csum_start

Stefan Mätje (1):
      can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

Tuo Li (1):
      IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()

Wesley Cheng (1):
      usb: dwc3: gadget: Stop EP0 transfers during pullup disable

Xiaolong Huang (1):
      net: qrtr: fix another OOB Read in qrtr_endpoint_post

Zhengjun Zhang (1):
      USB: serial: option: add new VID/PID to support Fibocom FG150

