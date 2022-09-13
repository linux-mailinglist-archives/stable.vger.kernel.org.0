Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AFB5B722E
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiIMOtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiIMOsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:48:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1882B66A7A;
        Tue, 13 Sep 2022 07:25:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83AE7614C6;
        Tue, 13 Sep 2022 14:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFB9C433D7;
        Tue, 13 Sep 2022 14:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079035;
        bh=JtseD01ATePGId3VLyjVyOqQP9WnZXcf8aOBoKLHlgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHdk35BXm8Qgnov6e1/p42MJMG5NzAtN1KFbX9U8mw1TgbFcuqGkTUmEJoSlmZ9Dh
         E2nTtbR6Mg5IffURJkUarnZ6wWQzhWMHJ5/Gs6viyMg8NBxYL7VNchiOfIhebhVJFc
         7y10HWri2/ALvN73PQ4LFb2aZduDDmPOxSOpDF/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 32/79] scsi: lpfc: Add missing destroy_workqueue() in error path
Date:   Tue, 13 Sep 2022 16:04:37 +0200
Message-Id: <20220913140351.855398260@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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
@@ -6670,7 +6670,7 @@ lpfc_sli4_driver_resource_setup(struct l
 	/* Allocate device driver memory */
 	rc = lpfc_mem_alloc(phba, SGL_ALIGN_SZ);
 	if (rc)
-		return -ENOMEM;
+		goto out_destroy_workqueue;
 
 	/* IF Type 2 ports get initialized now. */
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
@@ -7076,6 +7076,9 @@ out_free_bsmbx:
 	lpfc_destroy_bootstrap_mbox(phba);
 out_free_mem:
 	lpfc_mem_free(phba);
+out_destroy_workqueue:
+	destroy_workqueue(phba->wq);
+	phba->wq = NULL;
 	return rc;
 }
 


