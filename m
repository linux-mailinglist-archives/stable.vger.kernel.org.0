Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905293C4E0C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243084AbhGLHQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243517AbhGLHPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A22876143A;
        Mon, 12 Jul 2021 07:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073948;
        bh=P5gMv8qj0JDbjGY/7Cjvl9fM5F0K85Pxyv3XwwRD7qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lQi7rT6Qi8mh1Jo+c9OhWFgcwBsoffIHKDVMXxsDzp6R+X0G59djudZlQnOe8vHe
         PPlfX6A/zXaFFdQXaHWkFTWahexa0hlPXlwhLD5NKCK57wCqee+jbsRVEetIX4TOq0
         AGkNAhgRD/yKXCN/TI9T05LYwVqumAcK5s7RedUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 396/700] drm/pl111: Actually fix CONFIG_VEXPRESS_CONFIG depends
Date:   Mon, 12 Jul 2021 08:07:59 +0200
Message-Id: <20210712061018.524520177@linuxfoundation.org>
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

[ Upstream commit 4e566003571244f508408f59ce78f6ac2ccdba8e ]

VEXPRESS_CONFIG needs to either be missing, built-in, or modular when
pl111 is modular. Update the Kconfig to reflect the need.

Fixes: 4dc7c97d04dc ("drm/pl111: depend on CONFIG_VEXPRESS_CONFIG")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210604014055.4060521-1-keescook@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/pl111/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/pl111/Kconfig b/drivers/gpu/drm/pl111/Kconfig
index c5210a5bef1b..3aae387a96af 100644
--- a/drivers/gpu/drm/pl111/Kconfig
+++ b/drivers/gpu/drm/pl111/Kconfig
@@ -2,7 +2,8 @@
 config DRM_PL111
 	tristate "DRM Support for PL111 CLCD Controller"
 	depends on DRM
-	depends on VEXPRESS_CONFIG
+	depends on ARM || ARM64 || COMPILE_TEST
+	depends on VEXPRESS_CONFIG || VEXPRESS_CONFIG=n
 	depends on COMMON_CLK
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
-- 
2.30.2



