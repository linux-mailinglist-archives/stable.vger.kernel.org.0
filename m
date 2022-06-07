Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CDF541979
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378634AbiFGVWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380800AbiFGVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99FDA1A9;
        Tue,  7 Jun 2022 11:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8921CB822C0;
        Tue,  7 Jun 2022 18:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7182C385A2;
        Tue,  7 Jun 2022 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628251;
        bh=VMBQ25Si+CvDpexTdClyp2NZuPRPUCh8Jw3Nk8iusDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFiOnok2CweQF9lTocIG30TWCb9eSbtBktWPlJmONYTo9GIiUi3s1bITz6h91sQ1/
         nfctQOyuJdXpuirZaOBIXMV/YKvhI3AtYCeNNkHt6TptSX4w2j2lrN+ymuUX2HkAfE
         42Ny4Y1E4vTgUAgxHOc2PFwTS0n/c4Ba3NSXKfHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 261/879] drm/solomon: Make DRM_SSD130X depends on MMU
Date:   Tue,  7 Jun 2022 18:56:19 +0200
Message-Id: <20220607165010.426578702@linuxfoundation.org>
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

[ Upstream commit 47042e0ddd218f100292cebc5208cb1eff7473b6 ]

WARNING: unmet direct dependencies detected for DRM_GEM_SHMEM_HELPER
  Depends on [n]: HAS_IOMEM [=y] && DRM [=m] && MMU [=n]
  Selected by [m]:
  - DRM_SSD130X [=m] && HAS_IOMEM [=y] && DRM [=m]

DRM_GEM_SHMEM_HELPER depends on MMU, DRM_SSD130X should also depends on MMU.

Fixes: a61732e80867 ("drm: Add driver for Solomon SSD130x OLED displays")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220312063437.19160-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/solomon/Kconfig b/drivers/gpu/drm/solomon/Kconfig
index 5861c3ab7c45..6230369505c9 100644
--- a/drivers/gpu/drm/solomon/Kconfig
+++ b/drivers/gpu/drm/solomon/Kconfig
@@ -1,6 +1,6 @@
 config DRM_SSD130X
 	tristate "DRM support for Solomon SSD130x OLED displays"
-	depends on DRM
+	depends on DRM && MMU
 	select BACKLIGHT_CLASS_DEVICE
 	select DRM_GEM_SHMEM_HELPER
 	select DRM_KMS_HELPER
-- 
2.35.1



