Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8EBE4DBC
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbfJYOCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 10:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505386AbfJYN5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E1D222CD;
        Fri, 25 Oct 2019 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011873;
        bh=yu2re7QlOLOylGKR+ttvD8dXbCgph8uPZ6I6K2Me1Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrrlSoFgxg4G3g4r4X20UQERfcR2qsRvm6jYmksYNJR5Z+vGP8RJJ/nAGQEFkowy5
         Apl7+qo5Lt5ff/sEtMZybclkAcqXcjT6wpaYfZzouPW0GmLGZD+yypXNwOH6at7fzG
         byOXP/AubLv9cTDDc0g9yoFAgmBWorYq0DXChtzQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 22/25] ubi: ubi_wl_get_peb: Increase the number of attempts while getting PEB
Date:   Fri, 25 Oct 2019 09:57:10 -0400
Message-Id: <20191025135715.25468-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135715.25468-1-sashal@kernel.org>
References: <20191025135715.25468-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 8615b94f029a4fb4306d3512aaf1c45f5fc24d4b ]

Running stress test io_paral (A pressure ubi test in mtd-utils) on an
UBI device with fewer PEBs (fastmap enabled) may cause ENOSPC errors and
make UBI device read-only, but there are still free PEBs on the UBI
device. This problem can be easily reproduced by performing the following
steps on a 2-core machine:
  $ modprobe nandsim first_id_byte=0x20 second_id_byte=0x33 parts=80
  $ modprobe ubi mtd="0,0" fm_autoconvert
  $ ./io_paral /dev/ubi0

We may see the following verbose:
(output)
  [io_paral] update_volume():108: failed to write 380 bytes at offset
  95920 of volume 2
  [io_paral] update_volume():109: update: 97088 bytes
  [io_paral] write_thread():227: function pwrite() failed with error 28
  (No space left on device)
  [io_paral] write_thread():229: cannot write 15872 bytes to offs 31744,
  wrote -1
(dmesg)
  ubi0 error: ubi_wl_get_peb [ubi]: Unable to get a free PEB from user WL
  pool
  ubi0 warning: ubi_eba_write_leb [ubi]: switch to read-only mode
  CPU: 0 PID: 2027 Comm: io_paral Not tainted 5.3.0-rc2-00001-g5986cd0 #9
  ubi0 warning: try_write_vid_and_data [ubi]: failed to write VID header
  to LEB 2:5, PEB 18
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0
  -0-ga698c8995f-prebuilt.qemu.org 04/01/2014
  Call Trace:
    dump_stack+0x85/0xba
    ubi_eba_write_leb+0xa1e/0xa40 [ubi]
    vol_cdev_write+0x307/0x520 [ubi]
    vfs_write+0xfa/0x280
    ksys_pwrite64+0xc5/0xe0
    __x64_sys_pwrite64+0x22/0x30
    do_syscall_64+0xbf/0x440

In function ubi_wl_get_peb, the operation of filling the pool
(ubi_update_fastmap) with free PEBs and fetching a free PEB from the pool
is not atomic. After thread A filling the pool with free PEB, free PEB may
be taken away by thread B. When thread A checks the expression again, the
condition is still unsatisfactory. At this time, there may still be free
PEBs on UBI that can be filled into the pool.

This patch increases the number of attempts to obtain PEB. An extreme
case (No free PEBs left after creating test volumes) has been tested on
different type of machines for 100 times. The biggest number of attempts
are shown below:

             x86_64     arm64
  2-core        4         4
  4-core        8         4
  8-core        4         4

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap-wl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 69dd21679a30c..99aa30b28e46e 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -205,7 +205,7 @@ static int produce_free_peb(struct ubi_device *ubi)
  */
 int ubi_wl_get_peb(struct ubi_device *ubi)
 {
-	int ret, retried = 0;
+	int ret, attempts = 0;
 	struct ubi_fm_pool *pool = &ubi->fm_pool;
 	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
 
@@ -230,12 +230,12 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 
 	if (pool->used == pool->size) {
 		spin_unlock(&ubi->wl_lock);
-		if (retried) {
+		attempts++;
+		if (attempts == 10) {
 			ubi_err(ubi, "Unable to get a free PEB from user WL pool");
 			ret = -ENOSPC;
 			goto out;
 		}
-		retried = 1;
 		up_read(&ubi->fm_eba_sem);
 		ret = produce_free_peb(ubi);
 		if (ret < 0) {
-- 
2.20.1

