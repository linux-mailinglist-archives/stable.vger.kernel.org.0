Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D2966C1C9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjAPOPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjAPONn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:13:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73E925E09;
        Mon, 16 Jan 2023 06:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C8B60FD2;
        Mon, 16 Jan 2023 14:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F63C433D2;
        Mon, 16 Jan 2023 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877914;
        bh=dccJRID2/H5or6ii2rYhXgU7IXZtPIgvFhUmSQ+8IME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/WbkQITleww6Q+2YjgUeOU5BQB+sTEA+L3XKRV7L7f2isARXjaRVGDIzOmb9LDWC
         ZwGeUypZbM1P0J5+4/1reXBk3GF70nyHAMQ5TRqpUtaLVVyv8gNWh52wxR4qmAZ+rO
         GkryCflhSEuHmC99GLiBUu0d8CFPmjpthrTQQWY2OeiWjZdfQgqpFHnFAmK1leh/m4
         RGCe9t1Z/HYLJYOed4pYsm8X6IWqTcjxzapxBnYLI9FVTYvZ5t9ORgE6M5RnLWITI/
         gh7HB6sN2C//76BHv8BxL8bFuJDTvirDBGTTk05X+6FExK8JQf72Js6QgyGI6B1bDK
         WnK4Pxt44GQ6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/17] scsi: hisi_sas: Set a port invalid only if there are no devices attached when refreshing port id
Date:   Mon, 16 Jan 2023 09:04:45 -0500
Message-Id: <20230116140448.116034-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140448.116034-1-sashal@kernel.org>
References: <20230116140448.116034-1-sashal@kernel.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit f58c89700630da6554b24fd3df293a24874c10c1 ]

Currently the driver sets the port invalid if one phy in the port is not
enabled, which may cause issues in expander situation. In directly attached
situation, if phy up doesn't occur in time when refreshing port id, the
port is incorrectly set to invalid which will also cause disk lost.

Therefore set a port invalid only if there are no devices attached to the
port.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1672805000-141102-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1feca45384c7..e5b9229310a0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1408,7 +1408,7 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 				device->linkrate = phy->sas_phy.linkrate;
 
 			hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
-		} else
+		} else if (!port->port_attached)
 			port->id = 0xff;
 	}
 }
-- 
2.35.1

