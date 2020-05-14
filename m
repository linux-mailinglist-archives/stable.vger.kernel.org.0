Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096951D3BBB
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgENTE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgENSyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:54:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B382E20767;
        Thu, 14 May 2020 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482464;
        bh=Uaj9rqqLzHfe+1jd0jkCsP3PB4Jgsesmg0AWAJ2tPyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zi+csszwupcxbDSmoFcyqfVKjlHbhLVKPAcQlwj5zeHdSaOko45M/Jlxib4c+RAFL
         WwMiEhVkO759pSRrKsgLJ2esbjDhhg2aO9H6E9gO7wNgzaeHYpRstddV6nbOvwSGHY
         R/xBomPTS7zOjHEhtTFuMr5HVsIjAzGwqJYhtFbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/31] scsi: qla2xxx: Delete all sessions before unregister local nvme port
Date:   Thu, 14 May 2020 14:53:50 -0400
Message-Id: <20200514185413.20755-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185413.20755-1-sashal@kernel.org>
References: <20200514185413.20755-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit c48f849d3f7a4ec1025105f446e29d395c4dcc2f ]

Delete all sessions before unregistering local nvme port.  This allows nvme
layer to decrement all active rport count down to zero.  Once the count is
down to zero, nvme would call qla to continue with the npiv port deletion.

PID: 27448  TASK: ffff9e34b777c1c0  CPU: 0   COMMAND: "qaucli"
 0 [ffff9e25e84abbd8] __schedule at ffffffff977858ca
 1 [ffff9e25e84abc68] schedule at ffffffff97785d79
 2 [ffff9e25e84abc78] schedule_timeout at ffffffff97783881
 3 [ffff9e25e84abd28] wait_for_completion at ffffffff9778612d
 4 [ffff9e25e84abd88] qla_nvme_delete at ffffffffc0e3024e [qla2xxx]
 5 [ffff9e25e84abda8] qla24xx_vport_delete at ffffffffc0e024b9 [qla2xxx]
 6 [ffff9e25e84abdf0] fc_vport_terminate at ffffffffc011c247 [scsi_transport_fc]
 7 [ffff9e25e84abe28] store_fc_host_vport_delete at ffffffffc011cd94 [scsi_transport_fc]
 8 [ffff9e25e84abe70] dev_attr_store at ffffffff974b376b
 9 [ffff9e25e84abe80] sysfs_kf_write at ffffffff972d9a92
10 [ffff9e25e84abe90] kernfs_fop_write at ffffffff972d907b
11 [ffff9e25e84abec8] vfs_write at ffffffff9724c790
12 [ffff9e25e84abf08] sys_write at ffffffff9724d55f
13 [ffff9e25e84abf50] system_call_fastpath at ffffffff97792ed2
    RIP: 00007fc0bd81a6fd  RSP: 00007ffff78d9648  RFLAGS: 00010202
    RAX: 0000000000000001  RBX: 0000000000000022  RCX: 00007ffff78d96e0
    RDX: 0000000000000022  RSI: 00007ffff78d94e0  RDI: 0000000000000008
    RBP: 00007ffff78d9440   R8: 0000000000000000   R9: 00007fc0bd48b2cd
    R10: 0000000000000017  R11: 0000000000000293  R12: 0000000000000000
    R13: 00005624e4dac840  R14: 00005624e4da9a10  R15: 0000000000000000
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

Link: https://lore.kernel.org/r/20200331104015.24868-4-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index b008d583dd6e1..0ab9d2fd4a14a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2162,11 +2162,11 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
 
-	qla_nvme_delete(vha);
 
 	qla24xx_disable_vp(vha);
 	qla2x00_wait_for_sess_deletion(vha);
 
+	qla_nvme_delete(vha);
 	vha->flags.delete_progress = 1;
 
 	qlt_remove_target(ha, vha);
-- 
2.20.1

