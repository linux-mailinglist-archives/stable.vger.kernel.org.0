Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839E5540C36
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352451AbiFGSe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351985AbiFGSdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2891C17EC31;
        Tue,  7 Jun 2022 10:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE068618A6;
        Tue,  7 Jun 2022 17:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B736CC34119;
        Tue,  7 Jun 2022 17:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624627;
        bh=Q+itXn3hIQY89jgs09acoeC4ijgZJV73GRwI4P2g/A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3SwYPFX0Sncb0H8+RUHfIvZE3A6GKRUMWCDHr7WliZ+U9S9pNjrBRV5G2WmqWIQW
         UjKMjC70TqHfkM9u5Xa1GJK217rqEH1XKyyWmheTH87d/0IJsqs0tk4eBQMqH9JIHR
         kV1S5Q59T2De1pHdTLtjVkqvlSEWjQfX1sy7X7Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/667] thermal/core: Fix memory leak in __thermal_cooling_device_register()
Date:   Tue,  7 Jun 2022 19:00:20 +0200
Message-Id: <20220607164945.404073755@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 98a160e898c0f4a979af9de3ab48b4b1d42d1dbb ]

I got memory leak as follows when doing fault injection test:

unreferenced object 0xffff888010080000 (size 264312):
  comm "182", pid 102533, jiffies 4296434960 (age 10.100s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 40 7f 1f b9 ff ff ff ff  ........@.......
  backtrace:
    [<0000000038b2f4fc>] kmalloc_order_trace+0x1d/0x110 mm/slab_common.c:969
    [<00000000ebcb8da5>] __kmalloc+0x373/0x420 include/linux/slab.h:510
    [<0000000084137f13>] thermal_cooling_device_setup_sysfs+0x15d/0x2d0 include/linux/slab.h:586
    [<00000000352b8755>] __thermal_cooling_device_register+0x332/0xa60 drivers/thermal/thermal_core.c:927
    [<00000000fb9f331b>] devm_thermal_of_cooling_device_register+0x6b/0xf0 drivers/thermal/thermal_core.c:1041
    [<000000009b8012d2>] max6650_probe.cold+0x557/0x6aa drivers/hwmon/max6650.c:211
    [<00000000da0b7e04>] i2c_device_probe+0x472/0xac0 drivers/i2c/i2c-core-base.c:561

If device_register() fails, thermal_cooling_device_destroy_sysfs() need be called
to free the memory allocated in thermal_cooling_device_setup_sysfs().

Fixes: 8ea229511e06 ("thermal: Add cooling device's statistics in sysfs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220511020605.3096734-1-yangyingliang@huawei.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 13891745a971..867c8aa92b3a 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -945,6 +945,7 @@ __thermal_cooling_device_register(struct device_node *np,
 	return cdev;
 
 out_kfree_type:
+	thermal_cooling_device_destroy_sysfs(cdev);
 	kfree(cdev->type);
 	put_device(&cdev->device);
 	cdev = NULL;
-- 
2.35.1



