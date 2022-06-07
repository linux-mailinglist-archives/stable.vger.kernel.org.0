Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E692541909
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376424AbiFGVSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380884AbiFGVRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC2114CA11;
        Tue,  7 Jun 2022 11:58:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EE08B82391;
        Tue,  7 Jun 2022 18:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7161C36AFF;
        Tue,  7 Jun 2022 18:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628278;
        bh=TXdYIlv8GMbuy2kPzeKAPO0DMYcaGZuJN0ZRyUD6OrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jp+DuAfGuwW/HhNQSD2l1V24hRiWqAQdEH0ecNroun20UofwnJDFweLPlJYz30CKb
         9x6mFErSOWXbzDYF/6NKCdZbOz+29QgZhaylR8QkXXLV2nprLLGu8NYeCcYxgNTCKG
         AjuA4tJEcmZ48ER2FAEaY2uO+ZlboKQZSe1abDls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 270/879] drm/bridge: it6505: Fix build error
Date:   Tue,  7 Jun 2022 18:56:28 +0200
Message-Id: <20220607165010.687320222@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 3dd4834a6efe4eb3c086526e1870bb768776d86a ]

If DRM_ITE_IT6505 is y but DRM_DP_HELPER is m, building failed:

drivers/gpu/drm/bridge/ite-it6505.o: In function `it6505_i2c_remove':
ite-it6505.c:(.text+0x35c): undefined reference to `drm_dp_aux_unregister'
drivers/gpu/drm/bridge/ite-it6505.o: In function `it6505_dpcd_read':
ite-it6505.c:(.text+0x420): undefined reference to `drm_dp_dpcd_read'
drivers/gpu/drm/bridge/ite-it6505.o: In function `it6505_get_dpcd':
ite-it6505.c:(.text+0x4a4): undefined reference to `drm_dp_dpcd_read'
drivers/gpu/drm/bridge/ite-it6505.o: In function `it6505_dpcd_write':
ite-it6505.c:(.text+0x52c): undefined reference to `drm_dp_dpcd_write'

Select DRM_DP_HELPER for DRM_ITE_IT6505 to fix this.

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220317094724.25972-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 2145b08f9534..becd9867f3a0 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -77,6 +77,7 @@ config DRM_DISPLAY_CONNECTOR
 config DRM_ITE_IT6505
         tristate "ITE IT6505 DisplayPort bridge"
         depends on OF
+	select DRM_DP_HELPER
         select DRM_KMS_HELPER
         select DRM_DP_HELPER
         select EXTCON
-- 
2.35.1



