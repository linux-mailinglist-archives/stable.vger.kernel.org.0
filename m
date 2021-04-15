Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926EA360D76
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhDOPCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235041AbhDOPAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3A616140F;
        Thu, 15 Apr 2021 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498573;
        bh=ZeeQGYFOw0NUoyqQBx0D5YUbuk/FE66CVyyBqSAdoZs=;
        h=From:To:Cc:Subject:Date:From;
        b=lDRDNg88YtW9mV0CKoOS3G1auviRTlzsVuDoPPle5VVkWbrqulOFnZ3WPnY2XDUfs
         SjaWrqnDQEo8sYmqD2aeMyadW0vkLZlu2ZOLzqml+OxQFUMr7YfqfQtTRwrIFtfikN
         jA5uJ10w0IzuJg0iehGmhG+HwTPT6Z4Fjlwq5SIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/13] 4.19.188-rc1 review
Date:   Thu, 15 Apr 2021 16:47:49 +0200
Message-Id: <20210415144411.596695196@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.188-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.188-rc1
X-KernelTest-Deadline: 2021-04-17T14:44+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.188 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.188-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.188-rc1

Juergen Gross <jgross@suse.com>
    xen/events: fix setting irq affinity

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches

Saravana Kannan <saravanak@google.com>
    driver core: Fix locking bug in deferred_probe_timeout_work_func()

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: fix compat match/target pad out-of-bound write

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: m57621-mmc: delete driver from the tree.

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Only advertise EEE for supported modes

Zihao Yu <yuzihao@ict.ac.cn>
    riscv,entry: fix misaligned base for excp_vect_table

Yufen Yu <yuyufen@huawei.com>
    block: only update parent bi_status when bio fail

Dmitry Osipenko <digetx@gmail.com>
    drm/tegra: dc: Don't set PLL clock to 0Hz

Bob Peterson <rpeterso@redhat.com>
    gfs2: report "already frozen/thawed" errors

Arnd Bergmann <arnd@arndb.de>
    drm/imx: imx-ldb: fix out of bounds array access warning

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: Disable guest access to trace filter controls

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: Hide system instruction access to Trace registers


-------------

Diffstat:

 Makefile                               |    4 +-
 arch/arm64/include/asm/kvm_arm.h       |    1 +
 arch/arm64/kernel/cpufeature.c         |    1 -
 arch/arm64/kvm/debug.c                 |    2 +
 arch/riscv/kernel/entry.S              |    1 +
 block/bio.c                            |    2 +-
 drivers/base/dd.c                      |    8 +-
 drivers/gpu/drm/imx/imx-ldb.c          |   10 +
 drivers/gpu/drm/tegra/dc.c             |   10 +-
 drivers/net/phy/bcm-phy-lib.c          |   11 +-
 drivers/staging/Kconfig                |    2 -
 drivers/staging/Makefile               |    1 -
 drivers/staging/mt7621-mmc/Kconfig     |   16 -
 drivers/staging/mt7621-mmc/Makefile    |   42 -
 drivers/staging/mt7621-mmc/TODO        |    8 -
 drivers/staging/mt7621-mmc/board.h     |   63 -
 drivers/staging/mt7621-mmc/dbg.c       |  307 ----
 drivers/staging/mt7621-mmc/dbg.h       |  149 --
 drivers/staging/mt7621-mmc/mt6575_sd.h |  488 -------
 drivers/staging/mt7621-mmc/sd.c        | 2392 --------------------------------
 drivers/xen/events/events_base.c       |    4 +-
 fs/gfs2/super.c                        |   10 +-
 net/ipv4/netfilter/arp_tables.c        |    2 +
 net/ipv4/netfilter/ip_tables.c         |    2 +
 net/ipv6/netfilter/ip6_tables.c        |    2 +
 net/netfilter/x_tables.c               |   10 +-
 tools/perf/util/map.c                  |    7 +-
 27 files changed, 54 insertions(+), 3501 deletions(-)


