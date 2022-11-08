Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDDB621302
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiKHNpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbiKHNpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:45:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DB459848
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:45:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4567B81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE195C433C1;
        Tue,  8 Nov 2022 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915119;
        bh=/wGlT+QhkWG2h4FTk1k4oTukuTiH9gjGcU7KB5wHmPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sg2dFdg4UKcq0e+9Tv6Ko5rML2s8PN5xMuG5gThMzRMoQWOEcFztvFUAGFJv2oODs
         C6VZJD1GCQxX1qSWTX1zIIYL87OQRmqyEXZt0yvxZw5s30aqhWKF7RWW6KPipIne0a
         TyetYsnc7yK3GxhMG0Yj2KJhOXgpgLxkKR91wddc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/48] mISDN: fix possible memory leak in mISDN_register_device()
Date:   Tue,  8 Nov 2022 14:39:01 +0100
Message-Id: <20221108133330.079793428@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e7d1d4d9ac0dfa40be4c2c8abd0731659869b297 ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
add put_device() to give up the reference, so that the name can be
freed in kobject_cleanup() when the refcount is 0.

Set device class before put_device() to avoid null release() function
WARN message in device_release().

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index f5a06a6fb297..5cd53b2c47c7 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -242,11 +242,12 @@ mISDN_register_device(struct mISDNdevice *dev,
 	if (debug & DEBUG_CORE)
 		printk(KERN_DEBUG "mISDN_register %s %d\n",
 		       dev_name(&dev->dev), dev->id);
+	dev->dev.class = &mISDN_class;
+
 	err = create_stack(dev);
 	if (err)
 		goto error1;
 
-	dev->dev.class = &mISDN_class;
 	dev->dev.platform_data = dev;
 	dev->dev.parent = parent;
 	dev_set_drvdata(&dev->dev, dev);
@@ -258,8 +259,8 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 error3:
 	delete_stack(dev);
-	return err;
 error1:
+	put_device(&dev->dev);
 	return err;
 
 }
-- 
2.35.1



