Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E6866C844
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjAPQhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbjAPQgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCD232E4E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:25:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C45161058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3D9C433D2;
        Mon, 16 Jan 2023 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886353;
        bh=pD2z6FAPXJAf/77WjOxmvfrAFPzRtp5z1bM7n+jRkFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1u2CCsTuBkdK5GHyFQeL8ZKRqxBVehHbAiGSIgqF6ETaULEgesSzBw4as6Q/uc6F
         uowwB7t2f8SBDngW68ho8jTfu2U5rvW1v8rUoeM6YuHFBz0faHSaGXB9g+KJ4AJhT8
         pMiAMhzWtV08fn3Sn+1Dy2hH5tlZk+MBsG2RSGV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 381/658] mailbox: zynq-ipi: fix error handling while device_register() fails
Date:   Mon, 16 Jan 2023 16:47:49 +0100
Message-Id: <20230116154926.967800096@linuxfoundation.org>
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

[ Upstream commit a6792a0cdef0b1c2d77920246283a72537e60e94 ]

If device_register() fails, it has two issues:
1. The name allocated by dev_set_name() is leaked.
2. The parent of device is not NULL, device_unregister() is called
   in zynqmp_ipi_free_mboxes(), it will lead a kernel crash because
   of removing not added device.

Call put_device() to give up the reference, so the name is freed in
kobject_cleanup(). Add device registered check in zynqmp_ipi_free_mboxes()
to avoid null-ptr-deref.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index f9cc674ba9b7..1d0b8abbafc3 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -493,6 +493,7 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 	ret = device_register(&ipi_mbox->dev);
 	if (ret) {
 		dev_err(dev, "Failed to register ipi mbox dev.\n");
+		put_device(&ipi_mbox->dev);
 		return ret;
 	}
 	mdev = &ipi_mbox->dev;
@@ -619,7 +620,8 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (ipi_mbox->dev.parent) {
 			mbox_controller_unregister(&ipi_mbox->mbox);
-			device_unregister(&ipi_mbox->dev);
+			if (device_is_registered(&ipi_mbox->dev))
+				device_unregister(&ipi_mbox->dev);
 		}
 	}
 }
-- 
2.35.1



