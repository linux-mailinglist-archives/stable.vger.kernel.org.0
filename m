Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5B4F6A44
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfKJQuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKJQuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 11:50:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C3A2080F;
        Sun, 10 Nov 2019 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573404605;
        bh=TUxbmXteAyuys1U1R92N8dKsQyLQg2136wURsEbnFuA=;
        h=Date:From:To:Cc:Subject:From;
        b=g3EQpZ+MI93LJPNWw+gwVGIZtcrTz/lOTcS5xm6FHKkcEjHL5lSVvoclPvyeLO8IP
         Dcqj1mPQAoHgGjYAjgMIiMN7EW5Nq7CfUV89+s5kY1C73H3OIdqFAs8yh3AajbEMFE
         KX0sx3SVmbZcOU0NhjfVVY+mlhwki3gWd2br54wc=
Date:   Sun, 10 Nov 2019 17:50:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.200
Message-ID: <20191110165001.GA2872916@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.200 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    8 
 arch/arm/Kconfig                                      |    3 
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi            |    4 
 arch/arm/include/asm/arch_gicv3.h                     |   27 -
 arch/arm/include/asm/assembler.h                      |   23 +
 arch/arm/include/asm/barrier.h                        |   34 ++
 arch/arm/include/asm/bugs.h                           |    6 
 arch/arm/include/asm/cp15.h                           |   18 +
 arch/arm/include/asm/cputype.h                        |    9 
 arch/arm/include/asm/proc-fns.h                       |   65 +++-
 arch/arm/include/asm/system_misc.h                    |   15 
 arch/arm/include/asm/thread_info.h                    |    8 
 arch/arm/include/asm/uaccess.h                        |  177 ++++++-----
 arch/arm/kernel/Makefile                              |    4 
 arch/arm/kernel/armksyms.c                            |    6 
 arch/arm/kernel/bugs.c                                |   18 +
 arch/arm/kernel/entry-common.S                        |   18 -
 arch/arm/kernel/entry-header.S                        |   25 +
 arch/arm/kernel/head-common.S                         |    6 
 arch/arm/kernel/psci-call.S                           |   31 -
 arch/arm/kernel/setup.c                               |   40 +-
 arch/arm/kernel/signal.c                              |  125 ++++---
 arch/arm/kernel/smccc-call.S                          |   62 +++
 arch/arm/kernel/smp.c                                 |   36 ++
 arch/arm/kernel/suspend.c                             |    2 
 arch/arm/kernel/sys_oabi-compat.c                     |   16 -
 arch/arm/lib/copy_from_user.S                         |    5 
 arch/arm/mm/Kconfig                                   |   23 +
 arch/arm/mm/Makefile                                  |    2 
 arch/arm/mm/alignment.c                               |   44 ++
 arch/arm/mm/fault.c                                   |    3 
 arch/arm/mm/proc-macros.S                             |   13 
 arch/arm/mm/proc-v7-2level.S                          |    6 
 arch/arm/mm/proc-v7-bugs.c                            |  161 ++++++++++
 arch/arm/mm/proc-v7.S                                 |  154 +++++++--
 arch/arm/vfp/vfpmodule.c                              |   37 --
 arch/arm64/Kconfig                                    |    1 
 arch/arm64/kernel/Makefile                            |    4 
 arch/arm64/kernel/arm64ksyms.c                        |    5 
 arch/arm64/kernel/asm-offsets.c                       |    3 
 arch/arm64/kernel/psci-call.S                         |   28 -
 arch/arm64/kernel/smccc-call.S                        |   43 ++
 arch/mips/bcm63xx/prom.c                              |    2 
 arch/mips/include/asm/bmips.h                         |   10 
 arch/mips/kernel/smp-bmips.c                          |    8 
 drivers/dma/qcom_bam_dma.c                            |   14 
 drivers/firmware/Kconfig                              |    3 
 drivers/firmware/psci.c                               |   78 ++++
 drivers/net/ethernet/hisilicon/hip04_eth.c            |   15 
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |   42 +-
 drivers/net/vxlan.c                                   |    5 
 drivers/of/unittest.c                                 |    1 
 drivers/regulator/pfuze100-regulator.c                |    8 
 drivers/regulator/ti-abb-regulator.c                  |   26 -
 drivers/scsi/Kconfig                                  |    2 
 drivers/scsi/sni_53c710.c                             |    4 
 drivers/target/target_core_device.c                   |   21 -
 fs/cifs/cifsglob.h                                    |    5 
 fs/cifs/cifsproto.h                                   |    1 
 fs/cifs/file.c                                        |   23 -
 fs/cifs/smb2file.c                                    |    2 
 fs/dcache.c                                           |    2 
 include/linux/arm-smccc.h                             |  283 ++++++++++++++++++
 include/linux/gfp.h                                   |   23 +
 include/linux/psci.h                                  |   13 
 include/linux/skbuff.h                                |    3 
 include/net/flow_dissector.h                          |    3 
 include/net/sock.h                                    |   11 
 kernel/time/alarmtimer.c                              |    4 
 net/core/datagram.c                                   |    2 
 net/core/ethtool.c                                    |    4 
 net/core/flow_dissector.c                             |   48 +--
 net/dccp/ipv4.c                                       |    4 
 net/ipv4/datagram.c                                   |    2 
 net/ipv4/tcp_ipv4.c                                   |    4 
 net/sched/sch_fq_codel.c                              |    6 
 net/sched/sch_hhf.c                                   |    8 
 net/sched/sch_sfb.c                                   |   13 
 net/sched/sch_sfq.c                                   |   14 
 net/sctp/socket.c                                     |    2 
 sound/soc/rockchip/rockchip_i2s.c                     |    2 
 tools/perf/builtin-kmem.c                             |    1 
 82 files changed, 1555 insertions(+), 485 deletions(-)

