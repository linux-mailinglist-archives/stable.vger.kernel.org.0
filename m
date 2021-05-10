Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48805378465
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhEJKv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41711 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhEJKuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1488B619F1;
        Mon, 10 May 2021 10:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643165;
        bh=K7MP6scl/OWuLlk6iKFJzWTsh7jEaPUuIVAJPFVdBtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGY0dfyR49fq6YdAWXhccUYgggPHpHYUCtvJTqS+UL3kGvvFPgvJcehkD5aSLKTxt
         xvrybnFvTRlJGaOt/g4OTT+IraSWUvWpBDIXQ64Q0Pc64frYiw90WaDKzAFJo8IHHL
         017jD8xy4uX8cOUDJ0QvJ85JUTMAeaGIXAtNZWTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/299] block/rnbd-clt: Fix missing a memory free when unloading the module
Date:   Mon, 10 May 2021 12:20:02 +0200
Message-Id: <20210510102011.717028766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit 12b06533104e802df73c1fbe159437c19933d6c0 ]

When unloading the rnbd-clt module, it does not free a memory
including the filename of the symbolic link to /sys/block/rnbdX.

It is found by kmemleak as below.

unreferenced object 0xffff9f1a83d3c740 (size 16):
  comm "bash", pid 736, jiffies 4295179665 (age 9841.310s)
  hex dump (first 16 bytes):
    21 64 65 76 21 6e 75 6c 6c 62 30 40 62 6c 61 00  !dev!nullb0@bla.
  backtrace:
    [<0000000039f0c55e>] 0xffffffffc0456c24
    [<000000001aab9513>] kernfs_fop_write+0xcf/0x1c0
    [<00000000db5aa4b3>] vfs_write+0xdb/0x1d0
    [<000000007a2e2207>] ksys_write+0x65/0xe0
    [<00000000055e280a>] do_syscall_64+0x50/0x1b0
    [<00000000c2b51831>] entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/20210419073722.15351-13-gi-oh.kim@ionos.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt-sysfs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt-sysfs.c b/drivers/block/rnbd/rnbd-clt-sysfs.c
index d9dd138ca9c6..5613cd45866b 100644
--- a/drivers/block/rnbd/rnbd-clt-sysfs.c
+++ b/drivers/block/rnbd/rnbd-clt-sysfs.c
@@ -433,10 +433,14 @@ void rnbd_clt_remove_dev_symlink(struct rnbd_clt_dev *dev)
 	 * i.e. rnbd_clt_unmap_dev_store() leading to a sysfs warning because
 	 * of sysfs link already was removed already.
 	 */
-	if (dev->blk_symlink_name && try_module_get(THIS_MODULE)) {
-		sysfs_remove_link(rnbd_devs_kobj, dev->blk_symlink_name);
+	if (dev->blk_symlink_name) {
+		if (try_module_get(THIS_MODULE)) {
+			sysfs_remove_link(rnbd_devs_kobj, dev->blk_symlink_name);
+			module_put(THIS_MODULE);
+		}
+		/* It should be freed always. */
 		kfree(dev->blk_symlink_name);
-		module_put(THIS_MODULE);
+		dev->blk_symlink_name = NULL;
 	}
 }
 
-- 
2.30.2



