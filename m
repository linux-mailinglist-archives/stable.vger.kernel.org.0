Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB1283C27
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfHFVgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbfHFVgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:36:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F67217F5;
        Tue,  6 Aug 2019 21:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127407;
        bh=jJbQj9IBuTF7hQ6keXh168M8a7RYG+o6Io5SAcC7px8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYm/rhNMfI98YkIisxJM4CEqWTBZ6Ld+0QGKM+a6ID/WMXCWS0mkomHJ91gsWujKK
         uG8m+FgcCQTsk/LyuOVgr67Xoa0Q7ORE+5eRlk8P60aUEKe4t1xgidXQFQx52lOvUK
         Tt7E84v/xgr60FWdXWzCDVzgSQIGjqgCT+Dx4exo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/25] scsi: qla2xxx: Fix possible fcport null-pointer dereferences
Date:   Tue,  6 Aug 2019 17:36:09 -0400
Message-Id: <20190806213624.20194-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213624.20194-1-sashal@kernel.org>
References: <20190806213624.20194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit e82f04ec6ba91065fd33a6201ffd7cab840e1475 ]

In qla2x00_alloc_fcport(), fcport is assigned to NULL in the error
handling code on line 4880:
    fcport = NULL;

Then fcport is used on lines 4883-4886:
    INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
	INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
	INIT_LIST_HEAD(&fcport->gnl_entry);
	INIT_LIST_HEAD(&fcport->list);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, qla2x00_alloc_fcport() directly returns NULL
in the error handling code.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index aef1e1a555350..0e154fea693e7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4252,7 +4252,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 		ql_log(ql_log_warn, vha, 0xd049,
 		    "Failed to allocate ct_sns request.\n");
 		kfree(fcport);
-		fcport = NULL;
+		return NULL;
 	}
 	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
 	INIT_LIST_HEAD(&fcport->gnl_entry);
-- 
2.20.1