Adam Ford (1):
      ARM: dts: logicpd-torpedo-som: Remove twl_keypad

Andrey Ryabinin (1):
      ARM: 8051/1: put_user: fix possible data corruption in put_user

Axel Lin (1):
      regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all_txdone

Bodo Stroesser (1):
      scsi: target: core: Do not overwrite CDB byte 1

Dave Wysochanski (1):
      cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Eran Ben Elisha (1):
      net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Eric Dumazet (4):
      dccp: do not leak jiffies on the wire
      net: add READ_ONCE() annotation in __skb_wait_for_more_packets()
      inet: stop leaking jiffies on the wire
      net/flow_dissector: switch to siphash

Greg Kroah-Hartman (1):
      Linux 4.4.200

Jeffrey Hugo (1):
      dmaengine: qcom: bam_dma: Fix resource leak

Jens Wiklander (4):
      ARM: 8478/2: arm/arm64: add arm-smccc
      ARM: 8479/2: add implementation for arm-smccc
      ARM: 8480/2: arm64: add implementation for arm-smccc
      ARM: 8481/2: drivers: psci: replace psci firmware calls

Jiangfeng Xiao (1):
      net: hisilicon: Fix ping latency when deal with high throughput

Jonas Gorski (1):
      MIPS: bmips: mark exception vectors as char arrays

Julien Thierry (8):
      ARM: 8789/1: signal: copy registers using __copy_to_user()
      ARM: 8791/1: vfp: use __copy_to_user() when saving VFP state
      ARM: 8792/1: oabi-compat: copy oabi events using __copy_to_user()
      ARM: 8793/1: signal: replace __put_user_error with __put_user
      ARM: 8794/1: uaccess: Prevent speculative use of the current addr_limit
      ARM: 8795/1: spectre-v1.1: use put_user() for __put_user()
      ARM: 8796/1: spectre-v1,v1.1: provide helpers for address sanitization
      ARM: 8810/1: vfp: Fix wrong assignement to ufp_exc

Marc Zyngier (9):
      arm/arm64: KVM: Advertise SMCCC v1.1
      arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
      firmware/psci: Expose PSCI conduit
      firmware/psci: Expose SMCCC version through psci_ops
      arm/arm64: smccc: Make function identifiers an unsigned quantity
      arm/arm64: smccc: Implement SMCCC v1.1 inline primitive
      arm/arm64: smccc: Add SMCCC-specific return codes
      arm/arm64: smccc-1.1: Make return values unsigned long
      arm/arm64: smccc-1.1: Handle function result as parameters

Navid Emamdoost (1):
      of: unittest: fix memory leak in unittest_data_add

Petr Vorel (1):
      alarmtimer: Change remaining ENOTSUPP to EOPNOTSUPP

Robin Murphy (1):
      ASoc: rockchip: i2s: Fix RPM imbalance

Russell King (28):
      ARM: mm: fix alignment handler faults under memory pressure
      ARM: uaccess: remove put_user() code duplication
      ARM: add more CPU part numbers for Cortex and Brahma B15 CPUs
      ARM: bugs: prepare processor bug infrastructure
      ARM: bugs: hook processor bug checking into SMP and suspend paths
      ARM: bugs: add support for per-processor bug checking
      ARM: spectre: add Kconfig symbol for CPUs vulnerable to Spectre
      ARM: spectre-v2: harden branch predictor on context switches
      ARM: spectre-v2: add Cortex A8 and A15 validation of the IBE bit
      ARM: spectre-v2: harden user aborts in kernel space
      ARM: spectre-v2: add firmware based hardening
      ARM: spectre-v2: warn about incorrect context switching functions
      ARM: spectre-v1: add speculation barrier (csdb) macros
      ARM: spectre-v1: add array_index_mask_nospec() implementation
      ARM: spectre-v1: fix syscall entry
      ARM: signal: copy registers using __copy_from_user()
      ARM: vfp: use __copy_from_user() when restoring VFP state
      ARM: oabi-compat: copy semops using __copy_from_user()
      ARM: use __inttype() in get_user()
      ARM: spectre-v1: use get_user() for __get_user()
      ARM: spectre-v1: mitigate user accesses
      ARM: make lookup_processor_type() non-__init
      ARM: split out processor lookup
      ARM: clean up per-processor check_bugs method call
      ARM: add PROC_VTABLE and PROC_TABLE macros
      ARM: spectre-v2: per-CPU vtables to work around big.Little systems
      ARM: ensure that processor vtables is not lost after boot
      ARM: fix the cockup in the previous patch

Seth Forshee (1):
      kbuild: add -fcf-protection=none when using retpoline flags

Tejun Heo (1):
      net: fix sk_page_frag() recursion from memory reclaim

Thomas Bogendoerfer (2):
      scsi: sni_53c710: fix compilation error
      scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE

Vladimir Murzin (1):
      ARM: Move system register accessors to asm/cp15.h

Xin Long (1):
      vxlan: check tun_info options_len properly

Yizhuo (1):
      regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_probe() could be uninitialized

Yunfeng Ye (1):
      perf kmem: Fix memory leak in compact_gfp_flags()

zhanglin (1):
      net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()

zhangyi (F) (1):
      fs/dcache: move security_d_instantiate() behind attaching dentry to inode

