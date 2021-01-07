Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E122ED266
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbhAGOc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:32:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbhAGOcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D20C82339E;
        Thu,  7 Jan 2021 14:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029935;
        bh=oQCAdKBhBf945heMM3FL9MYQ0pO6oTGuWLQQLIFF7HA=;
        h=From:To:Cc:Subject:Date:From;
        b=XJJsdL2GEGFvkllAqNX8p1vYVzhju+EPn4/DFxoSgGolZ/Dk8CVKDXmvMRwMr/rB8
         s6oeuwvITztrB61cHKsigRH4wSylfympVxq0HLElGMPZMcAkCxTX7QjUqFxMB4Mw/e
         a3ekgzQ4ByMfZ75Umo5qKCaKXBqmL31MIExHivqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/13] 5.4.88-rc1 review
Date:   Thu,  7 Jan 2021 15:33:19 +0100
Message-Id: <20210107143049.929352526@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.88-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.88-rc1
X-KernelTest-Deadline: 2021-01-09T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.88 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.88-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.88-rc1

Zhang Xiaohui <ruc_zhangxiaohui@163.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

Eric W. Biederman <ebiederm@xmission.com>
    exec: Transform exec_update_mutex into a rw_semaphore

Eric W. Biederman <ebiederm@xmission.com>
    rwsem: Implement down_read_interruptible

Eric W. Biederman <ebiederm@xmission.com>
    rwsem: Implement down_read_killable_nested

peterz@infradead.org <peterz@infradead.org>
    perf: Break deadlock involving exec_update_mutex

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix bad inode

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:bmi160: Fix alignment and data leak issues

Josh Poimboeuf <jpoimboe@redhat.com>
    kdev_t: always inline major/minor helper functions

Yu Kuai <yukuai3@huawei.com>
    dmaengine: at_hdmac: add missing kfree() call in at_dma_xlate()

Yu Kuai <yukuai3@huawei.com>
    dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Substitute kzalloc with kmalloc

Felix Fietkau <nbd@nbd.name>
    Revert "mtd: spinand: Fix OOB read"

Alex Deucher <alexdeucher@gmail.com>
    Revert "drm/amd/display: Fix memory leaks in S3 resume"


-------------

Diffstat:

 Makefile                                          |  4 +-
 drivers/dma/at_hdmac.c                            | 11 +++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  3 +-
 drivers/iio/imu/bmi160/bmi160.h                   |  7 +++
 drivers/iio/imu/bmi160/bmi160_core.c              |  6 +--
 drivers/mtd/nand/spi/core.c                       |  4 --
 drivers/net/wireless/marvell/mwifiex/join.c       |  2 +
 fs/exec.c                                         | 12 +++---
 fs/fuse/acl.c                                     |  6 +++
 fs/fuse/dir.c                                     | 37 +++++++++++++---
 fs/fuse/file.c                                    | 19 +++++----
 fs/fuse/fuse_i.h                                  | 12 ++++++
 fs/fuse/inode.c                                   |  4 +-
 fs/fuse/readdir.c                                 |  4 +-
 fs/fuse/xattr.c                                   |  9 ++++
 fs/proc/base.c                                    | 10 ++---
 include/linux/kdev_t.h                            | 22 +++++-----
 include/linux/rwsem.h                             |  3 ++
 include/linux/sched/signal.h                      | 11 ++---
 init/init_task.c                                  |  2 +-
 kernel/events/core.c                              | 52 +++++++++++------------
 kernel/fork.c                                     |  6 +--
 kernel/kcmp.c                                     | 30 ++++++-------
 kernel/locking/rwsem.c                            | 40 +++++++++++++++++
 24 files changed, 212 insertions(+), 104 deletions(-)


