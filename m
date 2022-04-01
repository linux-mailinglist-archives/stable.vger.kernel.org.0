Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091574EF39D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351383AbiDAPHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350132AbiDAO7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEED56C23;
        Fri,  1 Apr 2022 07:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF07060A3C;
        Fri,  1 Apr 2022 14:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D35C2BBE4;
        Fri,  1 Apr 2022 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824394;
        bh=tkeNPRTeNCg3I4EubeoVXkxqOabZ9vgTkmUy2NLLq98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owP7+ufvlpjnHIkEnQGvt8ChAoKRX/pFO13K26we25lpu3kPmC6BlKd2ktLo/kkEp
         rzPvrB67/cxmOaR8NZ6N4saMRuymmTIYYkcjybvvQkslmFxhoY/X7MfSvnOJGvkFzv
         Nfnb024rpyvWxdWPeNIACXRrgW2P0b/NPKoTo2tw2uqfvNT/6GrgXQy74eAE4vcU/C
         cDn8pr9r9eFFEpv02jn+G9608+wjg2XSVhGVYvnmufacMQY2jkGkGv8DuYVujjKvJB
         E1BDAr12zS5k1LXS9x8f+pAtGuEozYtFazGdfU+s1mWjVweC162Ke5lmnuaQjm5ceb
         +WduQe7VkE/qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        john.garry@huawei.com, bvanassche@acm.org,
        thunder.leizhen@huawei.com, yuyufen@huawei.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/29] scsi: mvsas: Replace snprintf() with sysfs_emit()
Date:   Fri,  1 Apr 2022 10:45:49 -0400
Message-Id: <20220401144612.1955177-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
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
index 98d6608068ab..9c48394ac68a 100644
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

