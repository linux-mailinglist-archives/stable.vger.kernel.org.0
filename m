Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1390D63DE73
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiK3ShH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiK3ShC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:37:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3513E92084
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:37:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86FE6B81CA6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9E0C433D6;
        Wed, 30 Nov 2022 18:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833418;
        bh=mBY1Ke33W1o9geHURcpeG9qWIjmRSU4+I9leHcvGHeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PR94rVLkbs7/RmUvQkWE5btZQ7y3LcGXEZQDYA/+YPl1OfoxXWatQyR+9Js6ue9TE
         wnTz4vJdX6Po3sBbPa3Z9RvobxggMiI+MhdsX0IkKIIy/i527DqkA0pKZqproF4P7O
         NP0xJcGdfadt4/J1KvGowu93bRnJOw51oU+3u1YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Kelley <mikelley@microsoft.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/206] Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()
Date:   Wed, 30 Nov 2022 19:22:30 +0100
Message-Id: <20221130180535.532408421@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
index 07003019263a..d8dc5cc5e3a8 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -531,13 +531,17 @@ static void vmbus_add_channel_work(struct work_struct *work)
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



