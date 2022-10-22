Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98309608632
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiJVHpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiJVHop (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:44:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E696859EA4;
        Sat, 22 Oct 2022 00:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BB18B82E19;
        Sat, 22 Oct 2022 07:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002A7C433C1;
        Sat, 22 Oct 2022 07:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424560;
        bh=2PDkRAInx+5qdYpVRI+2RTNMv7awcytT6P1oXVUQ3zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfBsqYQb2/M3ES38czFoOsk7T1CH+5IfZjOlCvQHCZMmo7+FDaTHSqRYplithjnUG
         Khj/UI+tiPOs49yOlQyQHsXGtYWaxT6m3EwyozgIrTp4eDm9TBpNKO/sOBzR+VgsT3
         cMIVP1qNK3E6XVoQf3JdNSQxYN9nA2xAW+90uK+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huisong Li <lihuisong@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 191/717] ACPI: PCC: replace wait_for_completion()
Date:   Sat, 22 Oct 2022 09:21:10 +0200
Message-Id: <20221022072449.415628006@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 91cefefb699120efd0a5ba345d12626b688f86ce ]

Currently, the function waiting for completion of mailbox operation is
'wait_for_completion()'.  The PCC method will be permanently blocked if
this mailbox message fails to execute. So this patch replaces it with
'wait_for_completion_timeout()'. And set the timeout interval to an
arbitrary retries on top of nominal to prevent the remote processor is
slow to respond to PCC commands.

Fixes: 77e2a04745ff ("ACPI: PCC: Implement OperationRegion handler for the PCC Type 3 subtype")
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index 84f1ac416b57..16ba875e3293 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -23,6 +23,12 @@
 
 #include <acpi/pcc.h>
 
+/*
+ * Arbitrary retries in case the remote processor is slow to respond
+ * to PCC commands
+ */
+#define PCC_CMD_WAIT_RETRIES_NUM	500
+
 struct pcc_data {
 	struct pcc_mbox_chan *pcc_chan;
 	void __iomem *pcc_comm_addr;
@@ -89,6 +95,7 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 {
 	int ret;
 	struct pcc_data *data = region_context;
+	u64 usecs_lat;
 
 	reinit_completion(&data->done);
 
@@ -99,8 +106,20 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 	if (ret < 0)
 		return AE_ERROR;
 
-	if (data->pcc_chan->mchan->mbox->txdone_irq)
-		wait_for_completion(&data->done);
+	if (data->pcc_chan->mchan->mbox->txdone_irq) {
+		/*
+		 * pcc_chan->latency is just a Nominal value. In reality the remote
+		 * processor could be much slower to reply. So add an arbitrary
+		 * amount of wait on top of Nominal.
+		 */
+		usecs_lat = PCC_CMD_WAIT_RETRIES_NUM * data->pcc_chan->latency;
+		ret = wait_for_completion_timeout(&data->done,
+						  usecs_to_jiffies(usecs_lat));
+		if (ret == 0) {
+			pr_err("PCC command executed timeout!\n");
+			return AE_TIME;
+		}
+	}
 
 	mbox_client_txdone(data->pcc_chan->mchan, ret);
 
-- 
2.35.1



