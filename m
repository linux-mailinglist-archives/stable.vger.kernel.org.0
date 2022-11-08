Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1386212BD
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbiKHNmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiKHNmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4691D49B7A
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:42:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DC506158F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0898C433D7;
        Tue,  8 Nov 2022 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914936;
        bh=/wGlT+QhkWG2h4FTk1k4oTukuTiH9gjGcU7KB5wHmPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkru5i7j6eJ43qNYCiP4v4m9kwPfYdUmuwLUAgdz+IO5QxFHVr/GNy8vdYixcOC/f
         tNCjwHaA23L9LuxcKnS6r+d1d++XxF1OU7JR6IQpFqzEnCz0gqnk64/J11M3zJSKoy
         oKkYrqpNMNAf/yBggFD4EkeSEvCjLlZ9dcp0K2r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/30] mISDN: fix possible memory leak in mISDN_register_device()
Date:   Tue,  8 Nov 2022 14:38:59 +0100
Message-Id: <20221108133327.102910741@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
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



