Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277046C1671
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjCTPGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbjCTPFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:05:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598B02A98E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:01:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AA0061573
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFD0C433EF;
        Mon, 20 Mar 2023 15:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324484;
        bh=oQD1KaG1hFPnaDkZrdO4C3iXxytV1OLuHQdlZ2Q9yxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guIuLtr7RiyB2jc9+9KAPeeVCzh33JNhETgjB0Uk+vjJfjpyJuIl1qjACEoiFseX5
         yez0LVa3ok6L9vOEbB7jqczXliuQ6p5zEwXUoQKdXZCxKWVl97unrOvlYsrLVvrTSw
         sKpYgnI56zVouLHM8HAK9AGzyXW2XY7mvXPpXUnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenchao Hao <haowenchao2@huawei.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/60] scsi: mpt3sas: Fix NULL pointer access in mpt3sas_transport_port_add()
Date:   Mon, 20 Mar 2023 15:54:17 +0100
Message-Id: <20230320145431.228471446@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
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
index b909cf100ea48..ebe78ec42da8b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -670,7 +670,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 	port = sas_port_alloc_num(sas_node->parent_dev);
-	if ((sas_port_add(port))) {
+	if (!port || (sas_port_add(port))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
 		goto out_fail;
@@ -695,6 +695,12 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		rphy = sas_expander_alloc(port,
 		    mpt3sas_port->remote_identify.device_type);
 
+	if (!rphy) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
+		goto out_delete_port;
+	}
+
 	rphy->identify = mpt3sas_port->remote_identify;
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
@@ -714,6 +720,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			__FILE__, __LINE__, __func__);
 		sas_rphy_free(rphy);
 		rphy = NULL;
+		goto out_delete_port;
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
@@ -741,7 +748,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		    rphy_to_expander_device(rphy));
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



