Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A577066D0D
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfGLMZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbfGLMZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12D2721019;
        Fri, 12 Jul 2019 12:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934358;
        bh=FqlQ/3Gp5hzqFhNccH8EbWf2qw4CxCzFQjP9Q6lPcgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOSn/WHWCHtN9FYjrIffMYlXfrd6VunT+Kds7gRAuVNCmeMwVbT/RUHTRd+kpdSJ7
         8yn6R/UDNsHelpZlHiJTgwM2r6Upr95FAzD/ey8kGdckv0Y/Spf/gufX8Oyto6mnJK
         mFMrXMUhPM3PUdHnwdJVf8YOHd8uzJVoKuJ5n8gM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 006/138] ARM: dts: dra71x: Disable rtc target module
Date:   Fri, 12 Jul 2019 14:17:50 +0200
Message-Id: <20190712121628.967654105@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fe9edfe648ac444150ec95da1fb10e2728cc9789 ]

Introduce dra71x.dtsi to include dra71x specific changes.
rtc is fused out on dra71 and accessing target module
register is causing a boot crash hence disable it.

Fixes: 549fce068a3112 ("ARM: dts: dra7: Add l4 interconnect hierarchy and ti-sysc data")
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra71-evm.dts |  2 +-
 arch/arm/boot/dts/dra71x.dtsi   | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/dra71x.dtsi

diff --git a/arch/arm/boot/dts/dra71-evm.dts b/arch/arm/boot/dts/dra71-evm.dts
index 82cc7ec37af0..c496ae83e27e 100644
--- a/arch/arm/boot/dts/dra71-evm.dts
+++ b/arch/arm/boot/dts/dra71-evm.dts
@@ -6,7 +6,7 @@
  * published by the Free Software Foundation.
  */
 
-#include "dra72-evm-common.dtsi"
+#include "dra71x.dtsi"
 #include "dra7-mmc-iodelay.dtsi"
 #include "dra72x-mmc-iodelay.dtsi"
 #include <dt-bindings/net/ti-dp83867.h>
diff --git a/arch/arm/boot/dts/dra71x.dtsi b/arch/arm/boot/dts/dra71x.dtsi
new file mode 100644
index 000000000000..aad7394902a6
--- /dev/null
+++ b/arch/arm/boot/dts/dra71x.dtsi
@@ -0,0 +1,13 @@
+/*
+ * Copyright (C) 2019 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "dra72-evm-common.dtsi"
+
+&rtctarget {
+	status = "disabled";
+};
-- 
2.20.1



