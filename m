Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591E15A8323
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 18:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiHaQ0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 12:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiHaQ0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 12:26:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1836AA1D38;
        Wed, 31 Aug 2022 09:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97BE0B821EA;
        Wed, 31 Aug 2022 16:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031D6C433D6;
        Wed, 31 Aug 2022 16:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661963190;
        bh=UyZJTqTdSUvb+jogFkSKC5vfFuRntTMJo25Ux2SIGDc=;
        h=From:To:Cc:Subject:Date:From;
        b=broT9i3224/kGgFh5Rs9+Ap04jHGHWUOGpvu3l52nkNRNv0GAtOK2p14kS2e2d/bc
         rB8NP8q60bh0jeu/vrvrN8CuZDLczT2mds6ary1HQ0sD0D3rTxat4XhGdp86njxJpt
         SEyyYTdchV78EFo+dzVN4FE1V5JyZ2s7OOnmda1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.64
Date:   Wed, 31 Aug 2022 18:26:22 +0200
Message-Id: <166196318220670@kroah.com>
X-Mailer: git-send-email 2.37.2
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

I'm announcing the release of the 5.15.64 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu              |    1 
 Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst |   14 
 Documentation/admin-guide/sysctl/net.rst                        |    2 
 Makefile                                                        |    2 
 arch/arm64/kernel/cpu_errata.c                                  |    2 
 arch/parisc/Kconfig                                             |   21 
 arch/parisc/kernel/unaligned.c                                  |    2 
 arch/riscv/include/asm/thread_info.h                            |    2 
 arch/riscv/kernel/traps.c                                       |    3 
 arch/riscv/lib/uaccess.S                                        |   24 
 arch/s390/kernel/process.c                                      |   22 
 arch/s390/mm/fault.c                                            |    4 
 arch/x86/entry/entry_64.S                                       |    8 
 arch/x86/events/intel/ds.c                                      |   10 
 arch/x86/events/intel/lbr.c                                     |    8 
 arch/x86/events/intel/uncore_snb.c                              |   18 
 arch/x86/include/asm/cpufeatures.h                              |    5 
 arch/x86/include/asm/nospec-branch.h                            |   92 
 arch/x86/kernel/cpu/bugs.c                                      |   14 
 arch/x86/kernel/cpu/common.c                                    |   42 
 arch/x86/kernel/unwind_orc.c                                    |   15 
 block/blk-mq.c                                                  |    5 
 drivers/acpi/processor_thermal.c                                |    2 
 drivers/android/binder_alloc.c                                  |   31 
 drivers/base/node.c                                             |    4 
 drivers/base/topology.c                                         |   28 
 drivers/block/loop.c                                            |    5 
 drivers/gpu/drm/nouveau/nouveau_bo.c                            |    9 
 drivers/input/serio/i8042-x86ia64io.h                           | 1251 ++++++----
 drivers/md/md.c                                                 |    3 
 drivers/net/bonding/bond_3ad.c                                  |   38 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c                 |    2 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                  |    2 
 drivers/net/ethernet/intel/ice/ice_xsk.c                        |   14 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                    |   59 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c               |   12 
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                  |    4 
 drivers/net/ethernet/moxa/moxart_ether.c                        |   11 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                 |  109 
 drivers/net/ethernet/pensando/ionic/ionic_main.c                |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c                 |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c               |    9 
 drivers/net/ethernet/sun/cassini.c                              |    4 
 drivers/net/ipa/ipa_mem.c                                       |    2 
 drivers/net/ipvlan/ipvlan_main.c                                |    2 
 drivers/net/ipvlan/ipvtap.c                                     |    4 
 drivers/net/macsec.c                                            |   13 
 drivers/net/macvlan.c                                           |    2 
 drivers/net/phy/phy_device.c                                    |    8 
 drivers/net/usb/r8152.c                                         |   27 
 drivers/net/usb/smsc95xx.c                                      |  139 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c            |    5 
 drivers/nfc/pn533/uart.c                                        |    1 
 drivers/nvme/target/zns.c                                       |    3 
 drivers/scsi/qla2xxx/qla_gbl.h                                  |    2 
 drivers/scsi/qla2xxx/qla_isr.c                                  |   76 
 drivers/scsi/qla2xxx/qla_os.c                                   |   10 
 drivers/scsi/storvsc_drv.c                                      |    2 
 drivers/scsi/ufs/ufshci.h                                       |    6 
 drivers/video/fbdev/core/fbcon.c                                |   27 
 drivers/xen/privcmd.c                                           |   21 
 fs/btrfs/btrfs_inode.h                                          |   12 
 fs/btrfs/ctree.h                                                |   29 
 fs/btrfs/delalloc-space.c                                       |    6 
 fs/btrfs/dev-replace.c                                          |    5 
 fs/btrfs/disk-io.c                                              |    2 
 fs/btrfs/extent_io.c                                            |   18 
 fs/btrfs/inode.c                                                |   40 
 fs/btrfs/root-tree.c                                            |    5 
 fs/btrfs/tree-log.c                                             |   19 
 fs/btrfs/tree-log.h                                             |    2 
 fs/btrfs/volumes.c                                              |    5 
 fs/btrfs/xattr.c                                                |    3 
 fs/btrfs/zoned.c                                                |   20 
 fs/btrfs/zoned.h                                                |    1 
 fs/cifs/smb2ops.c                                               |   12 
 fs/fs-writeback.c                                               |   12 
 fs/io_uring.c                                                   |    7 
 fs/namespace.c                                                  |    7 
 fs/nfs/nfs4file.c                                               |   16 
 fs/ntfs3/xattr.c                                                |   16 
 fs/proc/task_mmu.c                                              |    7 
 fs/zonefs/super.c                                               |    3 
 include/asm-generic/sections.h                                  |    7 
 include/linux/blkdev.h                                          |   11 
 include/linux/cpumask.h                                         |   18 
 include/linux/memcontrol.h                                      |   15 
 include/linux/mlx5/driver.h                                     |    1 
 include/linux/netdevice.h                                       |   20 
 include/linux/netfilter_bridge/ebtables.h                       |    4 
 include/net/busy_poll.h                                         |    2 
 include/net/netfilter/nf_flow_table.h                           |    3 
 include/net/netfilter/nf_tables.h                               |   10 
 include/net/netfilter/nf_tables_core.h                          |    9 
 include/net/tcp.h                                               |    2 
 kernel/audit_fsnotify.c                                         |    1 
 kernel/bpf/verifier.c                                           |   10 
 kernel/cgroup/cgroup.c                                          |    1 
 kernel/sys_ni.c                                                 |    1 
 lib/ratelimit.c                                                 |   12 
 mm/backing-dev.c                                                |   10 
 mm/bootmem_info.c                                               |    2 
 mm/damon/dbgfs.c                                                |    3 
 mm/mmap.c                                                       |    8 
 mm/page-writeback.c                                             |    6 
 net/8021q/vlan_dev.c                                            |    6 
 net/bridge/netfilter/ebtable_broute.c                           |    8 
 net/bridge/netfilter/ebtable_filter.c                           |    8 
 net/bridge/netfilter/ebtable_nat.c                              |    8 
 net/bridge/netfilter/ebtables.c                                 |    8 
 net/core/bpf_sk_storage.c                                       |    5 
 net/core/dev.c                                                  |   18 
 net/core/filter.c                                               |   13 
 net/core/gro_cells.c                                            |    2 
 net/core/skbuff.c                                               |    2 
 net/core/sock.c                                                 |   18 
 net/core/sysctl_net_core.c                                      |   15 
 net/dsa/slave.c                                                 |    4 
 net/hsr/hsr_device.c                                            |    2 
 net/hsr/hsr_main.c                                              |    2 
 net/ipv4/devinet.c                                              |   16 
 net/ipv4/ip_output.c                                            |    2 
 net/ipv4/ip_sockglue.c                                          |    6 
 net/ipv4/tcp.c                                                  |   12 
 net/ipv4/tcp_output.c                                           |    2 
 net/ipv6/addrconf.c                                             |    5 
 net/ipv6/ipv6_sockglue.c                                        |    4 
 net/key/af_key.c                                                |    3 
 net/mptcp/protocol.c                                            |  138 -
 net/netfilter/ipvs/ip_vs_sync.c                                 |    4 
 net/netfilter/nf_flow_table_core.c                              |   15 
 net/netfilter/nf_flow_table_offload.c                           |    8 
 net/netfilter/nf_tables_api.c                                   |   96 
 net/netfilter/nf_tables_core.c                                  |   55 
 net/netfilter/nft_bitwise.c                                     |   67 
 net/netfilter/nft_cmp.c                                         |  140 -
 net/netfilter/nft_immediate.c                                   |   22 
 net/netfilter/nft_osf.c                                         |   18 
 net/netfilter/nft_payload.c                                     |   29 
 net/netfilter/nft_range.c                                       |   27 
 net/netfilter/nft_tunnel.c                                      |    1 
 net/rose/rose_loopback.c                                        |    3 
 net/rxrpc/call_object.c                                         |    4 
 net/rxrpc/sendmsg.c                                             |   92 
 net/sched/sch_generic.c                                         |    2 
 net/socket.c                                                    |    2 
 net/sunrpc/clnt.c                                               |    2 
 net/xfrm/espintcp.c                                             |    2 
 net/xfrm/xfrm_input.c                                           |    2 
 net/xfrm/xfrm_policy.c                                          |    3 
 net/xfrm/xfrm_state.c                                           |    1 
 tools/perf/Makefile.config                                      |    2 
 tools/perf/builtin-stat.c                                       |    1 
 154 files changed, 2270 insertions(+), 1315 deletions(-)

