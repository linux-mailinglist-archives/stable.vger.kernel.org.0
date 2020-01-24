Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA6414838D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404986AbgAXLhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404952AbgAXLhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:37:03 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65F32206D4;
        Fri, 24 Jan 2020 11:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865823;
        bh=ZdFTGzF3mGe7oTqK3JNkAN6DI5AdfAnbxXnNGwqioXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFxFJiAqyoEu9YUkGfy+4yrqAd2pQaewcImnc2Y3d89CzSSecBHhGQpN8a2m1BPBN
         OnmcK9FnaAreKdI6wdIuZ5vqsmITCQXfIKqKJFsaLkRla+mzLQwIe/1TfJ+/So2IBv
         YTT/bMSNY/lmEad33Jf8Bi6aNmabDtoyVxc4snMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 635/639] usb: dwc3: Allow building USB_DWC3_QCOM without EXTCON
Date:   Fri, 24 Jan 2020 10:33:25 +0100
Message-Id: <20200124093209.150916936@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Gonzalez <marc.w.gonzalez@free.fr>

[ Upstream commit 77a4946516fe488b6a33390de6d749f934a243ba ]

Keep EXTCON support optional, as some platforms do not need it.

Do the same for USB_DWC3_OMAP while we're at it.

Fixes: 3def4031b3e3f ("usb: dwc3: add EXTCON dependency for qcom")
Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 1a0404fda596b..5d22f4bf2a9fa 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -52,7 +52,8 @@ comment "Platform Glue Driver Support"
 
 config USB_DWC3_OMAP
 	tristate "Texas Instruments OMAP5 and similar Platforms"
-	depends on EXTCON && (ARCH_OMAP2PLUS || COMPILE_TEST)
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
+	depends on EXTCON || !EXTCON
 	depends on OF
 	default USB_DWC3
 	help
@@ -113,7 +114,8 @@ config USB_DWC3_ST
 
 config USB_DWC3_QCOM
 	tristate "Qualcomm Platform"
-	depends on EXTCON && (ARCH_QCOM || COMPILE_TEST)
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on EXTCON || !EXTCON
 	depends on OF
 	default USB_DWC3
 	help
-- 
2.20.1



