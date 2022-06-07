Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10500540E49
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349799AbiFGSxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354550AbiFGSrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE745B0D18;
        Tue,  7 Jun 2022 11:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 805D0B82349;
        Tue,  7 Jun 2022 18:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EA8C3411F;
        Tue,  7 Jun 2022 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624923;
        bh=2nCehD+6zsqESb8V+De9ZH7Y5QDMbXTzj6OC/Q9De78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvA0NVYuCyaRe1sDIoPewiHrEqSrWt5vNLhoKpIAeJfPdv65tk90yZKwqYa1nv08l
         khgf8Mb4WzCKhpnhKMrcQywzy9+1uT9h1iVI5TK3tK5nbjgz/39WCDfnrawig6ZjuG
         sN+xEypwkQ1G3d4MHb9wcAzF1z2kMdRAzOwIGu6UO+Dd4U3+PkWLL9GgjdCXljfUND
         poYFFx5zpxWOn+JWCDQ6zVVGUN3RrqJZByDIGFc1WPHU17C05EjzP1ljTi+q0192ef
         kehb0bh0f7NiKy5B/So39kIioLBOt/oH+bcayIK60sRHyVOWISxEtSeyKlG66ebwlJ
         BsdFYHo2g88nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     bumwoo lee <bw365.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, myungjoo.ham@samsung.com
Subject: [PATCH AUTOSEL 4.19 13/27] extcon: Modify extcon device to be created after driver data is set
Date:   Tue,  7 Jun 2022 14:01:17 -0400
Message-Id: <20220607180133.481701-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180133.481701-1-sashal@kernel.org>
References: <20220607180133.481701-1-sashal@kernel.org>
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
index e70f21ae85ff..4c70136c7aa3 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -1245,19 +1245,14 @@ int extcon_dev_register(struct extcon_dev *edev)
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
@@ -1268,6 +1263,12 @@ int extcon_dev_register(struct extcon_dev *edev)
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
@@ -1275,6 +1276,9 @@ int extcon_dev_register(struct extcon_dev *edev)
 	return 0;
 
 err_dev:
+	if (edev->max_supported)
+		kfree(edev->nh);
+err_alloc_nh:
 	if (edev->max_supported)
 		kfree(edev->extcon_dev_type.groups);
 err_alloc_groups:
@@ -1335,6 +1339,7 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 	if (edev->max_supported) {
 		kfree(edev->extcon_dev_type.groups);
 		kfree(edev->cables);
+		kfree(edev->nh);
 	}
 
 	put_device(&edev->dev);
-- 
2.35.1

