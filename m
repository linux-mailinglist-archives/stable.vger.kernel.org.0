Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7E24BE53F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347516AbiBUJJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:09:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347773AbiBUJIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:08:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248FE3205A;
        Mon, 21 Feb 2022 01:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D211EB80EB7;
        Mon, 21 Feb 2022 09:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBE3C340E9;
        Mon, 21 Feb 2022 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434018;
        bh=56qsthHrRBoFHqDWWpaeZQq+7/bpnQRvecrGixEmZW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Ok8n8v4OZcI5ZyC1uDdTN1sVtlCyEgSIF3Gzq14lZEkyufP0ZhsL8i87vhfzP5xI
         fHyZPIw+/HKTuBe0I5hn/GV47drtWYWf0fQnL+zbhujm7g+vxPrfCHwFyAyWuP6YmD
         a5M6R301q3qh25DdiWTMJlZ9WRDLBxEL4LSIEHaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Juan Vazquez <juvazq@linux.microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 65/80] Drivers: hv: vmbus: Fix memory leak in vmbus_add_channel_kobj
Date:   Mon, 21 Feb 2022 09:49:45 +0100
Message-Id: <20220221084917.715623302@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 8bc69f86328e87a0ffa79438430cc82f3aa6a194 ]

kobject_init_and_add() takes reference even when it fails.
According to the doc of kobject_init_and_add()：

   If this function returns an error, kobject_put() must be called to
   properly clean up the memory associated with the object.

Fix memory leak by calling kobject_put().

Fixes: c2e5df616e1a ("vmbus: add per-channel sysfs info")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Juan Vazquez <juvazq@linux.microsoft.com>
Link: https://lore.kernel.org/r/20220203173008.43480-1-linmq006@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 2d2568dac2a66..6b7ab8f234e87 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1787,8 +1787,10 @@ int vmbus_add_channel_kobj(struct hv_device *dev, struct vmbus_channel *channel)
 	kobj->kset = dev->channels_kset;
 	ret = kobject_init_and_add(kobj, &vmbus_chan_ktype, NULL,
 				   "%u", relid);
-	if (ret)
+	if (ret) {
+		kobject_put(kobj);
 		return ret;
+	}
 
 	ret = sysfs_create_group(kobj, &vmbus_chan_group);
 
@@ -1797,6 +1799,7 @@ int vmbus_add_channel_kobj(struct hv_device *dev, struct vmbus_channel *channel)
 		 * The calling functions' error handling paths will cleanup the
 		 * empty channel directory.
 		 */
+		kobject_put(kobj);
 		dev_err(device, "Unable to set up channel sysfs files\n");
 		return ret;
 	}
-- 
2.34.1



