Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BDD4D7B2
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfFTSJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728399AbfFTSJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:09:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2552082C;
        Thu, 20 Jun 2019 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054153;
        bh=KvHPKQL26vDF8kIsSu7fV8uAvbTlyNZo5k7cfnj+hjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMCxFkR4QekFvDZYL9M7+1g0r1iDmKNCMMXCJcrfm4PQBoKxBcT8MEeLRJmuuUBPv
         CqYKp59D21RZqHaKW04H/ZS6HcLaFymyX7/EpFMYvMolfYKXWgTR1QlXcq6lFS+Zzl
         mMW+T5xT7YeiKNwxYmPXNbgLl36ZtL5y26uwQ5CM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 37/45] scsi: scsi_dh_alua: Fix possible null-ptr-deref
Date:   Thu, 20 Jun 2019 19:57:39 +0200
Message-Id: <20190620174339.967510556@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 12e750bc62044de096ab9a95201213fd912b9994 ]

If alloc_workqueue fails in alua_init, it should return -ENOMEM, otherwise
it will trigger null-ptr-deref while unloading module which calls
destroy_workqueue dereference
wq->lock like this:

BUG: KASAN: null-ptr-deref in __lock_acquire+0x6b4/0x1ee0
Read of size 8 at addr 0000000000000080 by task syz-executor.0/7045

CPU: 0 PID: 7045 Comm: syz-executor.0 Tainted: G         C        5.1.0+ #28
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1
Call Trace:
 dump_stack+0xa9/0x10e
 __kasan_report+0x171/0x18d
 ? __lock_acquire+0x6b4/0x1ee0
 kasan_report+0xe/0x20
 __lock_acquire+0x6b4/0x1ee0
 lock_acquire+0xb4/0x1b0
 __mutex_lock+0xd8/0xb90
 drain_workqueue+0x25/0x290
 destroy_workqueue+0x1f/0x3f0
 __x64_sys_delete_module+0x244/0x330
 do_syscall_64+0x72/0x2a0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 03197b61c5ec ("scsi_dh_alua: Use workqueue for RTPG")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0962fd544401..09c6a16fab93 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1151,10 +1151,8 @@ static int __init alua_init(void)
 	int r;
 
 	kaluad_wq = alloc_workqueue("kaluad", WQ_MEM_RECLAIM, 0);
-	if (!kaluad_wq) {
-		/* Temporary failure, bypass */
-		return SCSI_DH_DEV_TEMP_BUSY;
-	}
+	if (!kaluad_wq)
+		return -ENOMEM;
 
 	r = scsi_register_device_handler(&alua_dh);
 	if (r != 0) {
-- 
2.20.1



