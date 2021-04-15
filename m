Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B15360DE1
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhDOPGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235294AbhDOPFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AFE7613D1;
        Thu, 15 Apr 2021 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498744;
        bh=nzaxLHkjHYa3HN+nGIPCswQzLjlZZQqJtlgcTGYcBj8=;
        h=From:To:Cc:Subject:Date:From;
        b=sR/PWrG3z9M0v74aLttTaATpphqqg7xHkCHv34JWw4URBausPQD4ev9jmVyaBIQlv
         Jz5vRz9lhFFhCzOhGo9vXcI5OH1Aaz06IuAgsN+FVUyIalAV1Qv66qC14tCNcBJZjM
         zhW+Cm/0Hu8GsZH+C48pTOShIHGyNA/Xdh73TeTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 00/23] 5.11.15-rc1 review
Date:   Thu, 15 Apr 2021 16:48:07 +0200
Message-Id: <20210415144413.146131392@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.15-rc1
X-KernelTest-Deadline: 2021-04-17T14:44+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.15 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.15-rc1

Russell King <rmk+kernel@armlinux.org.uk>
    net: sfp: cope with SFPs that set both LOS normal and LOS inverted

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: fix compat match/target pad out-of-bound write

Pavel Begunkov <asml.silence@gmail.com>
    block: don't ignore REQ_NOWAIT for direct IO

Zihao Yu <yuzihao@ict.ac.cn>
    riscv,entry: fix misaligned base for excp_vect_table

Jens Axboe <axboe@kernel.dk>
    io_uring: don't mark S_ISBLK async work as unbounded

Damien Le Moal <damien.lemoal@wdc.com>
    null_blk: fix command timeout completion handling

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr test suite: Create anchor before launching throbber

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr test suite: Take RCU read lock in idr_find_test_1

Matthew Wilcox (Oracle) <willy@infradead.org>
    radix tree test suite: Register the main thread with the RCU library

Yufen Yu <yuyufen@huawei.com>
    block: only update parent bi_status when bio fail

Matthew Wilcox (Oracle) <willy@infradead.org>
    radix tree test suite: Fix compilation

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix splitting to non-zero orders

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Use different lock classes for each client

Dmitry Osipenko <digetx@gmail.com>
    drm/tegra: dc: Don't set PLL clock to 0Hz

Stefan Raspl <raspl@linux.ibm.com>
    tools/kvm_stat: Add restart delay

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Check if pages were allocated before calling free_pages()

Bob Peterson <rpeterso@redhat.com>
    gfs2: report "already frozen/thawed" errors

Arnd Bergmann <arnd@arndb.de>
    drm/imx: imx-ldb: fix out of bounds array access warning

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: Disable guest access to trace filter controls

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: Hide system instruction access to Trace registers

Andrew Price <anprice@redhat.com>
    gfs2: Flag a withdraw if init_threads() fails

Jia-Ju Bai <baijiaju1990@gmail.com>
    interconnect: core: fix error return code of icc_link_destroy()


-------------

Diffstat:

 Makefile                                        |  4 +--
 arch/arm64/include/asm/kvm_arm.h                |  1 +
 arch/arm64/kernel/cpufeature.c                  |  1 -
 arch/arm64/kvm/debug.c                          |  2 ++
 arch/riscv/kernel/entry.S                       |  1 +
 block/bio.c                                     |  2 +-
 drivers/block/null_blk/main.c                   | 26 ++++++++++++++----
 drivers/block/null_blk/null_blk.h               |  1 +
 drivers/gpu/drm/imx/imx-ldb.c                   | 10 +++++++
 drivers/gpu/drm/tegra/dc.c                      | 10 +++----
 drivers/gpu/host1x/bus.c                        | 10 ++++---
 drivers/interconnect/core.c                     |  2 ++
 drivers/net/phy/sfp.c                           | 36 +++++++++++++++----------
 fs/block_dev.c                                  |  4 +++
 fs/gfs2/super.c                                 | 14 ++++++----
 fs/io_uring.c                                   |  2 +-
 include/linux/host1x.h                          |  9 ++++++-
 kernel/trace/ftrace.c                           |  9 ++++---
 lib/test_xarray.c                               | 26 +++++++++---------
 lib/xarray.c                                    |  4 +--
 net/ipv4/netfilter/arp_tables.c                 |  2 ++
 net/ipv4/netfilter/ip_tables.c                  |  2 ++
 net/ipv6/netfilter/ip6_tables.c                 |  2 ++
 net/netfilter/x_tables.c                        | 10 ++-----
 tools/kvm/kvm_stat/kvm_stat.service             |  1 +
 tools/perf/util/map.c                           |  7 +++--
 tools/testing/radix-tree/idr-test.c             | 10 +++++--
 tools/testing/radix-tree/linux/compiler_types.h |  0
 tools/testing/radix-tree/multiorder.c           |  2 ++
 tools/testing/radix-tree/xarray.c               |  2 ++
 30 files changed, 142 insertions(+), 70 deletions(-)


