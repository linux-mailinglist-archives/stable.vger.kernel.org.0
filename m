Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9217755DE7E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbiF0LjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236770AbiF0LiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:38:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CF1B873;
        Mon, 27 Jun 2022 04:34:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56B49B8111C;
        Mon, 27 Jun 2022 11:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7C4C341C8;
        Mon, 27 Jun 2022 11:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329690;
        bh=9H130nm95LWli/qDzmTMA2vuUyQOfhBdMgRg/w/JPHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6d1P78KhCa6JhVxl3t/scQLs+Yutj9BX43u9iGrEuOVg9P0/wTXXZQW7yZwiLgb1
         iMfB34GcgyTpNprsiHnX3KRbUCyXKqIz4DUOY3WNHm2JPM49VLNOh0dK5cbAntMH8e
         Kn3Cbc7n7KCRLsD/49iTj0QdSgJQM2k65HLqNINU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/135] drm/sun4i: Fix crash during suspend after component bind failure
Date:   Mon, 27 Jun 2022 13:20:49 +0200
Message-Id: <20220627111939.380201824@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 1342b5b23da9559a1578978eaff7f797d8a87d91 ]

If the component driver fails to bind, or is unbound, the driver data
for the top-level platform device points to a freed drm_device. If the
system is then suspended, the driver passes this dangling pointer to
drm_mode_config_helper_suspend(), which crashes.

Fix this by only setting the driver data while the platform driver holds
a reference to the drm_device.

Fixes: 624b4b48d9d8 ("drm: sun4i: Add support for suspending the display driver")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220615054254.16352-1-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 54dd562e294c..5b7061e2bca4 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -72,7 +72,6 @@ static int sun4i_drv_bind(struct device *dev)
 		goto free_drm;
 	}
 
-	dev_set_drvdata(dev, drm);
 	drm->dev_private = drv;
 	INIT_LIST_HEAD(&drv->frontend_list);
 	INIT_LIST_HEAD(&drv->engine_list);
@@ -113,6 +112,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 	drm_fbdev_generic_setup(drm, 32);
 
+	dev_set_drvdata(dev, drm);
+
 	return 0;
 
 finish_poll:
@@ -129,6 +130,7 @@ static void sun4i_drv_unbind(struct device *dev)
 {
 	struct drm_device *drm = dev_get_drvdata(dev);
 
+	dev_set_drvdata(dev, NULL);
 	drm_dev_unregister(drm);
 	drm_kms_helper_poll_fini(drm);
 	drm_atomic_helper_shutdown(drm);
-- 
2.35.1



