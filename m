Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F58643206
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiLETXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiLETXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:23:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1382A72B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7465FB81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EDBC433C1;
        Mon,  5 Dec 2022 19:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267916;
        bh=bvgGhQ9UHbQdlEQI7SmjYl5agkQUFDcTyEUeoJupavg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bimqquLRa3AFNEUwVm1MZwlUsB8mrrlIYTDt9E3OxHgaZ13TxVPCMhZg0rD6KFImw
         zWNFApOxjpY1df5WZBUQVeb0GIOXcz7hefaexz3rD9BATFNjZlvfVDlexQn1rEccbw
         wlwnjCfqD5vCSdRGmb3M6lzRX3wX9ZIywBjxooKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Kelley <mikelley@microsoft.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/105] Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()
Date:   Mon,  5 Dec 2022 20:08:52 +0100
Message-Id: <20221205190803.835645079@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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
index a3f6933f94e3..ccfa5ceb43c0 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -508,13 +508,17 @@ static void vmbus_add_channel_work(struct work_struct *work)
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



