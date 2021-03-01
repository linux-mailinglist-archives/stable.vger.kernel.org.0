Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A0328D48
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241113AbhCATIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240829AbhCATEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 076FB64F19;
        Mon,  1 Mar 2021 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620938;
        bh=+IA0ZHPuzJBaqRZ9zOCHZV/2j0Z4VkXmvnvo/PPdHEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOm+zfKeAF5M634WoBb6gO4RNygFBTIzxVZKCwO6UuKNzmnZ+uCOi3j3GO7SKjCCV
         0ADrHkqlHwZk7BZJg9BI1Ft4+s3CkNUW3P5mNN/Ju/QAWQp+khR2yNM4G+o4R//UMq
         rlV0R8RNuBSC3lCdaVkbkIeEX5yvumZWJIRj50fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 304/775] Input: imx_keypad - add dependency on HAS_IOMEM
Date:   Mon,  1 Mar 2021 17:07:52 +0100
Message-Id: <20210301161216.641677153@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit f5cace4b93d736cef348211ae0814cabdd26d86a ]

devm_platform_ioremap_resource() depends on CONFIG_HAS_IOMEM, so let's add
it to the dependencies when COMPILE_TEST is enabled.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c8834032ffe2 ("Input: imx_keypad - add COMPILE_TEST support")
Link: https://lore.kernel.org/r/X9llpA3w1zlZCHXU@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 2b321c17054ad..94eab82086b27 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -446,7 +446,7 @@ config KEYBOARD_MPR121
 
 config KEYBOARD_SNVS_PWRKEY
 	tristate "IMX SNVS Power Key Driver"
-	depends on ARCH_MXC || COMPILE_TEST
+	depends on ARCH_MXC || (COMPILE_TEST && HAS_IOMEM)
 	depends on OF
 	help
 	  This is the snvs powerkey driver for the Freescale i.MX application
-- 
2.27.0



