Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB9899B91
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404492AbfHVRZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404474AbfHVRZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:45 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D98E23426;
        Thu, 22 Aug 2019 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494744;
        bh=fmHX5gFkRLE6HEbw4pNjyFQ6FzlHrGcqNU+mkFP+Wpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Of1vQEaaXfq+bTfXupDr1W1+mBMHaVAOuyWGjrjvVcZJzSN6i1NK6OFNVodFAkJDr
         8ZDFDB0a18LfNZecrY5X9Wtfp0QktKE9wIp2wHvhk72Hg375sci0G8uzBpmX+y+xem
         gwksi8lUUWepr6Ys+9Yea+RjhXB1rLQBN0PDcxRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/85] scsi: qla2xxx: Fix possible fcport null-pointer dereferences
Date:   Thu, 22 Aug 2019 10:19:11 -0700
Message-Id: <20190822171732.971558743@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index f84f9bf150278..ddce32fe0513a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4732,7 +4732,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
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



