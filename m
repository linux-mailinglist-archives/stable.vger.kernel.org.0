Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7618A63DF72
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiK3SrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiK3SrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112F994939
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A222761D70
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0579C433C1;
        Wed, 30 Nov 2022 18:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834026;
        bh=kUZ1xzmiMXKnMC7AOHRdjj8QqGyxjl5AbJv/6JSd1XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afyFlFSvkXvlsd2nuLKc7TFGl7VasBGr3WDLraO2FsYjG+nK3D4MY4DjlqACR8ghE
         av0xEXGjugc1gsA7DIx1ypw0C05n69DnOeRex55ySJC+3FPBMWHWy5oXD3HybX5Nc1
         O8nLWukj2slnuh3in1PuTnt33XPvKCZkNbr2jN4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Kelley <mikelley@microsoft.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 101/289] Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()
Date:   Wed, 30 Nov 2022 19:21:26 +0100
Message-Id: <20221130180546.430527559@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit f92a4b50f0bd7fd52391dc4bb9a309085d278f91 ]

In the error path of vmbus_device_register(), device_unregister()
is called, which calls vmbus_device_release().  The latter frees
the struct hv_device that was passed in to vmbus_device_register().
So remove the kfree() in vmbus_add_channel_work() to avoid a double
free.

Fixes: c2e5df616e1a ("vmbus: add per-channel sysfs info")
Suggested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20221119081135.1564691-2-yangyingliang@huawei.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 5b120402d405..cc23b90cae02 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -533,13 +533,17 @@ static void vmbus_add_channel_work(struct work_struct *work)
 	 * Add the new device to the bus. This will kick off device-driver
 	 * binding which eventually invokes the device driver's AddDevice()
 	 * method.
+	 *
+	 * If vmbus_device_register() fails, the 'device_obj' is freed in
+	 * vmbus_device_release() as called by device_unregister() in the
+	 * error path of vmbus_device_register(). In the outside error
+	 * path, there's no need to free it.
 	 */
 	ret = vmbus_device_register(newchannel->device_obj);
 
 	if (ret != 0) {
 		pr_err("unable to add child device object (relid %d)\n",
 			newchannel->offermsg.child_relid);
-		kfree(newchannel->device_obj);
 		goto err_deq_chan;
 	}
 
-- 
2.35.1



