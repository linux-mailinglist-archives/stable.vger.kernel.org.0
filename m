Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6583B657B6C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbiL1PV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiL1PVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:21:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA9014094
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD627CE1368
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C7EC433D2;
        Wed, 28 Dec 2022 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240882;
        bh=nFxOc1XNvVZFR1/aX+3ddg/bNF0MDaD3f8yHQ31RcyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3lLQ/DUE/qCrcde9RIuv6x5aD3Azja5GQxmHGX/inogOyLu21GXpjrvBGYbHezz6
         GNyfQg9UBEhqnMq0+F6PoDAOo0gwmXscNy/I/cZAp2y1u+iJTK8bpesf8zQxwxx5WG
         haLW3Fof2Djygj+KoDPeba32ago+LFAMdVNyl2D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/731] scsi: hpsa: Fix error handling in hpsa_add_sas_host()
Date:   Wed, 28 Dec 2022 15:38:35 +0100
Message-Id: <20221228144308.397332528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 4ef174a3ad9b5d73c1b6573e244ebba2b0d86eac ]

hpsa_sas_port_add_phy() does:
  ...
  sas_phy_add()  -> may return error here
  sas_port_add_phy()
  ...

Whereas hpsa_free_sas_phy() does:
  ...
  sas_port_delete_phy()
  sas_phy_delete()
  ...

If hpsa_sas_port_add_phy() returns an error, hpsa_free_sas_phy() can not be
called to free the memory because the port and the phy have not been added
yet.

Replace hpsa_free_sas_phy() with sas_phy_free() and kfree() to avoid kernel
crash in this case.

Fixes: d04e62b9d63a ("hpsa: add in sas transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221110151129.394389-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 74d563950c64..a4a00944b290 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9788,7 +9788,8 @@ static int hpsa_add_sas_host(struct ctlr_info *h)
 	return 0;
 
 free_sas_phy:
-	hpsa_free_sas_phy(hpsa_sas_phy);
+	sas_phy_free(hpsa_sas_phy->phy);
+	kfree(hpsa_sas_phy);
 free_sas_port:
 	hpsa_free_sas_port(hpsa_sas_port);
 free_sas_node:
-- 
2.35.1



