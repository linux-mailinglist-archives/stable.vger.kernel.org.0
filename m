Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A377D538246
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiE3OWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241304AbiE3OR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DD1119906;
        Mon, 30 May 2022 06:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD24660F32;
        Mon, 30 May 2022 13:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183C9C3411E;
        Mon, 30 May 2022 13:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918307;
        bh=55EFUHYI6iK3HJOyWc8Wq0BuBvU2+I+Lp1UrneWLr+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSWxY+7Cf/IyeXkspgcMLXfFotSy3jEL5MgZgX5clOEL64EjMe+uUBdVPc2Z480tG
         8Gy6UiwoIOjuTze6SlhDq0nX27maCxOFArrSPXgtTlY3zAIi7OOSEHMWhdJSDbxaH4
         Z7HwSM5fhuaJMGFc1KLGcIQk/LVeVVkcs62bfh5tq2jdb02ZebLOOZnWGLvwOxcRUv
         OV3PIMphQetbtDN+UyZfTKHBKFmy3MBPnwN2+fbYgFCxPX9XGIWzb3YCRAqISHmW2P
         X4EzkW8MLBJTV/rE0nBrPTzVGPNGtvkD/GfBMh4kHomjZeYH2G3SLdMjadh+YHTk/U
         vmCqFfCqk0SIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/76] scsi: megaraid: Fix error check return value of register_chrdev()
Date:   Mon, 30 May 2022 09:43:18 -0400
Message-Id: <20220530134406.1934928-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit c5acd61dbb32b6bda0f3a354108f2b8dcb788985 ]

If major equals 0, register_chrdev() returns an error code when it fails.
This function dynamically allocates a major and returns its number on
success, so we should use "< 0" to check it instead of "!".

Link: https://lore.kernel.org/r/20220418105755.2558828-1-lv.ruyi@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 80f546976c7e..daffa36988ae 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4634,7 +4634,7 @@ static int __init megaraid_init(void)
 	 * major number allocation.
 	 */
 	major = register_chrdev(0, "megadev_legacy", &megadev_fops);
-	if (!major) {
+	if (major < 0) {
 		printk(KERN_WARNING
 				"megaraid: failed to register char device\n");
 	}
-- 
2.35.1

