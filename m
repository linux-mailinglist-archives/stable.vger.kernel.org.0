Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2194266C7C6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbjAPQeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbjAPQeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:34:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D133B0E4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:21:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFD18B81063
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3491AC433D2;
        Mon, 16 Jan 2023 16:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886109;
        bh=DBTSrcDF8xCvGxx7BqDaaKgFE+xSqOknRva8vhRYR18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlwF9xi6HlXQbXTf/DCvv5dXabmd5j4oa3fBJ0H+fBVrNxwy/7zbv1U6x3yd+BEPD
         0I3iRt6ykIhUyFN8DEedZCLCKi8yqeQpwJkgLN1W4YcprRM1YGZEVjDxWpLcohrvv5
         uPXB60d/SxH9sQkLyAnjNusCRxVWMC8krVlx8fGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 305/658] chardev: fix error handling in cdev_device_add()
Date:   Mon, 16 Jan 2023 16:46:33 +0100
Message-Id: <20230116154923.537588963@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index c5e6eff5a381..36479b72d278 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -544,7 +544,7 @@ int cdev_device_add(struct cdev *cdev, struct device *dev)
 	}
 
 	rc = device_add(dev);
-	if (rc)
+	if (rc && dev->devt)
 		cdev_del(cdev);
 
 	return rc;
-- 
2.35.1



