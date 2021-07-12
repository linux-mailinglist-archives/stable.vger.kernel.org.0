Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A268B3C4E4C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244628AbhGLHRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243732AbhGLHRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03FA06140C;
        Mon, 12 Jul 2021 07:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074048;
        bh=q+26ziyUGgj2kiHF3QL/5cJOVVtKYvVckwkSe3TtHQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAVzqC1CyI43OsdSaPN4ZwUkqDsbMUUMlN8tpzGGy5VOLUxqX2aB10Gf+C0RyH1Sv
         SSFfNLoD7C4xSQlPa0/eJi/Kt5oXVKP6hhqFSIAjdU3QHe4iAjtRpGgDhclf1qI9ZY
         kWtvk8zi3530Y+p62zZmn6tMFfkYbQXa4dk72y68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 394/700] drm/pl111: depend on CONFIG_VEXPRESS_CONFIG
Date:   Mon, 12 Jul 2021 08:07:57 +0200
Message-Id: <20210712061018.308455666@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 4dc7c97d04dcaa9f19482f70dcfdbeb52cc7193f ]

Avoid randconfig build failures by requiring VEXPRESS_CONFIG:

aarch64-linux-gnu-ld: drivers/gpu/drm/pl111/pl111_versatile.o: in function `pl111_vexpress_clcd_init':
pl111_versatile.c:(.text+0x220): undefined reference to `devm_regmap_init_vexpress_config'

Fixes: 826fc86b5903 ("drm: pl111: Move VExpress setup into versatile init")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210602215252.695994-4-keescook@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/pl111/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/pl111/Kconfig b/drivers/gpu/drm/pl111/Kconfig
index 80f6748055e3..c5210a5bef1b 100644
--- a/drivers/gpu/drm/pl111/Kconfig
+++ b/drivers/gpu/drm/pl111/Kconfig
@@ -2,7 +2,7 @@
 config DRM_PL111
 	tristate "DRM Support for PL111 CLCD Controller"
 	depends on DRM
-	depends on ARM || ARM64 || COMPILE_TEST
+	depends on VEXPRESS_CONFIG
 	depends on COMMON_CLK
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
-- 
2.30.2



