Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA6331AB98
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 14:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhBMNRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 08:17:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhBMNRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 08:17:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C652464D9F;
        Sat, 13 Feb 2021 13:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613222213;
        bh=0e4soisvDNl/+uI00WomrET9pQegzHfCyLAgz/U1a/A=;
        h=From:To:Cc:Subject:Date:From;
        b=ZxRmV9PjS3mGUaRGPQnVZmGISqAm6EINAD9oWHctIYRNtABGVKouiO3PwT69s1Pdk
         eb62ZWZk1fzJS15G5z0xKso+lRyRt665czG+boonD42Bg0NN+NgPQiqR4qObdHRVQf
         wYgG54Bpqb8OXn9T6cazvl8ZljHWEIL38/ux1Uos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.176
Date:   Sat, 13 Feb 2021 14:16:49 +0100
Message-Id: <1613222209101211@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.176 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/x86/kvm/svm.c                                       |   18 +--
 block/blk-mq.c                                           |    7 -
 block/elevator.c                                         |   14 --
 block/genhd.c                                            |   10 +
 drivers/crypto/chelsio/chtls/chtls_cm.c                  |    7 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c     |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c             |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |   11 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c             |    5 
 drivers/regulator/core.c                                 |   84 ++++++++++-----
 drivers/remoteproc/qcom_q6v5_pil.c                       |   11 +
 fs/fs-writeback.c                                        |    2 
 fs/nfs/pnfs.c                                            |    8 +
 fs/squashfs/export.c                                     |   41 +++++--
 fs/squashfs/id.c                                         |   40 +++++--
 fs/squashfs/squashfs_fs_sb.h                             |    1 
 fs/squashfs/super.c                                      |    6 -
 fs/squashfs/xattr.h                                      |   10 +
 fs/squashfs/xattr_id.c                                   |   66 ++++++++++-
 include/linux/backing-dev.h                              |   10 +
 include/linux/kprobes.h                                  |    2 
 include/linux/string.h                                   |    4 
 include/linux/sunrpc/xdr.h                               |    3 
 include/trace/events/writeback.h                         |   35 +++---
 init/init_task.c                                         |    3 
 kernel/kprobes.c                                         |   34 ++++--
 kernel/trace/ftrace.c                                    |    2 
 kernel/trace/trace_kprobe.c                              |    4 
 lib/string.c                                             |   47 +++++++-
 mm/backing-dev.c                                         |    1 
 net/key/af_key.c                                         |    6 -
 net/sunrpc/auth_gss/auth_gss.c                           |   30 -----
 net/sunrpc/auth_gss/auth_gss_internal.h                  |   45 ++++++++
 net/sunrpc/auth_gss/gss_krb5_mech.c                      |   31 -----
 35 files changed, 410 insertions(+), 196 deletions(-)

Cong Wang (1):
      af_key: relax availability checks for skb size calculation

Dave Wysochanski (2):
      SUNRPC: Move simple_get_bytes and simple_get_netobj into private header
      SUNRPC: Handle 0 length opaque XDR object data properly

David Collins (1):
      regulator: core: avoid regulator_resolve_supply() race condition

Douglas Anderson (1):
      regulator: core: Clean enabling always-on regulators + their supplies

Emmanuel Grumbach (1):
      iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap

Greg Kroah-Hartman (1):
      Linux 4.19.176

Johannes Berg (3):
      iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
      iwlwifi: pcie: fix context info memory leak
      iwlwifi: mvm: guard against device removal in reprobe

Mark Brown (1):
      regulator: Fix lockdep warning resolving supplies

Masami Hiramatsu (1):
      tracing/kprobe: Fix to support kretprobe events on unloaded modules

Ming Lei (2):
      block: don't hold q->sysfs_lock in elevator_init_mq
      blk-mq: don't hold q->sysfs_lock in blk_mq_map_swqueue

Olliver Schinagl (1):
      regulator: core: enable power when setting up constraints

Pan Bian (1):
      chtls: Fix potential resource leak

Peter Gonda (1):
      Fix unsynchronized access to sev members through svm_register_enc_region

Phillip Lougher (3):
      squashfs: add more sanity checks in id lookup
      squashfs: add more sanity checks in inode lookup
      squashfs: add more sanity checks in xattr id lookup

Qian Cai (1):
      include/trace/events/writeback.h: fix -Wstringop-truncation warnings

Sibi Sankar (2):
      remoteproc: qcom_q6v5_mss: Validate modem blob firmware size before load
      remoteproc: qcom_q6v5_mss: Validate MBA firmware size before load

Steven Rostedt (VMware) (1):
      fgraph: Initialize tracing_graph_pause at task creation

Theodore Ts'o (1):
      memcg: fix a crash in wb_workfn when a device disappears

Tobin C. Harding (1):
      lib/string: Add strscpy_pad() function

Trond Myklebust (1):
      pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()

zhengbin (1):
      block: fix NULL pointer dereference in register_disk

