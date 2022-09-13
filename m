Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7208E5B6F82
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiIMOOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiIMONl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FD06051A;
        Tue, 13 Sep 2022 07:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A45614A1;
        Tue, 13 Sep 2022 14:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6EEC43140;
        Tue, 13 Sep 2022 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078223;
        bh=YT6Y9sh7nLwG2U9f/xoa4qYNPvQIbZLnaR3oXvuXZG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAGZG2MKCFl5A2ZTg0MbScn4krhUy9+Ig2XuZRQ98TQWbvs9gDUiBQV9BhizFyI/d
         OPhpI5lF7Z4aMOfO3G1ZTFYuJ6dMUHDxQeRwtHeZeB5XxYZSF57JocSPs/Nxc8lqu/
         xH29CmfnD4RDuKdqI5Dlf1Bvn//MZFqe6212i4Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.19 059/192] scsi: lpfc: Add missing destroy_workqueue() in error path
Date:   Tue, 13 Sep 2022 16:02:45 +0200
Message-Id: <20220913140412.886874323@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit da6d507f5ff328f346b3c50e19e19993027b8ffd upstream.

Add the missing destroy_workqueue() before return from
lpfc_sli4_driver_resource_setup() in the error path.

Link: https://lore.kernel.org/r/20220823044237.285643-1-yangyingliang@huawei.com
Fixes: 3cee98db2610 ("scsi: lpfc: Fix crash on driver unload in wq free")
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8061,7 +8061,7 @@ lpfc_sli4_driver_resource_setup(struct l
 	/* Allocate device driver memory */
 	rc = lpfc_mem_alloc(phba, SGL_ALIGN_SZ);
 	if (rc)
-		return -ENOMEM;
+		goto out_destroy_workqueue;
 
 	/* IF Type 2 ports get initialized now. */
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
@@ -8489,6 +8489,9 @@ out_free_bsmbx:
 	lpfc_destroy_bootstrap_mbox(phba);
 out_free_mem:
 	lpfc_mem_free(phba);
+out_destroy_workqueue:
+	destroy_workqueue(phba->wq);
+	phba->wq = NULL;
 	return rc;
 }
 


