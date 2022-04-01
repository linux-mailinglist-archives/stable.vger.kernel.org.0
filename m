Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F834EF427
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352861AbiDAPIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350544AbiDAPAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9831A64BF3;
        Fri,  1 Apr 2022 07:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2450A60AC9;
        Fri,  1 Apr 2022 14:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E2EC340EE;
        Fri,  1 Apr 2022 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824463;
        bh=J1f0lQ9piKBazL8l/JdIIROG6EMQUCVmrex/JmHS88Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gg7GJdaGJYw1+dD+MbOYw9ithpQ13PUlxc7zHfkNt2M7Z8OMQy/AtnLPsi6M4J9Hx
         tYg/EB2iwShmW6qK9EwwgPns7hNXgua1ptZA0PvFbqNtzJuYMc1Zq7qDdU+bYO1H5d
         AMAMwt4upgFrGQWfroING+SrUT1oBuUdLI0bZpRPajgU2kqanJIkWIDMUqX4E794+/
         12qs63lhfGPzZBOO5Cg9LE2lWZfZdtPG/xk5wTzlZGlqc3a/xPrtxtX4u8YQ1ecW+u
         KG1zIG0EkzY3AeKhRczKwy+bZgXNzOEbxT0RPRINRkY7hs40FPEGUPFmQO4EuBkg2w
         /nl9Xak9jV34A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        john.garry@huawei.com, bvanassche@acm.org, yuyufen@huawei.com,
        johannes.thumshirn@wdc.com, thunder.leizhen@huawei.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/22] scsi: mvsas: Replace snprintf() with sysfs_emit()
Date:   Fri,  1 Apr 2022 10:47:11 -0400
Message-Id: <20220401144729.1955554-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144729.1955554-1-sashal@kernel.org>
References: <20220401144729.1955554-1-sashal@kernel.org>
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

From: Yang Guang <yang.guang5@zte.com.cn>

[ Upstream commit 0ad3867b0f13e45cfee5a1298bfd40eef096116c ]

coccinelle report:
./drivers/scsi/mvsas/mv_init.c:699:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/mvsas/mv_init.c:747:8-16:
WARNING: use scnprintf or sprintf

Use sysfs_emit() instead of scnprintf() or sprintf().

Link: https://lore.kernel.org/r/c1711f7cf251730a8ceb5bdfc313bf85662b3395.1643182948.git.yang.guang5@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 718c88de328b..f6070b1fe1d8 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -729,7 +729,7 @@ static ssize_t
 mvs_show_driver_version(struct device *cdev,
 		struct device_attribute *attr,  char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
+	return sysfs_emit(buffer, "%s\n", DRV_VERSION);
 }
 
 static DEVICE_ATTR(driver_version,
@@ -781,7 +781,7 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 static ssize_t mvs_show_interrupt_coalescing(struct device *cdev,
 			struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%d\n", interrupt_coalescing);
+	return sysfs_emit(buffer, "%d\n", interrupt_coalescing);
 }
 
 static DEVICE_ATTR(interrupt_coalescing,
-- 
2.34.1

