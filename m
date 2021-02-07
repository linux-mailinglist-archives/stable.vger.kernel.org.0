Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC9D312408
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 12:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBGLsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 06:48:10 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:58924 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230101AbhBGLrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 06:47:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UO44qvd_1612698426;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UO44qvd_1612698426)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 07 Feb 2021 19:47:06 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com, Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [PATCH 0/3] close udev startup race condition for several devices
Date:   Sun,  7 Feb 2021 19:46:53 +0800
Message-Id: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The upstream commit fef912bf860e8e7e48a2bfb978a356bba743a8b7 ("block:
genhd: add 'groups' argument to device_add_disk") and the following
patches fix a race condition of udev for several devices, including
nvme, aoe, zram and virtio.

The stable tree commit 9e07f4e243791e00a4086ad86e573705cf7b2c65("zram:
close udev startup race condition as default groups") only fixes zram,
leaving other devices unfixed.

This udev race issue indeed makes trouble. We recently found that this
issue can cause missing '/dev/disk/by-id/XXXX' symlink of virtio-blk
devices on 4.19.

Be noted that this patch set follows the idea of stable commit
9e07f4e243791e00a4086ad86e573705cf7b2c65 ("zram: close udev startup race
condition as default groups") of merging the preparation patch (commit
fef912bf860e) and the fixing patch (commit 98af4d4df889).

Jeffle Xu (3):
  virtio-blk: close udev startup race condition as default groups
  aoe: close udev startup race condition as default groups
  nvme: close udev startup race condition as default groups

 drivers/block/aoe/aoe.h       |   1 -
 drivers/block/aoe/aoeblk.c    |  20 +++----
 drivers/block/aoe/aoedev.c    |   1 -
 drivers/block/virtio_blk.c    |  67 +++++++++++++---------
 drivers/nvme/host/core.c      |  20 +++----
 drivers/nvme/host/lightnvm.c  | 105 ++++++++++++++--------------------
 drivers/nvme/host/multipath.c |  10 +---
 drivers/nvme/host/nvme.h      |  10 +---
 8 files changed, 103 insertions(+), 131 deletions(-)

-- 
2.27.0

