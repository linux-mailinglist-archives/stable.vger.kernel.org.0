Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E27585294
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiG2P1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiG2P1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:27:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ED166B8C;
        Fri, 29 Jul 2022 08:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F47A61B7C;
        Fri, 29 Jul 2022 15:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E69C433D7;
        Fri, 29 Jul 2022 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659108464;
        bh=QHj8Su2YhUMbWn63CmDIbJFkOpaUtOwq5F3sd8lPLck=;
        h=From:To:Cc:Subject:Date:From;
        b=2CZsF3qPNqX5PxxDCmzUCJe2ucOFkDRw53r0ExucqnfglVG4kdo1wPcT4oom7+ACm
         1Z8mYH4KGt7wFhGGlZ7HEKpNPrHnF32sqoXuwyaesLO2YkVZx4rUJmIEyI6M3W+DuE
         iUoXQagruKgST6AeCa4RIMNsCUxJ/Xu90rU5XcJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.208
Date:   Fri, 29 Jul 2022 17:27:40 +0200
Message-Id: <165910846038122@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.208 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/Kconfig                                          |   21 -
 arch/alpha/kernel/srmcons.c                           |    2 
 arch/arm/Kconfig                                      |    1 
 arch/arm64/Kconfig                                    |    1 
 arch/riscv/Makefile                                   |    1 
 arch/s390/configs/debug_defconfig                     |    1 
 arch/x86/Kconfig                                      |    1 
 arch/x86/include/asm/asm.h                            |    6 
 arch/x86/include/asm/refcount.h                       |  126 --------
 arch/x86/include/asm/uaccess.h                        |  154 +++++++++-
 arch/x86/include/asm/uaccess_32.h                     |   27 -
 arch/x86/include/asm/uaccess_64.h                     |  108 -------
 arch/x86/kernel/cpu/mce/core.c                        |   34 +-
 arch/x86/mm/extable.c                                 |   49 ---
 drivers/crypto/chelsio/chtls/chtls_cm.c               |    6 
 drivers/gpio/gpio-pca953x.c                           |    3 
 drivers/gpu/drm/i915/Kconfig.debug                    |    1 
 drivers/i2c/busses/i2c-cadence.c                      |   30 --
 drivers/misc/lkdtm/refcount.c                         |    8 
 drivers/net/ethernet/emulex/benet/be_cmds.c           |   10 
 drivers/net/ethernet/emulex/benet/be_cmds.h           |    2 
 drivers/net/ethernet/emulex/benet/be_ethtool.c        |   31 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c           |   13 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c           |    5 
 drivers/net/ethernet/intel/igc/igc_regs.h             |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe.h              |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c        |    6 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c     |    3 
 drivers/net/usb/ax88179_178a.c                        |   16 -
 drivers/pci/controller/pci-hyperv.c                   |  100 +++++-
 drivers/pinctrl/stm32/pinctrl-stm32.c                 |   18 -
 drivers/power/reset/arm-versatile-reboot.c            |    1 
 drivers/s390/char/keyboard.h                          |    4 
 drivers/spi/spi-bcm2835.c                             |   12 
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c       |    2 
 drivers/staging/speakup/spk_ttyio.c                   |    4 
 drivers/tty/cyclades.c                                |    6 
 drivers/tty/goldfish.c                                |    2 
 drivers/tty/moxa.c                                    |    4 
 drivers/tty/pty.c                                     |   14 
 drivers/tty/serial/lpc32xx_hs.c                       |    2 
 drivers/tty/serial/mvebu-uart.c                       |   25 -
 drivers/tty/tty_buffer.c                              |   66 ++--
 drivers/tty/vt/keyboard.c                             |    6 
 drivers/tty/vt/vt.c                                   |    2 
 drivers/xen/gntdev.c                                  |    3 
 fs/dlm/lock.c                                         |    3 
 include/linux/bitfield.h                              |   19 +
 include/linux/mm.h                                    |    1 
 include/linux/mmap_lock.h                             |   54 +++
 include/linux/refcount.h                              |  269 +++++++++++++++---
 include/linux/tty_flip.h                              |    4 
 include/net/bluetooth/bluetooth.h                     |   65 ++++
 include/net/inet_sock.h                               |    5 
 include/net/ip.h                                      |    4 
 include/net/tcp.h                                     |    9 
 include/net/udp.h                                     |    2 
 kernel/bpf/core.c                                     |    8 
 kernel/events/core.c                                  |   45 ++-
 lib/refcount.c                                        |  255 +----------------
 mm/mempolicy.c                                        |    2 
 net/bluetooth/rfcomm/core.c                           |   50 ++-
 net/bluetooth/rfcomm/sock.c                           |   46 ---
 net/bluetooth/sco.c                                   |   30 --
 net/core/filter.c                                     |    4 
 net/core/secure_seq.c                                 |    4 
 net/ipv4/af_inet.c                                    |    4 
 net/ipv4/fib_semantics.c                              |    2 
 net/ipv4/icmp.c                                       |    2 
 net/ipv4/igmp.c                                       |   23 -
 net/ipv4/route.c                                      |    2 
 net/ipv4/syncookies.c                                 |    9 
 net/ipv4/tcp.c                                        |   10 
 net/ipv4/tcp_fastopen.c                               |    4 
 net/ipv4/tcp_input.c                                  |   51 ++-
 net/ipv4/tcp_ipv4.c                                   |    2 
 net/ipv4/tcp_metrics.c                                |    3 
 net/ipv4/tcp_minisocks.c                              |    2 
 net/ipv4/tcp_output.c                                 |   29 +
 net/ipv4/tcp_recovery.c                               |    6 
 net/ipv4/tcp_timer.c                                  |   20 -
 net/ipv6/af_inet6.c                                   |    2 
 net/ipv6/syncookies.c                                 |    3 
 net/sctp/protocol.c                                   |    2 
 net/tls/tls_device.c                                  |    8 
 net/xfrm/xfrm_policy.c                                |    5 
 net/xfrm/xfrm_state.c                                 |    2 
 security/integrity/ima/Kconfig                        |   12 
 security/integrity/ima/ima_policy.c                   |    4 
 sound/core/memalloc.c                                 |    1 
 93 files changed, 1045 insertions(+), 989 deletions(-)

