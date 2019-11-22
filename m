Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCC8106BD6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbfKVKrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbfKVKrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:47:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2A2420718;
        Fri, 22 Nov 2019 10:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419662;
        bh=xI+skwa8kTa6/wPWYDcvAJcHAf1EsrACC8CuciHJb3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1NNes2xQhuqW1QT9n1gIuShYbJ1un5wu1p94odocme8NGPxtvrO+kMDfTNTzOeV7
         /LhHaYcTea0FZr9AyIyqTEvzSxo8ctFD8UXs348b5wUEbjD3WA7najCw+RbI9DNyKG
         FdPvDsGsyllPH9ySCSAyun92y7ePcBkQdH1KKmY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 189/222] i2c: brcmstb: Allow enabling the driver on DSL SoCs
Date:   Fri, 22 Nov 2019 11:28:49 +0100
Message-Id: <20191122100915.943549862@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit e1eba2ea54a2de0e4c58d87270d25706bb77b844 ]

ARCH_BCM_63XX which is used by ARM-based DSL SoCs from Broadcom uses the
same controller, make it possible to select the STB driver and update
the Kconfig and help text a bit.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index d252276feadf6..759c621a860a9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -397,12 +397,13 @@ config I2C_BCM_KONA
 	  If you do not need KONA I2C interface, say N.
 
 config I2C_BRCMSTB
-	tristate "BRCM Settop I2C controller"
-	depends on ARCH_BRCMSTB || BMIPS_GENERIC || COMPILE_TEST
+	tristate "BRCM Settop/DSL I2C controller"
+	depends on ARCH_BRCMSTB || BMIPS_GENERIC || ARCH_BCM_63XX || \
+		   COMPILE_TEST
 	default y
 	help
 	  If you say yes to this option, support will be included for the
-	  I2C interface on the Broadcom Settop SoCs.
+	  I2C interface on the Broadcom Settop/DSL SoCs.
 
 	  If you do not need I2C interface, say N.
 
-- 
2.20.1



