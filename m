Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6A65EBE4
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbjAENDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjAENDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:03:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1BA5792E
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:03:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6716BB81ABD
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE19C433D2;
        Thu,  5 Jan 2023 13:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923812;
        bh=LTp6fvFAwZeP0/UabPzonG7VdBWlE5e6OsrQs0qC/Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8zgmaVpnFsXURni55W7kxDne2qk0QKXOpuO7TeUtG0LbwUBGy6zppn89Lo2bokzY
         3tFUKD4l1E3uPYk+k+4D0GuWErc2r9FqvUKHa0oOWx8VxbF1PvmzHoEKWwijyiQ08J
         oy2K1JtnE6FCjqwmi2+9Pe76PKxgg1Lp1rE4SMyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 141/251] chardev: fix error handling in cdev_device_add()
Date:   Thu,  5 Jan 2023 13:54:38 +0100
Message-Id: <20230105125341.299376896@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

[ Upstream commit 11fa7fefe3d8fac7da56bc9aa3dd5fb3081ca797 ]

While doing fault injection test, I got the following report:

------------[ cut here ]------------
kobject: '(null)' (0000000039956980): is not initialized, yet kobject_put() is being called.
WARNING: CPU: 3 PID: 6306 at kobject_put+0x23d/0x4e0
CPU: 3 PID: 6306 Comm: 283 Tainted: G        W          6.1.0-rc2-00005-g307c1086d7c9 #1253
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:kobject_put+0x23d/0x4e0
Call Trace:
 <TASK>
 cdev_device_add+0x15e/0x1b0
 __iio_device_register+0x13b4/0x1af0 [industrialio]
 __devm_iio_device_register+0x22/0x90 [industrialio]
 max517_probe+0x3d8/0x6b4 [max517]
 i2c_device_probe+0xa81/0xc00

When device_add() is injected fault and returns error, if dev->devt is not set,
cdev_add() is not called, cdev_del() is not needed. Fix this by checking dev->devt
in error path.

Fixes: 233ed09d7fda ("chardev: add helper function to register char devs with a struct device")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221202030237.520280-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/char_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 1bbb966c0783..9f79fd345e79 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -528,7 +528,7 @@ int cdev_device_add(struct cdev *cdev, struct device *dev)
 	}
 
 	rc = device_add(dev);
-	if (rc)
+	if (rc && dev->devt)
 		cdev_del(cdev);
 
 	return rc;
-- 
2.35.1