Al Viro (1):
      x86: get rid of small constant size cases in raw_copy_{to,from}_user()

Alexander Aring (1):
      dlm: fix pending remove if msg allocation fails

Ben Dooks (1):
      riscv: add as-options for modules with assembly compontents

Dawid Lukwinski (1):
      i40e: Fix erroneous adapter reinitialization during recovery process

Demi Marie Obenour (1):
      xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Eric Dumazet (1):
      bpf: Make sure mac_header was set before using it

Eric Snowberg (1):
      lockdown: Fix kexec lockdown bypass with ima policy

Fabien Dessenne (1):
      pinctrl: stm32: fix optional IRQ support to gpios

GUO Zihua (1):
      ima: remove the IMA_TEMPLATE Kconfig option

Greg Kroah-Hartman (1):
      Linux 5.4.208

Haibo Chen (1):
      gpio: pca953x: only use single read/write for No AI mode

Hangyu Hua (1):
      xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Hristo Venev (1):
      be2net: Fix buffer overflow in be_get_module_eeprom

Ido Schimmel (1):
      mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication

Jan Beulich (1):
      x86: drop bogus "cc" clobber from __try_cmpxchg_user_asm()

Jeffrey Hugo (4):
      PCI: hv: Fix multi-MSI to allow more than one MSI vector
      PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI
      PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()
      PCI: hv: Fix interrupt mapping for multi-MSI

Jiri Slaby (5):
      tty: drivers/tty/, stop using tty_schedule_flip()
      tty: the rest, stop using tty_schedule_flip()
      tty: drop tty_schedule_flip()
      tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()
      tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

Jose Alonso (1):
      net: usb: ax88179_178a needs FLAG_SEND_ZLP

Junxiao Chang (1):
      net: stmmac: fix dma queue left shift overflow issue