Alex Elder (1):
      net: ipa: don't assume SMEM is page-aligned

Anand Jain (2):
      btrfs: replace: drop assert for suspended replace
      btrfs: add info when mount fails due to stale replace target

Antony Antony (1):
      xfrm: clone missing x->lastused in xfrm_do_migrate

Arun Easi (1):
      scsi: qla2xxx: Fix response queue handler reading stale packets

Aya Levin (1):
      net/mlx5e: Fix wrong application of the LRO state

Badari Pulavarty (1):
      mm/damon/dbgfs: avoid duplicate context directory creation

Bernard Pidoux (1):
      rose: check NULL rose_loopback_neigh->loopback

Brian Foster (1):
      s390: fix double free of GS and RI CBs on fork() failure

Chen Lifu (1):
      riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit

Chen Zhongjin (1):
      x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Christian Brauner (1):
      ntfs: fix acl handling

Christoph Hellwig (1):
      block: add a bdev_max_zone_append_sectors helper

Conor Dooley (1):
      riscv: traps: add missing prototype

Daniel Borkmann (1):
      bpf: Don't use tnum_range on array range checking for poke descriptors

David Hildenbrand (1):
      mm/hugetlb: fix hugetlb not supporting softdirty tracking

David Howells (2):
      rxrpc: Fix locking in rxrpc's sendmsg
      smb3: missing inode locks in punch hole

