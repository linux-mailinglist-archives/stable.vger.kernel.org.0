Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2207A66C7B0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjAPQd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbjAPQdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:33:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37FA1A943
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E54461057
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654D3C433EF;
        Mon, 16 Jan 2023 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886061;
        bh=iL8sXOEVztUjudD1LdR0VYrYRKYxEO2rlCMGSvXT9WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdXDYgTmLLn3p0qKoAv5Nyj7MX1WTS3dfxVeLiNvSW65UTDaDo6eM6B+2U0ZH+0+U
         XIQJeBcCDCL+yPhKsNzxLrToxF+n348AyRswF2kz9ImoMxuJN3sMZ3lkZkEkI3Dd7s
         uufyvRHXagEDjPFAFbQQuMHll6p4b5BIkkfa+f6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 258/658] scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()
Date:   Mon, 16 Jan 2023 16:45:46 +0100
Message-Id: <20230116154921.382478345@linuxfoundation.org>
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

[ Upstream commit 78316e9dfc24906dd474630928ed1d3c562b568e ]

In mpt3sas_transport_port_add(), if sas_rphy_add() returns error,
sas_rphy_free() needs be called to free the resource allocated in
sas_end_device_alloc(). Otherwise a kernel crash will happen:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000108
CPU: 45 PID: 37020 Comm: bash Kdump: loaded Tainted: G        W          6.1.0-rc1+ #189
pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : device_del+0x54/0x3d0
lr : device_del+0x37c/0x3d0
Call trace:
 device_del+0x54/0x3d0
 attribute_container_class_device_del+0x28/0x38
 transport_remove_classdev+0x6c/0x80
 attribute_container_device_trigger+0x108/0x110
 transport_remove_device+0x28/0x38
 sas_rphy_remove+0x50/0x78 [scsi_transport_sas]
 sas_port_delete+0x30/0x148 [scsi_transport_sas]
 do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
 device_for_each_child+0x68/0xb0
 sas_remove_children+0x30/0x50 [scsi_transport_sas]
 sas_rphy_remove+0x38/0x78 [scsi_transport_sas]
 sas_port_delete+0x30/0x148 [scsi_transport_sas]
 do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
 device_for_each_child+0x68/0xb0
 sas_remove_children+0x30/0x50 [scsi_transport_sas]
 sas_remove_host+0x20/0x38 [scsi_transport_sas]
 scsih_remove+0xd8/0x420 [mpt3sas]

Because transport_add_device() is not called when sas_rphy_add() fails, the
device is not added. When sas_rphy_remove() is subsequently called to
remove the device in the remove() path, a NULL pointer dereference happens.

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221109032403.1636422-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 5324662751bf..b909cf100ea4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -712,6 +712,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	if ((sas_rphy_add(rphy))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
+		sas_rphy_free(rphy);
+		rphy = NULL;
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
-- 
2.35.1



