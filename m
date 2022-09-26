Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A8F5EA270
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbiIZLHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbiIZLGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:06:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9D950047;
        Mon, 26 Sep 2022 03:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83708609FB;
        Mon, 26 Sep 2022 10:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84748C433D7;
        Mon, 26 Sep 2022 10:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188350;
        bh=AVRsrIsgiC9iOeuJ9kYUi3jx3bvONckuSF+If+EI2rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+aOkYGe3WKaM1a3S+3lGwDobCsX9mGLWElfOAjKFqVZMbECTCzvNbP18oqZkHNe6
         c292DMFTHYdPnqg7xBE6fj+Vt6KEnjSdDJXQEPFkn/paLRF5hX9YX7S+hrWEZFqSJi
         yEBvrsJLYX44Nzvp3LN/5t/H9ok3DtMRujB2lvrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/141] drm/hisilicon/hibmc: Allow to be built if COMPILE_TEST is enabled
Date:   Mon, 26 Sep 2022 12:11:56 +0200
Message-Id: <20220926100757.691723943@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit a0f25a6bb319aa05e04dcf51707c97c2881b4f47 ]

The commit feeb07d0ca5a ("drm/hisilicon/hibmc: Make CONFIG_DRM_HISI_HIBMC
depend on ARM64") made the driver Kconfig symbol to depend on ARM64 since
it only supports that architecture and loading the module on others would
lead to incorrect video modes being used.

But it also prevented the driver to be built on other architectures which
is useful to have compile test coverage when doing subsystem wide changes.

Make the dependency instead to be (ARM64 || COMPILE_TEST), so the driver
is buildable when the CONFIG_COMPILE_TEST option is enabled.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20211216210936.3329977-1-javierm@redhat.com
Stable-dep-of: d8a79c030549 ("drm/hisilicon: Add depends on MMU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/Kconfig b/drivers/gpu/drm/hisilicon/hibmc/Kconfig
index 43943e980203..073adfe438dd 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/Kconfig
+++ b/drivers/gpu/drm/hisilicon/hibmc/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config DRM_HISI_HIBMC
 	tristate "DRM Support for Hisilicon Hibmc"
-	depends on DRM && PCI && ARM64
+	depends on DRM && PCI && (ARM64 || COMPILE_TEST)
 	select DRM_KMS_HELPER
 	select DRM_VRAM_HELPER
 	select DRM_TTM
-- 
2.35.1



