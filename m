Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96735635E8C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbiKWMta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbiKWMso (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:48:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63BD769E3;
        Wed, 23 Nov 2022 04:43:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFD5DB81F3A;
        Wed, 23 Nov 2022 12:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6752AC433D6;
        Wed, 23 Nov 2022 12:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207412;
        bh=HadPS6m+pVrsJNuaQ3ZS4WSXZB7phsZTAMFfdRfLCSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxzwcrkP0vrWa5dqIRL5b5pJt4pec8cHE0EMbIyNrARuOUtPoJwGZTgKGKGzRB084
         24jodreRFsYw80PWFBQJEit3W0u0KzIECdfosE7EDDxBLfA5+C73PqpMtdcN7iXJIh
         +ZPvTlYORWB+lxj5D+Mj2g9YO61ine6r+fkKJ2f3rDnER4SXn/DAnH0zc7xJCZtJ8C
         DaXpqzU79n/TbVteJM4y7Vu4bSm+0Uxbdtn1CUO1z5dCPNtiD/hzCp6OVJtLt2mFpj
         JUBLrg9Qq4eLN5/7b72/E8JWACYTp32ppMHs4d5VoQDhEh95E6Fzln64jybONwhuNx
         XHmoQezmGCFOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Guanghui <zhouguanghui1@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 28/31] scsi: iscsi: Fix possible memory leak when device_register() failed
Date:   Wed, 23 Nov 2022 07:42:29 -0500
Message-Id: <20221123124234.265396-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
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

From: Zhou Guanghui <zhouguanghui1@huawei.com>

[ Upstream commit f014165faa7b953b81dcbf18835936e5f8d01f2a ]

If device_register() returns error, the name allocated by the
dev_set_name() need be freed. As described in the comment of
device_register(), we should use put_device() to give up the reference in
the error path.

Fix this by calling put_device(), the name will be freed in the
kobject_cleanup(), and this patch modified resources will be released by
calling the corresponding callback function in the device_release().

Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Link: https://lore.kernel.org/r/20221110033729.1555-1-zhouguanghui1@huawei.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 31 +++++++++++++++--------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f46ae5391758..cc39cbef9d7f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -232,7 +232,7 @@ iscsi_create_endpoint(int dd_size)
 	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
-		goto free_id;
+		goto put_dev;
 
 	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
 	if (err)
@@ -246,10 +246,12 @@ iscsi_create_endpoint(int dd_size)
 	device_unregister(&ep->dev);
 	return NULL;
 
-free_id:
+put_dev:
 	mutex_lock(&iscsi_ep_idr_mutex);
 	idr_remove(&iscsi_ep_idr, id);
 	mutex_unlock(&iscsi_ep_idr_mutex);
+	put_device(&ep->dev);
+	return NULL;
 free_ep:
 	kfree(ep);
 	return NULL;
@@ -767,7 +769,7 @@ iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
 
 	err = device_register(&iface->dev);
 	if (err)
-		goto free_iface;
+		goto put_dev;
 
 	err = sysfs_create_group(&iface->dev.kobj, &iscsi_iface_group);
 	if (err)
@@ -781,9 +783,8 @@ iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
 	device_unregister(&iface->dev);
 	return NULL;
 
-free_iface:
-	put_device(iface->dev.parent);
-	kfree(iface);
+put_dev:
+	put_device(&iface->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_iface);
@@ -1252,15 +1253,15 @@ iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 
 	err = device_register(&fnode_sess->dev);
 	if (err)
-		goto free_fnode_sess;
+		goto put_dev;
 
 	if (dd_size)
 		fnode_sess->dd_data = &fnode_sess[1];
 
 	return fnode_sess;
 
-free_fnode_sess:
-	kfree(fnode_sess);
+put_dev:
+	put_device(&fnode_sess->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_flashnode_sess);
@@ -1300,15 +1301,15 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 
 	err = device_register(&fnode_conn->dev);
 	if (err)
-		goto free_fnode_conn;
+		goto put_dev;
 
 	if (dd_size)
 		fnode_conn->dd_data = &fnode_conn[1];
 
 	return fnode_conn;
 
-free_fnode_conn:
-	kfree(fnode_conn);
+put_dev:
+	put_device(&fnode_conn->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
@@ -4838,7 +4839,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	dev_set_name(&priv->dev, "%s", tt->name);
 	err = device_register(&priv->dev);
 	if (err)
-		goto free_priv;
+		goto put_dev;
 
 	err = sysfs_create_group(&priv->dev.kobj, &iscsi_transport_group);
 	if (err)
@@ -4873,8 +4874,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
 unregister_dev:
 	device_unregister(&priv->dev);
 	return NULL;
-free_priv:
-	kfree(priv);
+put_dev:
+	put_device(&priv->dev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_register_transport);
-- 
2.35.1

