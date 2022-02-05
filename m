Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308BC4AA894
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379744AbiBEMPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:15:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49914 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379770AbiBEMPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:15:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E940F60DE4;
        Sat,  5 Feb 2022 12:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F36C340E9;
        Sat,  5 Feb 2022 12:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644063306;
        bh=QNNMajPzf/BnsLwhzqxR83dEMyHBhjkCahtJ0Lo5AMw=;
        h=From:To:Cc:Subject:Date:From;
        b=uNjhlCUri2AbsivAw0naPnvhGEpseWb+l/CjmQNNjo0IbCcTOzsGQ6rwRM2qqBgN0
         GynIE8FHPQLe2uImmC/VmGHpziD3Kid9rbH3qHG9AhHnhGXtgnvslb4t6otNNufwYP
         J9tAWp8h4kgV6VX9CgGRA3jaN96vgrtN4fPfORJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.97
Date:   Sat,  5 Feb 2022 13:14:59 +0100
Message-Id: <1644063299221167@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.97 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/accounting/psi.rst                        |    3 
 Makefile                                                |    2 
 arch/x86/include/asm/kvm_host.h                         |    1 
 arch/x86/kernel/cpu/mce/intel.c                         |    2 
 arch/x86/kvm/svm/nested.c                               |   10 +-
 arch/x86/kvm/svm/svm.c                                  |    2 
 arch/x86/kvm/svm/svm.h                                  |    2 
 arch/x86/kvm/vmx/nested.c                               |    1 
 arch/x86/kvm/x86.c                                      |    2 
 drivers/bus/simple-pm-bus.c                             |   39 ---------
 drivers/gpu/drm/vc4/vc4_hdmi.c                          |   25 +++---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                |   14 +++
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c   |   32 +++----
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c      |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c |    2 
 drivers/net/ipa/ipa_endpoint.c                          |   25 ++++--
 drivers/net/ipa/ipa_endpoint.h                          |   15 +++
 drivers/net/usb/ipheth.c                                |    6 -
 drivers/pci/hotplug/pciehp_hpc.c                        |    7 -
 fs/notify/fanotify/fanotify_user.c                      |    6 -
 include/linux/psi.h                                     |    2 
 include/linux/psi_types.h                               |    3 
 kernel/cgroup/cgroup-v1.c                               |   14 +++
 kernel/cgroup/cgroup.c                                  |   11 +-
 kernel/cgroup/cpuset.c                                  |    3 
 kernel/sched/psi.c                                      |   66 +++++++---------
 net/core/rtnetlink.c                                    |    6 -
 net/ipv4/tcp_input.c                                    |    2 
 net/packet/af_packet.c                                  |    8 +
 net/sched/cls_api.c                                     |   11 +-
 30 files changed, 175 insertions(+), 149 deletions(-)

Alex Elder (3):
      net: ipa: fix atomic update in ipa_endpoint_replenish()
      net: ipa: use a bitmap for endpoint replenish_enabled
      net: ipa: prevent concurrent replenish

Dan Carpenter (1):
      fanotify: Fix stale file descriptor in copy_event_to_user()

Eric Dumazet (4):
      net: sched: fix use-after-free in tc_new_tfilter()
      rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
      af_packet: fix data-race in packet_setsockopt / packet_setsockopt
      tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()

Eric W. Biederman (1):
      cgroup-v1: Require capabilities to set release_agent

Georgi Valkov (1):
      ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Greg Kroah-Hartman (1):
      Linux 5.10.97

Kevin Hilman (1):
      Revert "drivers: bus: simple-pm-bus: Add support for probing simple bus only devices"

Lukas Wunner (1):
      PCI: pciehp: Fix infinite loop in IRQ handler upon power fault

Maher Sanalla (1):
      net/mlx5: Use del_timer_sync in fw reset flow of halting poll

Maor Dickman (2):
      net/mlx5e: Fix handling of wrong devices during bond netevent
      net/mlx5: E-Switch, Fix uninitialized variable modact

Maxime Ripard (1):
      drm/vc4: hdmi: Make sure the device is powered with CEC

Raju Rangoju (1):
      net: amd-xgbe: ensure to reset the tx_timer_active flag

Sean Christopherson (1):
      KVM: x86: Forcibly leave nested virt when SMM state is toggled

Shyam Sundar S K (1):
      net: amd-xgbe: Fix skb data length underflow

Suren Baghdasaryan (1):
      psi: Fix uaf issue when psi trigger is destroyed while being polled

Tianchen Ding (1):
      cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()

Tony Luck (2):
      x86/mce: Add Xeon Sapphire Rapids to list of CPUs that support PPIN
      x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN

