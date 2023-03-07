Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9CA6AEBC1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjCGRsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjCGRsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:48:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D87E8535A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:43:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2718CB819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ADDC4339B;
        Tue,  7 Mar 2023 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210968;
        bh=qhTknCAnJNvmCZog7ZAPZ8B8dQc8fSqFotbjLED+EHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLySAENWufMK8GzTC82uwUyzYwk0aT+TLtEl7y/N9xWNdCupPRNssqzx71kxnl02i
         35qYHUPnGZktdTyWkZjACdU0uMjbpJVsm+AZ7fZV+OD/BlwJdvBd4iZBP8JPsfwVjl
         wteNT9n1SZNBbMfrAMyFuCU6MWJjIrc3yStjgzhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0712/1001] drm/client: Test for connectors before sending hotplug event
Date:   Tue,  7 Mar 2023 17:58:04 +0100
Message-Id: <20230307170052.531550478@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit c2bb3be64eb7182285846123219230375af61abd ]

Test for connectors in the client code and remove a similar test
from the generic fbdev emulation. Do nothing if the test fails.
Not having connectors indicates a driver bug.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230125200415.14123-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client.c        | 5 +++++
 drivers/gpu/drm/drm_fbdev_generic.c | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 056ab9d5f313b..313cbabb12b2d 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -198,6 +198,11 @@ void drm_client_dev_hotplug(struct drm_device *dev)
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return;
 
+	if (!dev->mode_config.num_connector) {
+		drm_dbg_kms(dev, "No connectors found, will not send hotplug events!\n");
+		return;
+	}
+
 	mutex_lock(&dev->clientlist_mutex);
 	list_for_each_entry(client, &dev->clientlist, list) {
 		if (!client->funcs || !client->funcs->hotplug)
diff --git a/drivers/gpu/drm/drm_fbdev_generic.c b/drivers/gpu/drm/drm_fbdev_generic.c
index 593aa3283792b..215fe16ff1fb4 100644
--- a/drivers/gpu/drm/drm_fbdev_generic.c
+++ b/drivers/gpu/drm/drm_fbdev_generic.c
@@ -390,11 +390,6 @@ static int drm_fbdev_client_hotplug(struct drm_client_dev *client)
 	if (dev->fb_helper)
 		return drm_fb_helper_hotplug_event(dev->fb_helper);
 
-	if (!dev->mode_config.num_connector) {
-		drm_dbg_kms(dev, "No connectors found, will not create framebuffer!\n");
-		return 0;
-	}
-
 	drm_fb_helper_prepare(dev, fb_helper, &drm_fb_helper_generic_funcs);
 
 	ret = drm_fb_helper_init(dev, fb_helper);
-- 
2.39.2



