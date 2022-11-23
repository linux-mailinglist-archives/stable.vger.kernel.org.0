Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CF9635442
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiKWJFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbiKWJEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:04:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77D4102E6F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:04:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66E80B81ECB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1654C433C1;
        Wed, 23 Nov 2022 09:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194263;
        bh=C0WMr25BMRqL1AV//WwwfcxI5BwlUs3bPLepC5iG5vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7MFJskYtuXkT/z3xEKk8yrBZzV7U4yN/A/5YiSFnCEPlYhCFXFHXY2+1GUff2jDi
         jSQxxmRvTTUC1EtfHYo8ejh00T+eQBzTFcLsmqg/WkfoKhJzAqRieEDdgjwY03tMds
         PSIKO8Tp37RV9I6dYbUhnNeEzFDJOMIr2byTEl90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/114] drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_register()
Date:   Wed, 23 Nov 2022 09:49:58 +0100
Message-Id: <20221123084552.286332663@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

[ Upstream commit cf53db768a8790fdaae2fa3a81322b080285f7e5 ]

A problem about modprobe vc4 failed is triggered with the following log
given:

 [  420.327987] Error: Driver 'vc4_hvs' is already registered, aborting...
 [  420.333904] failed to register platform driver vc4_hvs_driver [vc4]: -16
 modprobe: ERROR: could not insert 'vc4': Device or resource busy

The reason is that vc4_drm_register() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
fails, it returns without unregistering all the vc4 drivers, resulting the
vc4 can never be installed later.
A simple call graph is shown as below:

 vc4_drm_register()
   platform_register_drivers() # all vc4 drivers are registered
   platform_driver_register()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without unregister drivers

Fixing this problem by checking the return value of
platform_driver_register() and do platform_unregister_drivers() if
error happened.

Fixes: c8b75bca92cb ("drm/vc4: Add KMS support for Raspberry Pi.")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20221103014705.109322-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 868dd1ef3b69..f210560a4831 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -394,7 +394,12 @@ static int __init vc4_drm_register(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&vc4_platform_driver);
+	ret = platform_driver_register(&vc4_platform_driver);
+	if (ret)
+		platform_unregister_drivers(component_drivers,
+					    ARRAY_SIZE(component_drivers));
+
+	return ret;
 }
 
 static void __exit vc4_drm_unregister(void)
-- 
2.35.1



