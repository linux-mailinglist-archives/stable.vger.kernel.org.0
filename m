Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5A568D7BD
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjBGNDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbjBGNCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271F43C16
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5F9CB8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABBBC433EF;
        Tue,  7 Feb 2023 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774944;
        bh=M2zJ7CPJFNoHYsbsd63N1OsZvqRb6iZZJPoeel5PLyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIILyODHpSYMXBVugzHU+WpX5bbPOZkcY8BPUR08CS1upEt41Kcpn/FeQ8lyIZJN1
         EP4QvPvdjzm4WvrfTBz0VGBJSY497JsmTM//AHIVNlLrdXWnGOryT1hL9+V854CSIn
         9bJo5yiLKFX6AwDdNWseRWZFLuJ5TGTdxzSKBLC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/208] platform/x86/amd/pmf: Ensure mutexes are initialized before use
Date:   Tue,  7 Feb 2023 13:55:12 +0100
Message-Id: <20230207125636.908816971@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e0c40529ff942a985eb0f3dacf18d35ee4dbb03d ]

As soon as the first handler or sysfs file is registered
the mutex may get used.

Move the initialization to before any handler registration /
sysfs file creation.

Likewise move the destruction of the mutex to after all
the de-initialization is done.

Fixes: da5ce22df5fe ("platform/x86/amd/pmf: Add support for PMF core layer")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230130132554.696025-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index c9f7bcef4ac8..da23639071d7 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -385,6 +385,9 @@ static int amd_pmf_probe(struct platform_device *pdev)
 	if (!dev->regbase)
 		return -ENOMEM;
 
+	mutex_init(&dev->lock);
+	mutex_init(&dev->update_mutex);
+
 	apmf_acpi_init(dev);
 	platform_set_drvdata(pdev, dev);
 	amd_pmf_init_features(dev);
@@ -394,8 +397,6 @@ static int amd_pmf_probe(struct platform_device *pdev)
 	dev->pwr_src_notifier.notifier_call = amd_pmf_pwr_src_notify_call;
 	power_supply_reg_notifier(&dev->pwr_src_notifier);
 
-	mutex_init(&dev->lock);
-	mutex_init(&dev->update_mutex);
 	dev_info(dev->dev, "registered PMF device successfully\n");
 
 	return 0;
@@ -406,11 +407,11 @@ static int amd_pmf_remove(struct platform_device *pdev)
 	struct amd_pmf_dev *dev = platform_get_drvdata(pdev);
 
 	power_supply_unreg_notifier(&dev->pwr_src_notifier);
-	mutex_destroy(&dev->lock);
-	mutex_destroy(&dev->update_mutex);
 	amd_pmf_deinit_features(dev);
 	apmf_acpi_deinit(dev);
 	amd_pmf_dbgfs_unregister(dev);
+	mutex_destroy(&dev->lock);
+	mutex_destroy(&dev->update_mutex);
 	kfree(dev->buf);
 	return 0;
 }
-- 
2.39.0



