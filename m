Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9B59410F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346148AbiHOUwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346859AbiHOUvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:51:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE631BBA60;
        Mon, 15 Aug 2022 12:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C173B810A3;
        Mon, 15 Aug 2022 19:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DF0C433C1;
        Mon, 15 Aug 2022 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590592;
        bh=676krTAO+HL4576ThtRweo4aBukNbMS1ytPm871r0PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zm+oY3s93kxGGazV8TkSVcLDTUD/Uwdr7a6lXMzQ8VUTNKt+nQwqIrV2A9Veb0ACW
         qs47BajCU7PofWZRmnf44lWCmzQPJ99vCiNPcQWQFi3chREGQ/BzjrCufx/Q/ZHnnh
         UddswtWgdFlpJBpBjUQJxLtmHPAJ3pDmMGQlKDjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Gao Chao <gaochao49@huawei.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0309/1095] drm/panel: Fix build error when CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m
Date:   Mon, 15 Aug 2022 19:55:08 +0200
Message-Id: <20220815180442.585574345@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Chao <gaochao49@huawei.com>

[ Upstream commit a67664860f7833015a683ea295f7c79ac2901332 ]

If CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m,
bulding fails:

drivers/gpu/drm/panel/panel-samsung-atna33xc20.o: In function `atana33xc20_probe':
panel-samsung-atna33xc20.c:(.text+0x744): undefined reference to
 `drm_panel_dp_aux_backlight'
make: *** [vmlinux] Error 1

Let CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20 select DRM_DISPLAY_DP_HELPER and
CONFIG_DRM_DISPLAY_HELPER to fix this error.

Fixes: 32ce3b320343 ("drm/panel: atna33xc20: Introduce the Samsung ATNA33XC20 panel")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Gao Chao <gaochao49@huawei.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220524024551.539-1-gaochao49@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index ddf5f38e8731..abc5271af4eb 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -428,6 +428,8 @@ config DRM_PANEL_SAMSUNG_ATNA33XC20
 	depends on OF
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on PM
+	select DRM_DISPLAY_DP_HELPER
+	select DRM_DISPLAY_HELPER
 	select DRM_DP_AUX_BUS
 	help
 	  DRM panel driver for the Samsung ATNA33XC20 panel. This panel can't
-- 
2.35.1



