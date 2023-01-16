Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB5366C791
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjAPQcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbjAPQbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:31:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683472FCC2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:19:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 025A261027
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D55C433D2;
        Mon, 16 Jan 2023 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885990;
        bh=Ohsm/LtrCsNMIKBGFC5QnOQGakGZQGqyq5n1LD3sbNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjQZqugGr+eU1VNrrR4+oqVhRT5AMf/9zi/v6l16G6o6MgtTJFhnitbsVBDEdbGWg
         U5PCWBeZc1KCV/yRRihpvZhJsrjCFERikfWQl2sCg3a0MSvqwDog6DT2yJQfCbkhRG
         X7J9lqPJUV94T4mcHobzzINemWCou+51Auf13tnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 261/658] scsi: fcoe: Fix possible name leak when device_register() fails
Date:   Mon, 16 Jan 2023 16:45:49 +0100
Message-Id: <20230116154921.532089572@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 47b6a122c7b69a876c7ee2fc064a26b09627de9d ]

If device_register() returns an error, the name allocated by dev_set_name()
needs to be freed. As the comment of device_register() says, one should use
put_device() to give up the reference in the error path. Fix this by
calling put_device(), then the name can be freed in kobject_cleanup().

The 'fcf' is freed in fcoe_fcf_device_release(), so the kfree() in the
error path can be removed.

The 'ctlr' is freed in fcoe_ctlr_device_release(), so don't use the error
label, just return NULL after calling put_device().

Fixes: 9a74e884ee71 ("[SCSI] libfcoe: Add fcoe_sysfs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221112094310.3633291-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 2cb7a8c93a15..b3086cf40617 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -830,14 +830,15 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struct device *parent,
 
 	dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
 	error = device_register(&ctlr->dev);
-	if (error)
-		goto out_del_q2;
+	if (error) {
+		destroy_workqueue(ctlr->devloss_work_q);
+		destroy_workqueue(ctlr->work_q);
+		put_device(&ctlr->dev);
+		return NULL;
+	}
 
 	return ctlr;
 
-out_del_q2:
-	destroy_workqueue(ctlr->devloss_work_q);
-	ctlr->devloss_work_q = NULL;
 out_del_q:
 	destroy_workqueue(ctlr->work_q);
 	ctlr->work_q = NULL;
@@ -1036,16 +1037,16 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *ctlr,
 	fcf->selected = new_fcf->selected;
 
 	error = device_register(&fcf->dev);
-	if (error)
-		goto out_del;
+	if (error) {
+		put_device(&fcf->dev);
+		goto out;
+	}
 
 	fcf->state = FCOE_FCF_STATE_CONNECTED;
 	list_add_tail(&fcf->peers, &ctlr->fcfs);
 
 	return fcf;
 
-out_del:
-	kfree(fcf);
 out:
 	return NULL;
 }
-- 
2.35.1



