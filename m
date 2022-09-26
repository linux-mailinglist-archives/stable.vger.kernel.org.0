Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7D85EA5CE
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbiIZMT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbiIZMTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:19:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC4890802;
        Mon, 26 Sep 2022 04:02:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08226B808BE;
        Mon, 26 Sep 2022 10:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38377C433D7;
        Mon, 26 Sep 2022 10:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189250;
        bh=9Its7ESIwbnKfkGFB0GStUYtp3szj+6k5k8Re0jSq90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCdGcChZAFSKYkdoTiJgg//yjaz6Se3JhG+TM+m4rPMukUbKBtQbq07VSuE5qRdcG
         dvcE3AWVBDCnEyPdu5TLHBEO75/wrNwcyEaDR7jqF89LF5K5m06EHRHsrpSFHjwDV1
         /4JET3cvXce6/p/MxCLKpE9tl4D/HshnyCYIICpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Tian Tao <tiantao6@hisilicon.com>,
        John Stultz <jstultz@google.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Chen Feng <puck.chen@hisilicon.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 123/207] drm/hisilicon: Add depends on MMU
Date:   Mon, 26 Sep 2022 12:11:52 +0200
Message-Id: <20220926100812.080079054@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d8a79c03054911c375a2252627a429c9bc4615b6 ]

The Kconfig symbol depended on MMU but was dropped by the commit
acad3fe650a5 ("drm/hisilicon: Removed the dependency on the mmu")
because it already had as a dependency ARM64 that already selects MMU.

But later, commit a0f25a6bb319 ("drm/hisilicon/hibmc: Allow to be built
if COMPILE_TEST is enabled") allowed the driver to be built for non-ARM64
when COMPILE_TEST is set but that could lead to unmet direct dependencies
and linking errors.

Prevent a kconfig warning when MMU is not enabled by making
DRM_HISI_HIBMC depend on MMU.

WARNING: unmet direct dependencies detected for DRM_TTM
  Depends on [n]: HAS_IOMEM [=y] && DRM [=m] && MMU [=n]
  Selected by [m]:
  - DRM_TTM_HELPER [=m] && HAS_IOMEM [=y] && DRM [=m]
  - DRM_HISI_HIBMC [=m] && HAS_IOMEM [=y] && DRM [=m] && PCI [=y] && (ARM64 || COMPILE_TEST [=y])

Fixes: acad3fe650a5 ("drm/hisilicon: Removed the dependency on the mmu")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Xinliang Liu <xinliang.liu@linaro.org>
Cc: Tian Tao  <tiantao6@hisilicon.com>
Cc: John Stultz <jstultz@google.com>
Cc: Xinwei Kong <kong.kongxinwei@hisilicon.com>
Cc: Chen Feng <puck.chen@hisilicon.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220531025557.29593-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/Kconfig b/drivers/gpu/drm/hisilicon/hibmc/Kconfig
index 073adfe438dd..4e41c144a290 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/Kconfig
+++ b/drivers/gpu/drm/hisilicon/hibmc/Kconfig
@@ -2,6 +2,7 @@
 config DRM_HISI_HIBMC
 	tristate "DRM Support for Hisilicon Hibmc"
 	depends on DRM && PCI && (ARM64 || COMPILE_TEST)
+	depends on MMU
 	select DRM_KMS_HELPER
 	select DRM_VRAM_HELPER
 	select DRM_TTM
-- 
2.35.1



