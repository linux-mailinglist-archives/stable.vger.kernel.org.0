Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3BA99AA8
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731896AbfHVRPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390435AbfHVRIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:48 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6DC323402;
        Thu, 22 Aug 2019 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493728;
        bh=pLnDJTQhnpdXSEjLDUcXDftSa5atnaXw1zNrsUQeBwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rO16ROMoIJOje1gMzA3iI7QYeYq5+0UBoYNkIdOwEy6XsPWVCJ9S2TbTE4ju8ZCFy
         x817XzzChJ4pgmuaG7hT35cHH09v8iM7unl5OoP+AmHjEMF65ome2df9ajygnF8wYJ
         vjoLNoKtf2ahBeb3wox1rJhp1DEfd9M5nVXfUR5A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 061/135] scsi: qla2xxx: Fix possible fcport null-pointer dereferences
Date:   Thu, 22 Aug 2019 13:06:57 -0400
Message-Id: <20190822170811.13303-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
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
index 54772d4c377f9..6a4c719497ca1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4877,7 +4877,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 		ql_log(ql_log_warn, vha, 0xd049,
 		    "Failed to allocate ct_sns request.\n");
 		kfree(fcport);
-		fcport = NULL;
+		return NULL;
 	}
 
 	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
-- 
2.20.1

