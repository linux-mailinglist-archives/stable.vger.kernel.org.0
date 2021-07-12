Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738583C535B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352335AbhGLHyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350221AbhGLHuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C43F761208;
        Mon, 12 Jul 2021 07:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075843;
        bh=ea2noNCGIKPBDwwjDB9aRc1ui7ZuE3NI5eDzr4BZv2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRyEACeBYhPuDK1DlLxiVZvRD6TI2qMJlVIm4gZWf5JSOiDFnqdb8ygZR/bfCLxSN
         sy2LAl5d8lzWs4QPdd9gTCZBtJT5+smi9urpxxDE8CZc+NI61jMSuBA3PNfISgu121
         A7y85+u2+7RpayrcVPq9JEBh5shMTbrorhFcTWsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Robert Foss <robert.foss@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 389/800] drm/bridge/sii8620: fix dependency on extcon
Date:   Mon, 12 Jul 2021 08:06:52 +0200
Message-Id: <20210712061008.608695943@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit 08319adbdde15ef7cee1970336f63461254baa2a ]

The DRM_SIL_SII8620 kconfig has a weak `imply` dependency
on EXTCON, which causes issues when sii8620 is built
as a builtin and EXTCON is built as a module.

The symptoms are 'undefined reference' errors caused
by the symbols in EXTCON not being available
to the sii8620 driver.

Fixes: 688838442147 ("drm/bridge/sii8620: use micro-USB cable detection logic to detect MHL")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210419090124.153560-1-robert.foss@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 400193e38d29..eb3eebab4f27 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -172,7 +172,7 @@ config DRM_SIL_SII8620
 	tristate "Silicon Image SII8620 HDMI/MHL bridge"
 	depends on OF
 	select DRM_KMS_HELPER
-	imply EXTCON
+	select EXTCON
 	depends on RC_CORE || !RC_CORE
 	help
 	  Silicon Image SII8620 HDMI/MHL bridge chip driver.
-- 
2.30.2



