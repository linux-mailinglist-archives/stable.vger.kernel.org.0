Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594EF6356B3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiKWJdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237797AbiKWJcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:32:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8A51A3A3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:31:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C04361B49
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9CBC433D6;
        Wed, 23 Nov 2022 09:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195880;
        bh=9QPTpe3O4Wdgo90IBeO2bl3KONhzK17Ryo0NBFw1d58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFyoK3xp/mZtdpzrxfBJoxUp2iaqjIyVRxM4njkx0U85Kw6d5oXxl27OGclPfHH37
         KOeojycvO48hxH0S+NYq6eKp8uRwbCZJAX5rwtBrrI+LpoN6oG4FVag1SGTFHY0wP3
         2DXX+mXwzaxGSvIMYvTMnOR2VntkxpRG2R1j/MSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Garry <john.g.garry@oracle.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/181] scsi: scsi_transport_sas: Fix error handling in sas_phy_add()
Date:   Wed, 23 Nov 2022 09:50:20 +0100
Message-Id: <20221123084604.837593646@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

[ Upstream commit 5d7bebf2dfb0dc97aac1fbace0910e557ecdb16f ]

If transport_add_device() fails in sas_phy_add(), the kernel will crash
trying to delete the device in transport_remove_device() called from
sas_remove_host().

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000108
CPU: 61 PID: 42829 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc1+ #173
pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : device_del+0x54/0x3d0
lr : device_del+0x37c/0x3d0
Call trace:
 device_del+0x54/0x3d0
 attribute_container_class_device_del+0x28/0x38
 transport_remove_classdev+0x6c/0x80
 attribute_container_device_trigger+0x108/0x110
 transport_remove_device+0x28/0x38
 sas_phy_delete+0x30/0x60 [scsi_transport_sas]
 do_sas_phy_delete+0x6c/0x80 [scsi_transport_sas]
 device_for_each_child+0x68/0xb0
 sas_remove_children+0x40/0x50 [scsi_transport_sas]
 sas_remove_host+0x20/0x38 [scsi_transport_sas]
 hisi_sas_remove+0x40/0x68 [hisi_sas_main]
 hisi_sas_v2_remove+0x20/0x30 [hisi_sas_v2_hw]
 platform_remove+0x2c/0x60

Fix this by checking and handling return value of transport_add_device()
in sas_phy_add().

Fixes: c7ebbbce366c ("[SCSI] SAS transport class")
Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221107124828.115557-1-yangyingliang@huawei.com
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_sas.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 4a96fb05731d..c6256fdc24b1 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -716,12 +716,17 @@ int sas_phy_add(struct sas_phy *phy)
 	int error;
 
 	error = device_add(&phy->dev);
-	if (!error) {
-		transport_add_device(&phy->dev);
-		transport_configure_device(&phy->dev);
+	if (error)
+		return error;
+
+	error = transport_add_device(&phy->dev);
+	if (error) {
+		device_del(&phy->dev);
+		return error;
 	}
+	transport_configure_device(&phy->dev);
 
-	return error;
+	return 0;
 }
 EXPORT_SYMBOL(sas_phy_add);
 
-- 
2.35.1



