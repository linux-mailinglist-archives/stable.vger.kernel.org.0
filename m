Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41A64EC272
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344389AbiC3L7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345921AbiC3LzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA96BA2;
        Wed, 30 Mar 2022 04:52:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8465E61616;
        Wed, 30 Mar 2022 11:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0815C34111;
        Wed, 30 Mar 2022 11:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641164;
        bh=NjDs/hNJ5jIoUTekqUpGzHpgZgjOw+eFz6PtiTcPvs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhI4nj3oSpONL+nLST4sQSjZ2qIp1MpPVYV9tkJc2nJ4r0LXl2OYWNBjKfGHLrjx8
         jW6icdIBCD/sQ6MMEzyfM9Vs+oFQCtcrZRIizqjhMByid/pnsdrOQXM7DeLixaTYV7
         PAwbiacSUX8BS1oP0s37cj6DC1pPBJeW0fXE4W2gGGc+UuiIMdvO4rPCDikA8UDx6B
         P5LMtoXGY58pq/21TdgmA0jPN+gDAhpnMHEpz3AnVwCqXmyS/aR5rRBGiUnQBTXAYO
         V9DTO3+e80v6ge3J2DMRIOo1ogBP5NMetGIq1eFiZVfLMW4l/nWExkHWgHJSJJMoxE
         FRLqmRrZnPPeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Yao <yao.jing2@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        bernie@plugable.com, tomi.valkeinen@ti.com,
        linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/25] video: fbdev: udlfb: replace snprintf in show functions with sysfs_emit
Date:   Wed, 30 Mar 2022 07:52:12 -0400
Message-Id: <20220330115225.1672278-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115225.1672278-1-sashal@kernel.org>
References: <20220330115225.1672278-1-sashal@kernel.org>
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

From: Jing Yao <yao.jing2@zte.com.cn>

[ Upstream commit 81a998288956d09d7a7a2303d47e4d60ad55c401 ]

Use sysfs_emit instead of scnprintf, snprintf or sprintf.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/udlfb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index ecbfbbf1c1a7..e269b1391e14 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1427,7 +1427,7 @@ static ssize_t metrics_bytes_rendered_show(struct device *fbdev,
 				   struct device_attribute *a, char *buf) {
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dlfb = fb_info->par;
-	return snprintf(buf, PAGE_SIZE, "%u\n",
+	return sysfs_emit(buf, "%u\n",
 			atomic_read(&dlfb->bytes_rendered));
 }
 
@@ -1435,7 +1435,7 @@ static ssize_t metrics_bytes_identical_show(struct device *fbdev,
 				   struct device_attribute *a, char *buf) {
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dlfb = fb_info->par;
-	return snprintf(buf, PAGE_SIZE, "%u\n",
+	return sysfs_emit(buf, "%u\n",
 			atomic_read(&dlfb->bytes_identical));
 }
 
@@ -1443,7 +1443,7 @@ static ssize_t metrics_bytes_sent_show(struct device *fbdev,
 				   struct device_attribute *a, char *buf) {
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dlfb = fb_info->par;
-	return snprintf(buf, PAGE_SIZE, "%u\n",
+	return sysfs_emit(buf, "%u\n",
 			atomic_read(&dlfb->bytes_sent));
 }
 
@@ -1451,7 +1451,7 @@ static ssize_t metrics_cpu_kcycles_used_show(struct device *fbdev,
 				   struct device_attribute *a, char *buf) {
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dlfb = fb_info->par;
-	return snprintf(buf, PAGE_SIZE, "%u\n",
+	return sysfs_emit(buf, "%u\n",
 			atomic_read(&dlfb->cpu_kcycles_used));
 }
 
-- 
2.34.1

