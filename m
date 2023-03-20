Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57D26C188E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjCTPZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjCTPZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:25:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84CF34F67
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 050B1615AE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156B9C433EF;
        Mon, 20 Mar 2023 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325202;
        bh=8oT5Qks2GUmGIWwxRKF0xeqvKQH4iV8Xqvz3XCm+TxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBJGQ1KZ10vRsjYTDgUV4105tVRgjAsUm1S14ep/A2ROKgdGHDp8LwaUKHkIIhFJz
         cg0M6gybd+jp85fKJ8wFCNSaVAkj6wL84Fq5G4MySw29FMUiD8I79ZdoKEO+iiPQ7C
         LKD7J9BEZbj58OxGHokQBlS6YL479k3LLXHnUW9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenchao Hao <haowenchao2@huawei.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 016/211] scsi: mpt3sas: Fix NULL pointer access in mpt3sas_transport_port_add()
Date:   Mon, 20 Mar 2023 15:52:31 +0100
Message-Id: <20230320145513.978775071@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenchao Hao <haowenchao2@huawei.com>

[ Upstream commit d3c57724f1569311e4b81e98fad0931028b9bdcd ]

Port is allocated by sas_port_alloc_num() and rphy is allocated by either
sas_end_device_alloc() or sas_expander_alloc(), all of which may return
NULL. So we need to check the rphy to avoid possible NULL pointer access.

If sas_rphy_add() returned with failure, rphy is set to NULL. We would
access the rphy in the following lines which would also result NULL pointer
access.

Fixes: 78316e9dfc24 ("scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()")
Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Link: https://lore.kernel.org/r/20230225100135.2109330-1-haowenchao2@huawei.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e5ecd6ada6cdd..e8a4750f6ec47 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -785,7 +785,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 	port = sas_port_alloc_num(sas_node->parent_dev);
-	if ((sas_port_add(port))) {
+	if (!port || (sas_port_add(port))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
 		goto out_fail;
@@ -824,6 +824,12 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			    mpt3sas_port->remote_identify.sas_address;
 	}
 
+	if (!rphy) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
+		goto out_delete_port;
+	}
+
 	rphy->identify = mpt3sas_port->remote_identify;
 
 	if ((sas_rphy_add(rphy))) {
@@ -831,6 +837,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			__FILE__, __LINE__, __func__);
 		sas_rphy_free(rphy);
 		rphy = NULL;
+		goto out_delete_port;
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
@@ -857,7 +864,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		    rphy_to_expander_device(rphy), hba_port->port_id);
 	return mpt3sas_port;
 
- out_fail:
+out_delete_port:
+	sas_port_delete(port);
+
+out_fail:
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
-- 
2.39.2



