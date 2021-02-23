Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619533227DB
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhBWJbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:31:32 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:36014 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231314AbhBWJ3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 04:29:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UPM39J1_1614072539;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPM39J1_1614072539)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 17:29:00 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        jefflexu@linux.alibaba.com, hare@suse.com
Subject: [PATCH v2 4.19 0/6] close udev startup race condition for several devices
Date:   Tue, 23 Feb 2021 17:28:53 +0800
Message-Id: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please refer to v1 ([1]) and background ([2]) for more details.

As Sasha suggested in [3], revert commit 9e07f4e24379 ("zram: close udev
startup race condition as default groups") first, and then apply the
original patch set.

- patch 5: fix the issue of zram that the original commit (9e07f4e24379)
wants to fix
- patch 6: fix the issue of virtio-blk ([2])
- patch 3/4: I have not occured with these two issues in real world. Put
  here just for completeness.

This patch set is for 4.19, though it shall be backported to
4.4/4.9/4.14/4.19. Send this patch set out first for more feedbacks.

I have only tested the issue of virtio-blk though.

[1] https://lore.kernel.org/stable/20210207114656.32141-1-jefflexu@linux.alibaba.com/
[2] https://lore.kernel.org/stable/f466aacc-f9ca-49ca-0da8-16dc045c9000@linux.alibaba.com/
[3] https://lore.kernel.org/stable/20210207224612.GY4035784@sasha-vm/

Hannes Reinecke (5):
  block: genhd: add 'groups' argument to device_add_disk
  nvme: register ns_id attributes as default sysfs groups
  aoe: register default groups with device_add_disk()
  zram: register default groups with device_add_disk()
  virtio-blk: modernize sysfs attribute creation

Jeffle Xu (1):
  Revert "zram: close udev startup race condition as default groups"

 arch/um/drivers/ubd_kern.c          |   2 +-
 block/genhd.c                       |  19 +++--
 drivers/block/aoe/aoe.h             |   1 -
 drivers/block/aoe/aoeblk.c          |  21 ++----
 drivers/block/aoe/aoedev.c          |   1 -
 drivers/block/floppy.c              |   2 +-
 drivers/block/mtip32xx/mtip32xx.c   |   2 +-
 drivers/block/ps3disk.c             |   2 +-
 drivers/block/ps3vram.c             |   2 +-
 drivers/block/rsxx/dev.c            |   2 +-
 drivers/block/skd_main.c            |   2 +-
 drivers/block/sunvdc.c              |   2 +-
 drivers/block/virtio_blk.c          |  68 ++++++++++--------
 drivers/block/xen-blkfront.c        |   2 +-
 drivers/block/zram/zram_drv.c       |   4 +-
 drivers/ide/ide-cd.c                |   2 +-
 drivers/ide/ide-gd.c                |   2 +-
 drivers/memstick/core/ms_block.c    |   2 +-
 drivers/memstick/core/mspro_block.c |   2 +-
 drivers/mmc/core/block.c            |   2 +-
 drivers/mtd/mtd_blkdevs.c           |   2 +-
 drivers/nvdimm/blk.c                |   2 +-
 drivers/nvdimm/btt.c                |   2 +-
 drivers/nvdimm/pmem.c               |   2 +-
 drivers/nvme/host/core.c            |  21 +++---
 drivers/nvme/host/lightnvm.c        | 105 ++++++++++++----------------
 drivers/nvme/host/multipath.c       |  15 ++--
 drivers/nvme/host/nvme.h            |  10 +--
 drivers/s390/block/dasd_genhd.c     |   2 +-
 drivers/s390/block/dcssblk.c        |   2 +-
 drivers/s390/block/scm_blk.c        |   2 +-
 drivers/scsi/sd.c                   |   2 +-
 drivers/scsi/sr.c                   |   2 +-
 include/linux/genhd.h               |   5 +-
 34 files changed, 147 insertions(+), 169 deletions(-)

-- 
2.27.0

