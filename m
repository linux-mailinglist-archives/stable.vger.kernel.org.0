Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982EB66C11A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbjAPOHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjAPOGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:06:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777022279C;
        Mon, 16 Jan 2023 06:03:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E4D68CE1161;
        Mon, 16 Jan 2023 14:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E956C433D2;
        Mon, 16 Jan 2023 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877811;
        bh=8cNFZejMv83oKGr/2HvFULdLfHiLGrl6W9748itwf3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7AqcAs5ahzSI5ZFq+GPPnmLJPify5Nkd3CAn6f5NFG5rnwh3h8zhWU26rcNbYRsM
         f0bMETFec9douV9GdncVpak0G4u5lqCl8/IkAtCalxLPbqMJc9Zg1WP0owF7KV8c9B
         AYskbkDpWsXqCrIgzIBWiFQGEJKcc9GHX0Jv9R7er3zlUTbRZvUfYNEgEjTdnxQLrG
         MD5kji4/Tt2gRXo9I1o3eIwz25f5u9idkWOD6nvGftOogX+ZKBtF4awfWLVMN0TGwS
         BtMvHOT073QGg9A/UCA0UHdqoojTsDBPu55q6DHnYUfp/a6jp5dYYJ34gu6KBXY03t
         rPS4jQ/OeOhcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xingui Yang <yangxingui@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 41/53] scsi: hisi_sas: Use abort task set to reset SAS disks when discovered
Date:   Mon, 16 Jan 2023 09:01:41 -0500
Message-Id: <20230116140154.114951-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 037b48057e8b485a8d72f808122796aeadbbee32 ]

Currently clear task set is used to abort all commands remaining in the
disk when the SAS disk is discovered, and if the disk is discovered by two
initiators, other I_T nexuses are also affected. So use abort task set
instead and take effect only on the specified I_T nexus.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1672805000-141102-2-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 699b07abb6b0..34870b3286ab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -714,7 +714,7 @@ static int hisi_sas_init_device(struct domain_device *device)
 		int_to_scsilun(0, &lun);
 
 		while (retry-- > 0) {
-			rc = sas_clear_task_set(device, lun.scsi_lun);
+			rc = sas_abort_task_set(device, lun.scsi_lun);
 			if (rc == TMF_RESP_FUNC_COMPLETE) {
 				hisi_sas_release_task(hisi_hba, device);
 				break;
-- 
2.35.1

