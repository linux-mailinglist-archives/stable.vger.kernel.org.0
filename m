Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69065A69F6
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiH3RY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiH3RYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:24:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5599AF7B13;
        Tue, 30 Aug 2022 10:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B944AB81D15;
        Tue, 30 Aug 2022 17:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E730C433C1;
        Tue, 30 Aug 2022 17:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880107;
        bh=Flt/mF2z0wxXkni/7rusTf9mZAlqIp6ClD2ug9pddeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3TW1HWmaEOcP9Yb1ub6kuVT0h1wLuIGQ45lkndAP2fBcnbAPKrUg2syXq4B6tD8t
         AKac4NhPDQS2jqNUflju8AZ6n3sJj6XPbOYzfVnsW6r5XLGeXmn+xbgoI200abXRvQ
         SYxYwgmYsMcyaanjF/Ivb4mDNDSsZ4c/Zc/UG5S9w4a8n+3CkS9c0jyQWI0TXeBJiU
         vFTYe1gf4ZtlR1r0jrRQYvI9ykbYlynT4f+w5RYu528v7u2AlyelQIz3FKfDVxj2/1
         qm5UatObtaFtQ5bQRQmNZjqaHFA+HvqZ1/dM8EQcVp/pXMDfbBD4xY742/USaoNQfW
         lTxWgApw45leA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guixin Liu <kanie@linux.alibaba.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/23] scsi: megaraid_sas: Fix double kfree()
Date:   Tue, 30 Aug 2022 13:21:20 -0400
Message-Id: <20220830172141.581086-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172141.581086-1-sashal@kernel.org>
References: <20220830172141.581086-1-sashal@kernel.org>
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
index eb5ceb75a15ec..056837849ead5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5279,7 +5279,6 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 		if (!fusion->log_to_span) {
 			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 				__func__, __LINE__);
-			kfree(instance->ctrl_context);
 			return -ENOMEM;
 		}
 	}
-- 
2.35.1

