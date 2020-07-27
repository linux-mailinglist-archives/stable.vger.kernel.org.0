Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2D022F174
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbgG0Oc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731334AbgG0OTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 128BA2070A;
        Mon, 27 Jul 2020 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859540;
        bh=E9kOmYvx3YB9KGGH3MDEv+MFY5zgfWQoOjXQAr6Pwbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcBlrFhxWlkSHBUcpT58Z8jGw68PrJSDjzW5bFAufGO2J446J63v9+tbov0iVgXQG
         GMOqHN5+o6eKsO8GC0+iLjyvuvbRdhjHe1eqa8KLB0YkTdDWSKjT6fjNfz0FdXHUkK
         p+R2iSBYnDa/Tapw62SEP2eXDV91E3WlpQn+CdQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 010/179] scsi: mpt3sas: Fix unlock imbalance
Date:   Mon, 27 Jul 2020 16:03:05 +0200
Message-Id: <20200727134933.176852512@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit cb551b8dc079d2ef189145782627c99cb68c0255 ]

In BRM_status_show(), if the condition "!ioc->is_warpdrive" tested on entry
to the function is true, a "goto out" is called. This results in unlocking
ioc->pci_access_mutex without this mutex lock being taken.  This generates
the following splat:

[ 1148.539883] mpt3sas_cm2: BRM_status_show: BRM attribute is only for warpdrive
[ 1148.547184]
[ 1148.548708] =====================================
[ 1148.553501] WARNING: bad unlock balance detected!
[ 1148.558277] 5.8.0-rc3+ #827 Not tainted
[ 1148.562183] -------------------------------------
[ 1148.566959] cat/5008 is trying to release lock (&ioc->pci_access_mutex) at:
[ 1148.574035] [<ffffffffc070b7a3>] BRM_status_show+0xd3/0x100 [mpt3sas]
[ 1148.580574] but there are no more locks to release!
[ 1148.585524]
[ 1148.585524] other info that might help us debug this:
[ 1148.599624] 3 locks held by cat/5008:
[ 1148.607085]  #0: ffff92aea3e392c0 (&p->lock){+.+.}-{3:3}, at: seq_read+0x34/0x480
[ 1148.618509]  #1: ffff922ef14c4888 (&of->mutex){+.+.}-{3:3}, at: kernfs_seq_start+0x2a/0xb0
[ 1148.630729]  #2: ffff92aedb5d7310 (kn->active#224){.+.+}-{0:0}, at: kernfs_seq_start+0x32/0xb0
[ 1148.643347]
[ 1148.643347] stack backtrace:
[ 1148.655259] CPU: 73 PID: 5008 Comm: cat Not tainted 5.8.0-rc3+ #827
[ 1148.665309] Hardware name: HGST H4060-S/S2600STB, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
[ 1148.678394] Call Trace:
[ 1148.684750]  dump_stack+0x78/0xa0
[ 1148.691802]  lock_release.cold+0x45/0x4a
[ 1148.699451]  __mutex_unlock_slowpath+0x35/0x270
[ 1148.707675]  BRM_status_show+0xd3/0x100 [mpt3sas]
[ 1148.716092]  dev_attr_show+0x19/0x40
[ 1148.723664]  sysfs_kf_seq_show+0x87/0x100
[ 1148.731193]  seq_read+0xbc/0x480
[ 1148.737882]  vfs_read+0xa0/0x160
[ 1148.744514]  ksys_read+0x58/0xd0
[ 1148.751129]  do_syscall_64+0x4c/0xa0
[ 1148.757941]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1148.766240] RIP: 0033:0x7f1230566542
[ 1148.772957] Code: Bad RIP value.
[ 1148.779206] RSP: 002b:00007ffeac1bcac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 1148.790063] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f1230566542
[ 1148.800284] RDX: 0000000000020000 RSI: 00007f1223460000 RDI: 0000000000000003
[ 1148.810474] RBP: 00007f1223460000 R08: 00007f122345f010 R09: 0000000000000000
[ 1148.820641] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000000000
[ 1148.830728] R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000

Fix this by returning immediately instead of jumping to the out label.

Link: https://lore.kernel.org/r/20200701085254.51740-1-damien.lemoal@wdc.com
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 62e552838565f..e94e72de2fc68 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3145,7 +3145,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	if (!ioc->is_warpdrive) {
 		ioc_err(ioc, "%s: BRM attribute is only for warpdrive\n",
 			__func__);
-		goto out;
+		return 0;
 	}
 	/* pci_access_mutex lock acquired by sysfs show path */
 	mutex_lock(&ioc->pci_access_mutex);
-- 
2.25.1



