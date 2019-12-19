Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45B2126D38
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbfLSSke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:40:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbfLSSke (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:40:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1231C222C2;
        Thu, 19 Dec 2019 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780833;
        bh=xwqRMSYhF+3uB4f+xo93ELvJ9m//orO39JRBOvmKUTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bs8G0QwobmqUdWwwtsWxNMTJTGvox7NEiibpwji5QYNXjD1kMb27CYYU5ons9RUWA
         S7q/h12tmInxLNy/q8epNFdtjMj2NDkzL8SLPKombpI+2H2RgshoEinZI9Qn0ZrDic
         TJu5nN7kWmhXTdf+hUv3+QBxCs9NDudg1Q+aokpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 136/162] scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return value
Date:   Thu, 19 Dec 2019 19:34:04 +0100
Message-Id: <20191219183216.056779195@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e6803efae5acd109fad9f2f07dab674563441a53 ]

This patch fixes several Coverity complaints about not always checking
the qla2x00_wait_for_hba_online() return value.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c   | 3 ++-
 drivers/scsi/qla2xxx/qla_target.c | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 31c29a5d1f389..b8765c55906c9 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -760,7 +760,8 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 			break;
 		} else {
 			/* Make sure FC side is not in reset */
-			qla2x00_wait_for_hba_online(vha);
+			WARN_ON_ONCE(qla2x00_wait_for_hba_online(vha) !=
+				     QLA_SUCCESS);
 
 			/* Issue MPI reset */
 			scsi_block_requests(vha->host);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6c4f54aa60df6..1d9f19e5e0f81 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6026,7 +6026,8 @@ qlt_enable_vha(struct scsi_qla_host *vha)
 	} else {
 		set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 		qla2xxx_wake_dpc(base_vha);
-		qla2x00_wait_for_hba_online(base_vha);
+		WARN_ON_ONCE(qla2x00_wait_for_hba_online(base_vha) !=
+			     QLA_SUCCESS);
 	}
 }
 EXPORT_SYMBOL(qlt_enable_vha);
@@ -6056,7 +6057,9 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 
 	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	qla2xxx_wake_dpc(vha);
-	qla2x00_wait_for_hba_online(vha);
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
+		ql_dbg(ql_dbg_tgt, vha, 0xe081,
+		       "qla2x00_wait_for_hba_online() failed\n");
 }
 
 /*
-- 
2.20.1