Duoming Zhou (1):
      nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout

Filipe Manana (3):
      btrfs: put initial index value of a directory in a constant
      btrfs: pass the dentry to btrfs_log_new_name() instead of the inode
      btrfs: fix silent failure when deleting root reference

Florian Westphal (1):
      netfilter: ebtables: reject blobs that don't provide all entry points

Gaosheng Cui (1):
      audit: fix potential double free on error path from fsnotify_add_inode_mark

Gerald Schaefer (1):
      s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Goldwyn Rodrigues (1):
      btrfs: check if root is readonly while setting security xattr

Greg Kroah-Hartman (3):
      Revert "usbnet: smsc95xx: Fix deadlock on runtime resume"
      Revert "usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling"
      Linux 5.15.64

Guoqing Jiang (2):
      Revert "md-raid: destroy the bitmap after destroying the thread"
      md: call __md_stop_writes in md_stop

Hayes Wang (2):
      r8152: fix the units of some registers for RTL8156A
      r8152: fix the RX FIFO settings when suspending

Heiner Kallweit (1):
      net: stmmac: work around sporadic tx issue on link-up

Helge Deller (2):
      parisc: Make CONFIG_64BIT available for ARCH=parisc64 only
      parisc: Fix exception handler for fldw and fstw instructions

