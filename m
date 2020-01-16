Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D854A13E587
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389707AbgAPROk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:14:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391055AbgAPROj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:14:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0C9246A7;
        Thu, 16 Jan 2020 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194879;
        bh=U/NqnCQwVQ2UCt5lWGUmMYs4JvLuZDr4nhfNOLOb7kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHKMWfTkMU9QrS+PAuRp/ZcmxWryEppv/yE3Kp0HLmP2xtRDDUJy3pBNsFcOssH+o
         mNTIPemZzEAum5RUQzLvMKIInJ7zOxjsIwRUS/8h6ml1XbeGAArJGHc1JUzjm0w0RE
         VbiR5HfPBOXoc9ZDar0I2JoxHqQ9K4Z2H3BygQME=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 668/671] usb: dwc3: Allow building USB_DWC3_QCOM without EXTCON
Date:   Thu, 16 Jan 2020 12:05:06 -0500
Message-Id: <20200116170509.12787-405-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1a0404fda596..5d22f4bf2a9f 100644
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

