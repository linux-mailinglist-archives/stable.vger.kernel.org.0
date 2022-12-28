Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158FC65810F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiL1QYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiL1QX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:23:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E81BC9B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:20:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0450E61568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB6C433F1;
        Wed, 28 Dec 2022 16:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244446;
        bh=rBurc719qreKJtfryobjI1i8Mmm+/tDZv21DfTcX+nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgazDl95qlz0YqXXCz/o345QmSbFjLwKAsHX+Bxz0W29f44XHSqeKFNAGimJBZDU+
         3F/sliXsxViem0j49UNwYb73Ee3oqcb4El3kAU/F79R6SaZvWmjG6OFf3FtgMrEEtc
         yDpxdStJ4rv4DhgFwcg9Iamb7j7b0dQWATcb6cHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0711/1073] chardev: fix error handling in cdev_device_add()
Date:   Wed, 28 Dec 2022 15:38:19 +0100
Message-Id: <20221228144347.343131493@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index ba0ded7842a7..3f667292608c 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -547,7 +547,7 @@ int cdev_device_add(struct cdev *cdev, struct device *dev)
 	}
 
 	rc = device_add(dev);
-	if (rc)
+	if (rc && dev->devt)
 		cdev_del(cdev);
 
 	return rc;
-- 
2.35.1



