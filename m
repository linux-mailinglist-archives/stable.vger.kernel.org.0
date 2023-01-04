Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1BF65D985
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbjADQ0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbjADQZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73053F137
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:24:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 730C661798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F915C433F0;
        Wed,  4 Jan 2023 16:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849479;
        bh=5dC3nqAyJWDTjXZ9KBsC2wLZQkUsc5xPMLJIaUBAO0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaLbyVGyIvlJ5TQZOM03jHjH9lkVlMkOwDhjjNe9fX8XigY312fo9dVkqGr7JGNqn
         eP70hJSXw7LaAgUjXMAJOdf3tUxMyFK8A0iwimQd6qSP4Mwe8NajKnfc0ZrzmQ8ztb
         uRpx8UK7srIncu14rBVHa+CPUUwSU1bsENyLVtK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 6.0 129/177] drm/ingenic: Fix missing platform_driver_unregister() call in ingenic_drm_init()
Date:   Wed,  4 Jan 2023 17:07:00 +0100
Message-Id: <20230104160511.557026264@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

commit 47078311b8efebdefd5b3b2f87e2b02b14f49c66 upstream.

A problem about modprobe ingenic-drm failed is triggered with the following
log given:

 [  303.561088] Error: Driver 'ingenic-ipu' is already registered, aborting...
 modprobe: ERROR: could not insert 'ingenic_drm': Device or resource busy

The reason is that ingenic_drm_init() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
failed, it returns without unregistering ingenic_ipu_driver_ptr, resulting
the ingenic-drm can never be installed later.
A simple call graph is shown as below:

 ingenic_drm_init()
   platform_driver_register() # ingenic_ipu_driver_ptr are registered
   platform_driver_register()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without unregister ingenic_ipu_driver_ptr

Fixing this problem by checking the return value of
platform_driver_register() and do platform_unregister_drivers() if
error happened.

Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20221104064512.8569-1-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -1601,7 +1601,11 @@ static int ingenic_drm_init(void)
 			return err;
 	}
 
-	return platform_driver_register(&ingenic_drm_driver);
+	err = platform_driver_register(&ingenic_drm_driver);
+	if (IS_ENABLED(CONFIG_DRM_INGENIC_IPU) && err)
+		platform_driver_unregister(ingenic_ipu_driver_ptr);
+
+	return err;
 }
 module_init(ingenic_drm_init);
 


