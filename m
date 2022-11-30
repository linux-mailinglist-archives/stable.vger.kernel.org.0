Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06BD63DF73
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiK3SrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiK3SrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5524999F23
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EB62B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519DCC433C1;
        Wed, 30 Nov 2022 18:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834028;
        bh=58rhLA38/wHS6um87sVoJxvO6c4cciQP3Dl2E2Tw0n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yV9Y231fGNz+vNlzVAcDGWpbneel9C/PS4ncdt/m2LrZL4W83FCyo4bOrJ5T7UZbP
         tUKcdSoKD5CBYhi1vf0SMoo1ZgcuVBJJ58iZSlUTApEmjVXA7TY34LTf/jqF78LQQC
         BOG1syBIpf+r5lMz67Y8bqAmPbA2xUV44qih489I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 102/289] Drivers: hv: vmbus: fix possible memory leak in vmbus_device_register()
Date:   Wed, 30 Nov 2022 19:21:27 +0100
Message-Id: <20221130180546.452776464@linuxfoundation.org>
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

[ Upstream commit 25c94b051592c010abe92c85b0485f1faedc83f3 ]

If device_register() returns error in vmbus_device_register(),
the name allocated by dev_set_name() must be freed. As comment
of device_register() says, it should use put_device() to give
up the reference in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanup().

Fixes: 09d50ff8a233 ("Staging: hv: make the Hyper-V virtual bus code build")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20221119081135.1564691-3-yangyingliang@huawei.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 3c833ea60db6..939ccf921e71 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2083,6 +2083,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	ret = device_register(&child_device_obj->device);
 	if (ret) {
 		pr_err("Unable to register child device\n");
+		put_device(&child_device_obj->device);
 		return ret;
 	}
 
-- 
2.35.1



