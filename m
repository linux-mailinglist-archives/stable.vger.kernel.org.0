Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3102663097C
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbiKSCNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiKSCMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D9B4AF11;
        Fri, 18 Nov 2022 18:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4322B82675;
        Sat, 19 Nov 2022 02:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7A0C433C1;
        Sat, 19 Nov 2022 02:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823929;
        bh=fTsos0t8V/7ytUC0Vqd4gBJMZRDd/hQkclnB477cRzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXRAjHX0nPIDLP6+d6/0ExwsmiXmT7w4qKxzhb8ZCZ1T2RVYLrf9aBgLxc5veGn0d
         Xod/iHfKAVKvo3RNLPaDg+U7lYXOLfb3u/ZFjloMEHHQ/Q5/5xb2P5/T/X0Ep0+nzs
         0KJ4orvNlTKCBcnxsLTN/s1OLxFgewV8DYPPC6QostABicAIWGENnhL/EaSUlzUMUQ
         Vc9YuyCBKlu+xzpNj/mw0JsGD2x/9d0/LBkOgihVFd0y2Q52U6kH1XhsLOsXVV5qLL
         r+sj9Ajp3Avkaw2/SPP4FBJhNu9mCwpFlCgxcNuqC8BaqO8JpcRBdjq/zd5K7aCiCe
         ysomRUIVLdP2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian King <brking@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, tyreld@linux.ibm.com,
        mpe@ellerman.id.au, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.0 23/44] scsi: ibmvfc: Avoid path failures during live migration
Date:   Fri, 18 Nov 2022 21:11:03 -0500
Message-Id: <20221119021124.1773699-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian King <brking@linux.vnet.ibm.com>

[ Upstream commit 62fa3ce05d5d73c5eccc40b2db493f55fecfc446 ]

Fix an issue reported when performing a live migration when multipath is
configured with a short fast fail timeout of 5 seconds and also to have
no_path_retry set to fail. In this scenario, all paths would go into the
devloss state while the ibmvfc driver went through discovery to log back
in. On a loaded system, the discovery might take longer than 5 seconds,
which was resulting in all paths being marked failed, which then resulted
in a read only filesystem.

This patch changes the migration code in ibmvfc to avoid deleting rports at
all in this scenario, so we avoid losing all paths.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/20221026181356.148517-1-brking@linux.vnet.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 00684e11976b..1a0c0b7289d2 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -708,8 +708,13 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 		memset(vhost->async_crq.msgs.async, 0, PAGE_SIZE);
 		vhost->async_crq.cur = 0;
 
-		list_for_each_entry(tgt, &vhost->targets, queue)
-			ibmvfc_del_tgt(tgt);
+		list_for_each_entry(tgt, &vhost->targets, queue) {
+			if (vhost->client_migrated)
+				tgt->need_login = 1;
+			else
+				ibmvfc_del_tgt(tgt);
+		}
+
 		scsi_block_requests(vhost->host);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
 		vhost->job_step = ibmvfc_npiv_login;
@@ -3235,9 +3240,12 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 			/* We need to re-setup the interpartition connection */
 			dev_info(vhost->dev, "Partition migrated, Re-enabling adapter\n");
 			vhost->client_migrated = 1;
+
+			scsi_block_requests(vhost->host);
 			ibmvfc_purge_requests(vhost, DID_REQUEUE);
-			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			ibmvfc_set_host_state(vhost, IBMVFC_LINK_DOWN);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_REENABLE);
+			wake_up(&vhost->work_wait_q);
 		} else if (crq->format == IBMVFC_PARTNER_FAILED || crq->format == IBMVFC_PARTNER_DEREGISTER) {
 			dev_err(vhost->dev, "Host partner adapter deregistered or failed (rc=%d)\n", crq->format);
 			ibmvfc_purge_requests(vhost, DID_ERROR);
-- 
2.35.1

