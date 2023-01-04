Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB2665D90D
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbjADQVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239722AbjADQUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BE0D50
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58547617AE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0E9C433EF;
        Wed,  4 Jan 2023 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849253;
        bh=LaNO8fLXHjsm2QKl1o2INaw5paN3LDCZzOGdoLXWHZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TesRZscweRa/rLMrY1oaOrqbwgTCixUmWb2aWoWwOVnNxqq7LJDs+O+vue8Q9TTKo
         p55a+hMamIlI6VKQWRbWRT9ZKFDfM56NgmusO6XDHXmoxy2sIVC0tBjE5vnJxhSMks
         QvWjIL0UnzTP/MNBjbRKL5uygZBpILRwaHbPKCU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 6.1 158/207] drm/ingenic: Fix missing platform_driver_unregister() call in ingenic_drm_init()
Date:   Wed,  4 Jan 2023 17:06:56 +0100
Message-Id: <20230104160516.896391379@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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
@@ -1629,7 +1629,11 @@ static int ingenic_drm_init(void)
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
 


