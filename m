Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9866E3ACA6C
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 13:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhFRLyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 07:54:35 -0400
Received: from mail.klausen.dk ([157.90.24.29]:44588 "EHLO mail.klausen.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234342AbhFRLye (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 07:54:34 -0400
From:   Kristian Klausen <kristian@klausen.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=klausen.dk; s=dkim;
        t=1624017142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fNVRnRf8542INKe/gU6+30e9FBmzmdw4HOsCG1SESDg=;
        b=PylWqcdWYA5ulggA5WAFN4wVUb53dyb2SbV3C39KTPdkmlbic6heUukQs9O0fr/FqSJsBx
        SBoOBTrTcq1w1rUnUx9d75/rh8sRMLqLMLqzM/Uwd6L013Zs0QB39ECNGT6sdVarMuCFj/
        EmaVwN2RufE2h+rDHJi8GF/Iuab2knk=
To:     linux-block@vger.kernel.org
Cc:     Kristian Klausen <kristian@klausen.dk>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] loop: Fix missing discard support when using LOOP_CONFIGURE
Date:   Fri, 18 Jun 2021 13:51:57 +0200
Message-Id: <20210618115157.31452-1-kristian@klausen.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Without calling loop_config_discard() the discard flag and parameters
aren't set/updated for the loop device and worst-case they could
indicate discard support when it isn't the case (ex: if the
LOOP_SET_STATUS ioctl was used with a different file prior to
LOOP_CONFIGURE).

Cc: <stable@vger.kernel.org> # 5.8.x-
Fixes: 3448914e8cc5 ("loop: Add LOOP_CONFIGURE ioctl")
Signed-off-by: Kristian Klausen <kristian@klausen.dk>
---
v1 of the patch was tested like so (without the patch):
losetup 2.37<= uses LOOP_CONFIGURE instead of LOOP_SET_STATUS64[1]

# fallocate -l100M disk.img
# rmmod loop
# losetup --version
losetup from util-linux 2.36.2
# losetup --find --show disk.img
/dev/loop0
# grep '' /sys/devices/virtual/block/loop0/queue/*discard*
/sys/devices/virtual/block/loop0/queue/discard_granularity:4096
/sys/devices/virtual/block/loop0/queue/discard_max_bytes:4294966784
/sys/devices/virtual/block/loop0/queue/discard_max_hw_bytes:4294966784
/sys/devices/virtual/block/loop0/queue/discard_zeroes_data:0
/sys/devices/virtual/block/loop0/queue/max_discard_segments:1
# losetup -d /dev/loop0
# [update util-linux]
# losetup --version
losetup from util-linux 2.37
# rmmod loop
# losetup --find --show disk.img
/dev/loop0
# grep '' /sys/devices/virtual/block/loop0/queue/*discard*
/sys/devices/virtual/block/loop0/queue/discard_granularity:0
/sys/devices/virtual/block/loop0/queue/discard_max_bytes:0
/sys/devices/virtual/block/loop0/queue/discard_max_hw_bytes:0
/sys/devices/virtual/block/loop0/queue/discard_zeroes_data:0
/sys/devices/virtual/block/loop0/queue/max_discard_segments:1


With the patch applied:

# losetup --version
losetup from util-linux 2.37
# rmmod loop
# losetup --find --show disk.img
/dev/loop0
# grep '' /sys/devices/virtual/block/loop0/queue/*discard*
/sys/devices/virtual/block/loop0/queue/discard_granularity:4096
/sys/devices/virtual/block/loop0/queue/discard_max_bytes:4294966784
/sys/devices/virtual/block/loop0/queue/discard_max_hw_bytes:4294966784
/sys/devices/virtual/block/loop0/queue/discard_zeroes_data:0
/sys/devices/virtual/block/loop0/queue/max_discard_segments:1

[1] https://github.com/karelzak/util-linux/pull/1152

v2:
Add commit message
Move loop_config_discard() before loop_update_rotational()

 drivers/block/loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 76e12f3482a9..8271df125153 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1154,6 +1154,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	blk_queue_physical_block_size(lo->lo_queue, bsize);
 	blk_queue_io_min(lo->lo_queue, bsize);
 
+	loop_config_discard(lo);
 	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);

base-commit: 70585216fe7730d9fb5453d3e2804e149d0fe201
-- 
2.32.0

