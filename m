Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EA2627F09
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbiKNMyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237517AbiKNMys (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:54:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7665C275E0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:54:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C03A6CE100E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38863C433C1;
        Mon, 14 Nov 2022 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430482;
        bh=j5SWi3C63/x5suXUXaQxuvuSDL0+fD6HTDRGkGGmP5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dL0LcOjIMZSBQOhobx3aXxKg43r21dWLpD9SR+RWqwU33zxAqD6QAbbLqT4wjWJc+
         AS8PE+l2p67dLd7umZNE/C24VvOuSLjHgxI6ThrtDFZYommxeRQHaPZXFdbM6kdr35
         ntw2Znn++oPCHVoZCvb8X2ee416Bhkf1E9stJ2tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/131] drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_register()
Date:   Mon, 14 Nov 2022 13:45:10 +0100
Message-Id: <20221114124450.452824588@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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
index d216a1fd057c..099df15e1a61 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -383,7 +383,12 @@ static int __init vc4_drm_register(void)
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



