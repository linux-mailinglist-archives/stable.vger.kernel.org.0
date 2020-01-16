Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B332313F841
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733241AbgAPTRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732955AbgAPQz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99BD420730;
        Thu, 16 Jan 2020 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193729;
        bh=aX7ifRBNjLV4P2WSjgKpSySenyZPKe/92qia74ikSpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=REESr598VvRipbs6BUyv2+jkx4T+ZuYc7TQap51G9srO4pj5GzjEVjLDxdjk5iXFM
         cpqAtuOFaTzrUoO7Np85+BvyoqOlbeKJRajm7Cw47EGAxuFXTcZ4S+0mbySHC12hTI
         xbipoPb+Ne3cRV0zezS+kVAC2e6sCV83eww7JvVA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 022/671] usb: dwc3: add EXTCON dependency for qcom
Date:   Thu, 16 Jan 2020 11:44:13 -0500
Message-Id: <20200116165502.8838-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3def4031b3e3fbb524cbd01555b057a6cef0d5e6 ]

Like the omap back-end, we get a link error with CONFIG_EXTCON=m
when building the qcom back-end into the kernel:

drivers/usb/dwc3/dwc3-qcom.o: In function `dwc3_qcom_probe':
dwc3-qcom.c:(.text+0x13dc): undefined reference to `extcon_get_edev_by_phandle'
dwc3-qcom.c:(.text+0x1b18): undefined reference to `devm_extcon_register_notifier'
dwc3-qcom.c:(.text+0x1b9c): undefined reference to `extcon_get_state'

Do the same thing as OMAP and add an explicit dependency on
EXTCON.

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 518ead12458d..1a0404fda596 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -113,7 +113,7 @@ config USB_DWC3_ST
 
 config USB_DWC3_QCOM
 	tristate "Qualcomm Platform"
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on EXTCON && (ARCH_QCOM || COMPILE_TEST)
 	depends on OF
 	default USB_DWC3
 	help
-- 
2.20.1

