Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875C25A6A30
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiH3R0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbiH3R0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:26:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469D1153D3F;
        Tue, 30 Aug 2022 10:24:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 589F161797;
        Tue, 30 Aug 2022 17:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F093C433B5;
        Tue, 30 Aug 2022 17:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880203;
        bh=WHrlCYdi1bSrzecsw/MQNXNF2LLpNKQ3Aly2GDKG3Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSeRb8wnZLsXWHFeB5Rz8iE3gO7O2R0cxmyO/Df5QlIs3rsgBuH29gIfkkrbx8hOU
         aDCKK/8p4slKOkKWi04bpDsS4QoQQCROeaTNgDMve0j5KxqrbD3Tm3qolveDMR66Ht
         TocJRflmBO6jBw1Ci7xNLz8fopZ4M7mQEt5HTReqKuLE7wij1njer8NCVAtNtE4/Ug
         hgTRCZZOSsV5ztt0ROrPBBNKR5Vuxjn5mmxo+VdIenQA9FLrGy1Lsgqbpps8Y4N5K/
         RgXK2H7dAE42mvb4X3nsAaBzH8hrgApKLth9bgZbncm86sg1rgktq6OtgBGbQoT3op
         V9NKDm0idnTsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guixin Liu <kanie@linux.alibaba.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/16] scsi: megaraid_sas: Fix double kfree()
Date:   Tue, 30 Aug 2022 13:23:04 -0400
Message-Id: <20220830172317.581397-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172317.581397-1-sashal@kernel.org>
References: <20220830172317.581397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 8c499e49240bd93628368c3588975cfb94169b8b ]

When allocating log_to_span fails, kfree(instance->ctrl_context) is called
twice. Remove redundant call.

Link: https://lore.kernel.org/r/1659424729-46502-1-git-send-email-kanie@linux.alibaba.com
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 13022a42fd6f4..7838c7911adde 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5198,7 +5198,6 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 		if (!fusion->log_to_span) {
 			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 				__func__, __LINE__);
-			kfree(instance->ctrl_context);
 			return -ENOMEM;
 		}
 	}
-- 
2.35.1

