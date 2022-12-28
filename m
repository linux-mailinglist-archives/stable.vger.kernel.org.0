Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BD9657DA8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiL1Ppc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbiL1Ppb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC24D17883
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 724B6B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3053C43392;
        Wed, 28 Dec 2022 15:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242328;
        bh=lxG/BseRpMSvx4WZ3vOTYKABrcCbTH0xZN/XOm6jfsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDxRjjXf/bk3REBgJhzssMID/if1CTbDT6Vl9md/n54DZFtxgiL4DlZkcDpeyR3Vt
         po9SlZwYbxl5fQceZJQ98ovEe1SFVT/Zc94H+IEbkfHLycbHwbHZlFpPvFY/bJwFZE
         X16oioJW9+8kcbllt9zKelgxTpIAZOAEJO3qb9gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        ming_qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0357/1146] media: amphion: Fix error handling in vpu_driver_init()
Date:   Wed, 28 Dec 2022 15:31:36 +0100
Message-Id: <20221228144339.858486431@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit a95cc6d11aae16a7b2d043b073a40de81bbea689 ]

A problem about modprobe amphion-vpu failed is triggered with the
following log given:

 [ 2208.634841] Error: Driver 'amphion-vpu' is already registered, aborting...
 modprobe: ERROR: could not insert 'amphion_vpu': Device or resource busy

The reason is that vpu_driver_init() returns vpu_core_driver_init()
directly without checking its return value, if vpu_core_driver_init()
failed, it returns without unregister amphion_vpu_driver, resulting the
amphion-vpu can never be installed later.
A simple call graph is shown as below:

 vpu_driver_init()
   platform_driver_register() # register amphion_vpu_driver
   vpu_core_driver_init()
     platform_driver_register()
       driver_register()
         bus_add_driver()
           dev = kzalloc(...) # OOM happened
   # return without unregister amphion_vpu_driver

Fix by unregister amphion_vpu_driver when vpu_core_driver_init() returns
error.

Fixes: b50a64fc54af ("media: amphion: add amphion vpu device driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: ming_qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_drv.c b/drivers/media/platform/amphion/vpu_drv.c
index 9d5a5075343d..f01ce49d27e8 100644
--- a/drivers/media/platform/amphion/vpu_drv.c
+++ b/drivers/media/platform/amphion/vpu_drv.c
@@ -245,7 +245,11 @@ static int __init vpu_driver_init(void)
 	if (ret)
 		return ret;
 
-	return vpu_core_driver_init();
+	ret = vpu_core_driver_init();
+	if (ret)
+		platform_driver_unregister(&amphion_vpu_driver);
+
+	return ret;
 }
 
 static void __exit vpu_driver_exit(void)
-- 
2.35.1