Herbert Xu (1):
      af_key: Do not call xfrm_probe_algs in parallel

Ian Rogers (1):
      perf stat: Clear evsel->reset_group for each stat run

Jacob Keller (1):
      ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Jakub Kicinski (2):
      wifi: rtlwifi: remove always-true condition pointed out by GCC 12
      net: use eth_hw_addr_set() instead of ether_addr_copy()

James Clark (1):
      perf python: Fix build when PYTHON_CONFIG is user supplied

Jens Axboe (1):
      io_uring: fix issue with io_write() not always undoing sb_start_write()

Jeremy Sowden (1):
      netfilter: bitwise: improve error goto labels

Jing-Ting Wu (1):
      cgroup: Fix race condition at rebind_subsystems()

Jisheng Zhang (1):
      riscv: lib: uaccess: fold fixups into body

Jonathan Toppins (1):
      bonding: 802.3ad: fix no transmission of LACPDUs

Juergen Gross (1):
      xen/privcmd: fix error exit of privcmd_ioctl_dm_op()

Kan Liang (1):
      perf/x86/lbr: Enable the branch type for the Arch LBR by default

Karol Herbst (1):
      nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf

Khazhismel Kumykov (1):
      writeback: avoid use-after-free after removing device

Kiwoong Kim (1):
      scsi: ufs: core: Enable link lost interrupt

Kuniyuki Iwashima (15):
      net: Fix data-races around sysctl_[rw]mem_(max|default).
      net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
      net: Fix data-races around netdev_max_backlog.
      net: Fix data-races around netdev_tstamp_prequeue.
      ratelimit: Fix data-races in ___ratelimit().
      net: Fix data-races around sysctl_optmem_max.
      net: Fix a data-race around sysctl_tstamp_allow_data.
      net: Fix a data-race around sysctl_net_busy_poll.
      net: Fix a data-race around sysctl_net_busy_read.
      net: Fix a data-race around netdev_budget.
      net: Fix data-races around sysctl_max_skb_frags.
      net: Fix a data-race around netdev_budget_usecs.
      net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
      net: Fix data-races around sysctl_devconf_inherit_init_net.
      net: Fix a data-race around sysctl_somaxconn.

Lai Jiangshan (1):
      x86/entry: Move CLD to the start of the idtentry macro

Liam Howlett (1):
      binder_alloc: add missing mmap_lock calls when using the VMA

Liu Shixin (1):
      bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem

Maciej Fijalkowski (2):
      ice: xsk: Force rings to be sized to power of 2
      ice: xsk: prohibit usage of non-balanced queue id

Maciej Żenczykowski (1):
      net: ipvtap - add __init/__exit annotations to module init/exit funcs

Maor Dickman (1):
      net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off

Martin Liška (1):
      eth: sun: cassini: remove dead code

Moshe Shemesh (1):
      net/mlx5: Avoid false positive lockdep warning by adding lock_class_key

Naohiro Aota (4):
      block: add bdev_max_segments() helper
      btrfs: zoned: revive max_zone_append_bytes
      btrfs: replace BTRFS_MAX_EXTENT_SIZE with fs_info->max_extent_size
      btrfs: convert count_max_extents() to use fs_info->max_extent_size

Nikolay Aleksandrov (1):
      xfrm: policy: fix metadata dst->dev xmit null pointer dereference

Olga Kornievskaia (1):
      NFSv4.2 fix problems with __nfs42_ssc_open