Kuniyuki Iwashima (31):
      ip: Fix data-races around sysctl_ip_no_pmtu_disc.
      ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
      ip: Fix data-races around sysctl_ip_nonlocal_bind.
      ip: Fix a data-race around sysctl_fwmark_reflect.
      tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
      tcp: Fix data-races around sysctl_tcp_mtu_probing.
      tcp: Fix data-races around sysctl_tcp_base_mss.
      tcp: Fix data-races around sysctl_tcp_min_snd_mss.
      tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.
      tcp: Fix a data-race around sysctl_tcp_probe_threshold.
      tcp: Fix a data-race around sysctl_tcp_probe_interval.
      igmp: Fix data-races around sysctl_igmp_llm_reports.
      igmp: Fix a data-race around sysctl_igmp_max_memberships.
      tcp: Fix data-races around sysctl_tcp_syncookies.
      tcp: Fix data-races around sysctl_tcp_reordering.
      tcp: Fix data-races around some timeout sysctl knobs.
      tcp: Fix a data-race around sysctl_tcp_notsent_lowat.
      tcp: Fix a data-race around sysctl_tcp_tw_reuse.
      tcp: Fix data-races around sysctl_max_syn_backlog.
      tcp: Fix data-races around sysctl_tcp_fastopen.
      ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.
      udp: Fix a data-race around sysctl_udp_l3mdev_accept.
      tcp: Fix data-races around sysctl knobs related to SYN option.
      tcp: Fix a data-race around sysctl_tcp_early_retrans.
      tcp: Fix data-races around sysctl_tcp_recovery.
      tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.
      tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.
      tcp: Fix a data-race around sysctl_tcp_retrans_collapse.
      tcp: Fix a data-race around sysctl_tcp_stdurg.
      tcp: Fix a data-race around sysctl_tcp_rfc1337.
      tcp: Fix data-races around sysctl_tcp_max_reordering.

Lennert Buytenhek (1):
      igc: Reinstate IGC_REMOVED logic and implement it properly

Luiz Augusto von Dentz (7):
      Bluetooth: Add bt_skb_sendmsg helper
      Bluetooth: Add bt_skb_sendmmsg helper
      Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg
      Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg
      Bluetooth: Fix passing NULL to PTR_ERR
      Bluetooth: SCO: Fix sco_send_frame returning skb->len
      Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks

Marc Kleine-Budde (1):
      spi: bcm2835: bcm2835_spi_handle_err(): fix NULL pointer deref for non DMA transfers

Miaoqian Lin (1):
      power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Michel Lespinasse (1):
      mmap locking API: initial implementation as rwsem wrappers

Pali Rohár (1):
      serial: mvebu-uart: correctly report configured baudrate value

Peter Zijlstra (3):
      perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()
      x86/uaccess: Implement macros for CMPXCHG on user addresses
      bitfield.h: Fix "type of reg too small for mask" test

Piotr Skajewski (1):
      ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Przemyslaw Patynowski (1):
      iavf: Fix handling of dummy receive descriptors

Robert Hancock (1):
      i2c: cadence: Change large transfer count reset logic to be unconditional

Takashi Iwai (1):
      ALSA: memalloc: Align buffer allocations in page size

Tariq Toukan (1):
      net/tls: Fix race in TLS device down flow

Thomas Gleixner (1):
      x86/mce: Deduplicate exception handling

Wang Cheng (1):
      mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Will Deacon (8):
      locking/refcount: Define constants for saturation and max refcount values
      locking/refcount: Ensure integer operands are treated as signed
      locking/refcount: Remove unused refcount_*_checked() variants
      locking/refcount: Move the bulk of the REFCOUNT_FULL implementation into the <linux/refcount.h> header
      locking/refcount: Improve performance of generic REFCOUNT_FULL code
      locking/refcount: Move saturation warnings out of line
      locking/refcount: Consolidate REFCOUNT_{MAX,SATURATED} definitions
      locking/refcount: Consolidate implementations of refcount_t

William Dean (1):
      pinctrl: ralink: Check for null return of devm_kcalloc

