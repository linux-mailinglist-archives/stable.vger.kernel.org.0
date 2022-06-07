Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB3541B8F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381546AbiFGVtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381947AbiFGVsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7BE2390B4;
        Tue,  7 Jun 2022 12:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A390618D9;
        Tue,  7 Jun 2022 19:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A909C385A5;
        Tue,  7 Jun 2022 19:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628893;
        bh=UuQZ3aoQiDfMsk594do238/iZ/yCyfLgx4h9ODokf6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxAxAlOk/zzWQSBtk2oicDG7otmhPkXu0n/fgr8+DaOHZ8VhN8hbU8nZtL5KnW3rW
         ca/knTT9HBwlPzUQq/fMaljOq/jJ2yQh2JrkrU1OjG6yhgJ3r4sO59M/L74AEb2CE/
         YrsROGxOM7352dcXSgzw3zJYxlhzml4yKXe3tt0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 493/879] thermal/core: Fix memory leak in __thermal_cooling_device_register()
Date:   Tue,  7 Jun 2022 19:00:11 +0200
Message-Id: <20220607165017.181609930@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 82654dc8382b..cdc0552e8c42 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -947,6 +947,7 @@ __thermal_cooling_device_register(struct device_node *np,
 	return cdev;
 
 out_kfree_type:
+	thermal_cooling_device_destroy_sysfs(cdev);
 	kfree(cdev->type);
 	put_device(&cdev->device);
 	cdev = NULL;
-- 
2.35.1



