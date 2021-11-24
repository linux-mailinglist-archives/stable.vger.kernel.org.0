Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBEF45C0A5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345937AbhKXNJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348283AbhKXNJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A7A61157;
        Wed, 24 Nov 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757609;
        bh=iGIceUSyZjXjyd2KuFmoukhYUJXudO+p2xcRZGBfesY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjBx7DAXslqbP3l2I4JChhjM5MScb+/SgdZ/2UtmslViFWAaE4QDGDqf1tv9Chfpk
         NYrIyDTKd2e4yF8iOtmMVaMSefM4FrX2qht5vfkqYWYas4A0FWFffraWDY6k2M+FYY
         V21tjcWRvIfwVqSN6rEMRqhHtMcxbLd9GPYKUvm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/323] scsi: qla2xxx: Fix gnl list corruption
Date:   Wed, 24 Nov 2021 12:56:47 +0100
Message-Id: <20211124115726.262798973@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit c98c5daaa24b583cba1369b7d167f93c6ae7299c ]

Current code does list element deletion and addition in and out of lock
protection. This patch moves deletion behind lock.

list_add double add: new=ffff9130b5eb89f8, prev=ffff9130b5eb89f8,
    next=ffff9130c6a715f0.
 ------------[ cut here ]------------
 kernel BUG at lib/list_debug.c:31!
 invalid opcode: 0000 [#1] SMP PTI
 CPU: 1 PID: 182395 Comm: kworker/1:37 Kdump: loaded Tainted: G W  OE
 --------- -  - 4.18.0-193.el8.x86_64 #1
 Hardware name: HP ProLiant DL160 Gen8, BIOS J03 02/10/2014
 Workqueue: qla2xxx_wq qla2x00_iocb_work_fn [qla2xxx]
 RIP: 0010:__list_add_valid+0x41/0x50
 Code: 85 94 00 00 00 48 39 c7 74 0b 48 39 d7 74 06 b8 01 00 00 00 c3 48 89 f2
 4c 89 c1 48 89 fe 48 c7 c7 60 83 ad 97 e8 4d bd ce ff <0f> 0b 0f 1f 00 66 2e
 0f 1f 84 00 00 00 00 00 48 8b 07 48 8b 57 08
 RSP: 0018:ffffaba306f47d68 EFLAGS: 00010046
 RAX: 0000000000000058 RBX: ffff9130b5eb8800 RCX: 0000000000000006
 RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffff9130b7456a00
 RBP: ffff9130c6a70a58 R08: 000000000008d7be R09: 0000000000000001
 R10: 0000000000000000 R11: 0000000000000001 R12: ffff9130c6a715f0
 R13: ffff9130b5eb8824 R14: ffff9130b5eb89f8 R15: ffff9130b5eb89f8
 FS:  0000000000000000(0000) GS:ffff9130b7440000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007efcaaef11a0 CR3: 000000005200a002 CR4: 00000000000606e0
 Call Trace:
  qla24xx_async_gnl+0x113/0x3c0 [qla2xxx]
  ? qla2x00_iocb_work_fn+0x53/0x80 [qla2xxx]
  ? process_one_work+0x1a7/0x3b0
  ? worker_thread+0x30/0x390
  ? create_worker+0x1a0/0x1a0
  ? kthread+0x112/0x130

Link: https://lore.kernel.org/r/20211026115412.27691-3-njavali@marvell.com
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2ebf4e4e02344..613e5467b4bc2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -797,8 +797,6 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 	    sp->name, res, sp->u.iocb_cmd.u.mbx.in_mb[1],
 	    sp->u.iocb_cmd.u.mbx.in_mb[2]);
 
-	if (res == QLA_FUNCTION_TIMEOUT)
-		return;
 
 	sp->fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
 	memset(&ea, 0, sizeof(ea));
@@ -837,8 +835,8 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	list_for_each_entry_safe(fcport, tf, &h, gnl_entry) {
-		list_del_init(&fcport->gnl_entry);
 		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+		list_del_init(&fcport->gnl_entry);
 		fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		ea.fcport = fcport;
-- 
2.33.0



