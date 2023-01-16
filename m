Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CE566CA94
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbjAPREQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbjAPRDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:03:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF24822A05
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:46:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55EC461050
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A6CC433F1;
        Mon, 16 Jan 2023 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887563;
        bh=Nt5vkuZ3gi2KOUwLRO9WBXBaVyewhFhO6wEnAZ8cMVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/N7QDbJ0lExhZicY68e0nJqhRfj4AGx4RBg6HkHekPFtdaRmcALNHXRbGDDNvxh8
         t7S4Y6HTujDQ5ulx4+knr2a4tAvZrwv5Eiq8OBFlxQroLbg6Y1EkfaJOn2WV+hrUtN
         WlOnJCX2tMbAUxd9XOwkr8BV3fwhTwYRMXJQkK+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/521] scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()
Date:   Mon, 16 Jan 2023 16:47:37 +0100
Message-Id: <20230116154855.801682001@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 9fd89e85227a..f2b072831747 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -730,6 +730,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	if ((sas_rphy_add(rphy))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
+		sas_rphy_free(rphy);
+		rphy = NULL;
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
-- 
2.35.1



