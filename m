Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048785A6A7F
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiH3RaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiH3R3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:29:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57115161DF2;
        Tue, 30 Aug 2022 10:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF80AB81D1C;
        Tue, 30 Aug 2022 17:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9376EC433C1;
        Tue, 30 Aug 2022 17:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880288;
        bh=LszwIUf0eKjljYdr0JRDc31G7ffCLdWv84uL0twAOtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AD/bGRYzIMx8albvkWMMTuibqHn416IJ6oWsq91eVJjRsd9S6lrpWej29NQfy4e4A
         Kt+pdKbrNmWo+8tkenWGxDk23calyxkQ/gHQuDoqqWL5rA8sVxsT5973Q+cQpf2DIj
         QcSK0qv8AZ2zFhwyh1IphdtE3P395bySOkxx1/vZJPcVjqmcppyIkLIYyajm3X7j8l
         sqFzE3YkEkmJG9M+SGxN6ndmle3nAGE+hdJEZT1lhGvPq6OqoIQ/N8Zwbj2GY8KsLN
         ToOTm+bVe86m96OQ7r2CoQZjJ9w++Jrb04MO5ljlvgMtNmemP3qqEbwD0uMwB8dIJL
         nsjV0YQQ0ciTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guixin Liu <kanie@linux.alibaba.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/12] scsi: megaraid_sas: Fix double kfree()
Date:   Tue, 30 Aug 2022 13:24:33 -0400
Message-Id: <20220830172444.581654-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172444.581654-1-sashal@kernel.org>
References: <20220830172444.581654-1-sashal@kernel.org>
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
index a78a702511faa..944273f60d224 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5182,7 +5182,6 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 		if (!fusion->log_to_span) {
 			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 				__func__, __LINE__);
-			kfree(instance->ctrl_context);
 			return -ENOMEM;
 		}
 	}
-- 
2.35.1

