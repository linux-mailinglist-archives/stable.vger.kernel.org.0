Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A53E6D4869
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbjDCO21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjDCO20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:28:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E163F31280
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69D2D61DBF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3C7C433EF;
        Mon,  3 Apr 2023 14:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532104;
        bh=9c5q+RRvk0Gpkk4KBxd4qoIs3IlyHdm46ev3J2FHPos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0JheTuKW6EgVpclz8STG8Z2Ngh8qwqkTcIUd0FdxRtz4IIS5vQzoIX699j4M1xAt
         b/mW1Fac4oM8Rs9FLk3kUeoCLJ3ntNqheFM7MknhmvlU/f/bflRNXquh18fptodBf4
         yBEtssK2HcTKKFYNjOiTodujGMRmrFl6EPCR9zqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/173] scsi: megaraid_sas: Fix crash after a double completion
Date:   Mon,  3 Apr 2023 16:09:04 +0200
Message-Id: <20230403140418.629719805@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 2309df27111a51734cb9240b4d3c25f2f3c6ab06 ]

When a physical disk is attached directly "without JBOD MAP support" (see
megasas_get_tm_devhandle()) then there is no real error handling in the
driver.  Return FAILED instead of SUCCESS.

Fixes: 18365b138508 ("megaraid_sas: Task management support")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230324150134.14696-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 7838c7911adde..8eb126d48462b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4656,7 +4656,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"task abort issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
@@ -4726,7 +4726,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
-- 
2.39.2



