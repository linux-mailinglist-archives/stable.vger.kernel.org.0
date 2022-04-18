Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D824A505980
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344033AbiDROUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344133AbiDRORi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:17:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EBF3A5CE;
        Mon, 18 Apr 2022 06:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F74CB80D9C;
        Mon, 18 Apr 2022 13:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF32EC385A1;
        Mon, 18 Apr 2022 13:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287581;
        bh=U2aqSQRcO3Ua6VHdsYF7eOR1PZBWh0HF8CK6JHPZJr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u13bp0Ee1kQNm2F3VwOB6FZ8gLcZShKhTeI1TncHli8qPzLDFPt7YCnAemTHHxxUr
         +xkJ9qHxWhg4CacsGwECscGuaWnVA4DSTO4YaAulMC0effPYnVqSgjNx/b0nS3iDbH
         OWrijBb4OqK6GYN9Xld9mXXW1KNV8phrc/OSK4DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Yang Guang <yang.guang5@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 169/218] scsi: mvsas: Replace snprintf() with sysfs_emit()
Date:   Mon, 18 Apr 2022 14:13:55 +0200
Message-Id: <20220418121205.308836125@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8280046fd1f0..230697f9df78 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -730,7 +730,7 @@ static ssize_t
 mvs_show_driver_version(struct device *cdev,
 		struct device_attribute *attr,  char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
+	return sysfs_emit(buffer, "%s\n", DRV_VERSION);
 }
 
 static DEVICE_ATTR(driver_version,
@@ -782,7 +782,7 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 static ssize_t mvs_show_interrupt_coalescing(struct device *cdev,
 			struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%d\n", interrupt_coalescing);
+	return sysfs_emit(buffer, "%d\n", interrupt_coalescing);
 }
 
 static DEVICE_ATTR(interrupt_coalescing,
-- 
2.35.1



