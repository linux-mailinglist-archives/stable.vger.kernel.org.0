Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50E15B70C1
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbiIMO3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbiIMO2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70C567CAE;
        Tue, 13 Sep 2022 07:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8931614D4;
        Tue, 13 Sep 2022 14:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A32C433B5;
        Tue, 13 Sep 2022 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078641;
        bh=Flt/mF2z0wxXkni/7rusTf9mZAlqIp6ClD2ug9pddeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqEWCTKvMTIV+nAQISOo4Xy0B83IZLT26IBAnUNumzT9o4fAp7bpMGMypMzlRDg1+
         TSW9ae7ZII3VDPYaY4K9EZuUjMLv0HDhZl1wfp7ROIzQbto7qFfWuGxKL7QP8gGWY8
         9YvqWcwHCb6Dh3wRiFzBmIWw7LfLuxd7WBrfxHg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>,
        Guixin Liu <kanie@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/121] scsi: megaraid_sas: Fix double kfree()
Date:   Tue, 13 Sep 2022 16:03:20 +0200
Message-Id: <20220913140357.733101855@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



