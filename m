Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C4E328C76
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240617AbhCASws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240194AbhCASm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:42:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47FFC651E3;
        Mon,  1 Mar 2021 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619127;
        bh=Wm2GALO2Fyh0DRpskSKWE3uVZXNo8kd2apIAjpnjKU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYvoyNFDd+ruSJXdj/ThHhjY6tyWdndtQGYOIav9bosHQFIsHe2PZ0mbxKhfUKq6d
         e6q34jcMaAIgMgLyLXExwZZyOnMPpXuACdjm2JmK3R3xVpccH5IV2BQipTK8DDUdfo
         rzGF3uRl+UuvDTOvrPZgBI6g4gdqR18jTqynDzts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/663] rtc: zynqmp: depend on HAS_IOMEM
Date:   Mon,  1 Mar 2021 17:09:50 +0100
Message-Id: <20210301161158.775513532@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit ddd0521549a975e6148732d6ca6b89ffa862c0e5 ]

The Xilinx zynqmp RTC driver makes use of IOMEM functions like
devm_platform_ioremap_resource(), which are only available if
CONFIG_HAS_IOMEM is defined.

This causes the driver not to be enable under make ARCH=um allyesconfig,
even though it won't build.

By adding a dependency on HAS_IOMEM, the driver will not be enabled on
architectures which don't support it.

Fixes: 09ef18bcd5ac ("rtc: use devm_platform_ioremap_resource() to simplify code")
Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210127035146.1523286-1-davidgow@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index e59f78f99e8f1..33e4ecd6c6659 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1297,7 +1297,7 @@ config RTC_DRV_OPAL
 
 config RTC_DRV_ZYNQMP
 	tristate "Xilinx Zynq Ultrascale+ MPSoC RTC"
-	depends on OF
+	depends on OF && HAS_IOMEM
 	help
 	  If you say yes here you get support for the RTC controller found on
 	  Xilinx Zynq Ultrascale+ MPSoC.
-- 
2.27.0



