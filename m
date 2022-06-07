Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B54540A4B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbiFGSTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352124AbiFGSQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCB2DF6C;
        Tue,  7 Jun 2022 10:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E310FB822B8;
        Tue,  7 Jun 2022 17:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D067FC385A5;
        Tue,  7 Jun 2022 17:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624233;
        bh=0KgVnNg3raFhkkrxo21ggjo3TDOCzdatO+D6k+zNRNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFoTaSpy2N2qDru6cNFktUXiiOPsdxhqPViYizl2831L0idSEon7RIIktqqJbscmm
         xrtJfk8Wt1drSfyo+/f0eWARpaCSYKhxas/Dq2hi7jLI63Z0WsGDLNUVxSfSRc3bfS
         mQ79p03XkjbX1fhMY1Vppd6YmpvV1PWzactCO8aMOzo7gPRYhWS+z9JNIi3eC3qJ/Y
         T40mIFW96xsYeWHGkPjmwr//KaS9gcsBIZSuzS3Ccjq9o/QZcY2f1TMmcoFC3JDy64
         j4CSBca0h7cNHVvMh34tW2+2pZswhz/nTt8FQVIEhMFp4Yj6upxr/wKau0ryYbLlAv
         hSbOz0uBRM2UA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     bumwoo lee <bw365.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, myungjoo.ham@samsung.com
Subject: [PATCH AUTOSEL 5.18 25/68] extcon: Modify extcon device to be created after driver data is set
Date:   Tue,  7 Jun 2022 13:47:51 -0400
Message-Id: <20220607174846.477972-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: bumwoo lee <bw365.lee@samsung.com>

[ Upstream commit 5dcc2afe716d69f5112ce035cb14f007461ff189 ]

Currently, someone can invoke the sysfs such as state_show()
intermittently before dev_set_drvdata() is done.
And it can be a cause of kernel Oops because of edev is Null at that time.
So modified the driver registration to after setting drviver data.

- Oops's backtrace.

Backtrace:
[<c067865c>] (state_show) from [<c05222e8>] (dev_attr_show)
[<c05222c0>] (dev_attr_show) from [<c02c66e0>] (sysfs_kf_seq_show)
[<c02c6648>] (sysfs_kf_seq_show) from [<c02c496c>] (kernfs_seq_show)
[<c02c4938>] (kernfs_seq_show) from [<c025e2a0>] (seq_read)
[<c025e11c>] (seq_read) from [<c02c50a0>] (kernfs_fop_read)
[<c02c5064>] (kernfs_fop_read) from [<c0231cac>] (__vfs_read)
[<c0231c5c>] (__vfs_read) from [<c0231ee0>] (vfs_read)
[<c0231e34>] (vfs_read) from [<c0232464>] (ksys_read)
[<c02323f0>] (ksys_read) from [<c02324fc>] (sys_read)
[<c02324e4>] (sys_read) from [<c00091d0>] (__sys_trace_return)

Signed-off-by: bumwoo lee <bw365.lee@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index adb957470c65..97e35c32bfa5 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -1220,19 +1220,14 @@ int extcon_dev_register(struct extcon_dev *edev)
 		edev->dev.type = &edev->extcon_dev_type;
 	}
 
-	ret = device_register(&edev->dev);
-	if (ret) {
-		put_device(&edev->dev);
-		goto err_dev;
-	}
-
 	spin_lock_init(&edev->lock);
-	edev->nh = devm_kcalloc(&edev->dev, edev->max_supported,
-				sizeof(*edev->nh), GFP_KERNEL);
-	if (!edev->nh) {
-		ret = -ENOMEM;
-		device_unregister(&edev->dev);
-		goto err_dev;
+	if (edev->max_supported) {
+		edev->nh = kcalloc(edev->max_supported, sizeof(*edev->nh),
+				GFP_KERNEL);
+		if (!edev->nh) {
+			ret = -ENOMEM;
+			goto err_alloc_nh;
+		}
 	}
 
 	for (index = 0; index < edev->max_supported; index++)
@@ -1243,6 +1238,12 @@ int extcon_dev_register(struct extcon_dev *edev)
 	dev_set_drvdata(&edev->dev, edev);
 	edev->state = 0;
 
+	ret = device_register(&edev->dev);
+	if (ret) {
+		put_device(&edev->dev);
+		goto err_dev;
+	}
+
 	mutex_lock(&extcon_dev_list_lock);
 	list_add(&edev->entry, &extcon_dev_list);
 	mutex_unlock(&extcon_dev_list_lock);
@@ -1250,6 +1251,9 @@ int extcon_dev_register(struct extcon_dev *edev)
 	return 0;
 
 err_dev:
+	if (edev->max_supported)
+		kfree(edev->nh);
+err_alloc_nh:
 	if (edev->max_supported)
 		kfree(edev->extcon_dev_type.groups);
 err_alloc_groups:
@@ -1310,6 +1314,7 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 	if (edev->max_supported) {
 		kfree(edev->extcon_dev_type.groups);
 		kfree(edev->cables);
+		kfree(edev->nh);
 	}
 
 	put_device(&edev->dev);
-- 
2.35.1