Pablo Neira Ayuso (14):
      netfilter: nf_tables: disallow updates of implicit chain
      netfilter: nf_tables: make table handle allocation per-netns friendly
      netfilter: nft_payload: report ERANGE for too long offset and length
      netfilter: nft_payload: do not truncate csum_offset and csum_type
      netfilter: nf_tables: do not leave chain stats enabled on error
      netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families
      netfilter: nft_tunnel: restrict it to netdev family
      netfilter: nf_tables: consolidate rule verdict trace call
      netfilter: nft_cmp: optimize comparison for 16-bytes
      netfilter: nf_tables: upfront validation of data via nft_data_init()
      netfilter: nf_tables: disallow jump to implicit chain from set element
      netfilter: nf_tables: disallow binding to already bound chain
      netfilter: flowtable: add function to invoke garbage collection immediately
      netfilter: flowtable: fix stuck flows on cleanup due to pending work

Paolo Abeni (2):
      tcp: expose the tcp_mark_push() and tcp_skb_entail() helpers
      mptcp: stop relying on tcp_tx_skb_cache

Pawan Gupta (1):
      x86/bugs: Add "unknown" reporting for MMIO Stale Data

Peter Xu (1):
      mm/smaps: don't access young/dirty bit if pte unpresent

Peter Zijlstra (2):
      x86/nospec: Unwreck the RSB stuffing
      x86/nospec: Fix i386 RSB stuffing

Phil Auld (1):
      drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist

Qu Wenruo (1):
      btrfs: remove unnecessary parameter delalloc_start for writepage_delalloc()

Quanyang Wang (1):
      asm-generic: sections: refactor memory_intersects

Quinn Tran (1):
      scsi: qla2xxx: edif: Fix dropped IKE message

R Mohamed Shah (1):
      ionic: VF initial random MAC address if no assigned mac

Randy Dunlap (1):
      kernel/sys_ni: add compat entry for fadvise64_64

Riwen Lu (1):
      ACPI: processor: Remove freq Qos request for all CPUs

Sabrina Dubroca (1):
      Revert "net: macsec: update SCI upon MAC address change."

Salvatore Bonaccorso (1):
      Documentation/ABI: Mention retbleed vulnerability info file for sysfs

Saurabh Sengar (1):
      scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Sergei Antonov (1):
      net: moxa: get rid of asymmetry in DMA mapping/unmapping

Seth Forshee (1):
      fs: require CAP_SYS_ADMIN in target namespace for idmapped mounts

Shakeel Butt (1):
      Revert "memcg: cleanup racy sum avoidance code"

Shannon Nelson (3):
      ionic: widen queue_lock use around lif init and deinit
      ionic: clear broken state on generation change
      ionic: fix up issues with handling EAGAIN on FW cmds

Shigeru Yoshida (1):
      fbdev: fbcon: Properly revert changes when vc_resize() failed

Siddh Raman Pant (1):
      loop: Check for overflow while configuring loop

Stephane Eranian (2):
      perf/x86/intel/uncore: Fix broken read_counter() for SNB IMC PMU
      perf/x86/intel/ds: Fix precise store latency handling

Sylwester Dziedziuch (1):
      i40e: Fix incorrect address type for IPv6 flow rules

Trond Myklebust (2):
      NFS: Don't allocate nfs_fattr on the stack in __nfs42_ssc_open()
      SUNRPC: RPC level errors should set task->tk_rpc_status

Vikas Gupta (1):
      bnxt_en: fix NQ resource accounting during vf creation on 57500 chips

Vlad Buslov (1):
      net/mlx5e: Properly disable vlan strip on non-UL reps

Werner Sembach (4):
      Input: i8042 - move __initconst to fix code styling warning
      Input: i8042 - merge quirk tables
      Input: i8042 - add TUXEDO devices to i8042 quirk tables
      Input: i8042 - add additional TUXEDO devices to i8042 quirk tables

Xiaolei Wang (1):
      net: phy: Don't WARN for PHY_READY state in mdio_bus_phy_resume()

Xin Xiong (1):
      xfrm: fix refcount leak in __xfrm_policy_check()

Yonglong Li (1):
      mptcp: Fix crash due to tcp_tsorted_anchor was initialized before release skb

Yu Kuai (1):
      blk-mq: fix io hung due to missing commit_rqs

Zenghui Yu (1):
      arm64: Fix match_list for erratum 1286807 on Arm Cortex-A76

Zixuan Fu (1):
      btrfs: fix possible memory leak in btrfs_get_dev_args_from_path()

