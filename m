Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA1329015
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242510AbhCAUCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235314AbhCATvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:51:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D724C650F0;
        Mon,  1 Mar 2021 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621145;
        bh=4hDSLFXF79T4j6PXoDLnf+ZeGtvf2Yi1yW1/tR3u+u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Up413N+sfSQFjH0gy+4c/RLfbP/gGIFeJ3XNkmbBDbFeOjJDu/69jGeegIWFLM+u8
         whCvVrn7W724xhX4s4FjPEmRksDd6u3MZxlVKgLAJ6m2QqDrgTEylDxUaZ2C5m1xqH
         eSQPf0DsK/d/KUTFaHhdjnU/amoc4Whv+i5H4AqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 410/775] rtc: zynqmp: depend on HAS_IOMEM
Date:   Mon,  1 Mar 2021 17:09:38 +0100
Message-Id: <20210301161221.847337364@linuxfoundation.org>
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
index e4bef40831c75..4e2b3a175607b 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1301,7 +1301,7 @@ config RTC_DRV_OPAL
 
 config RTC_DRV_ZYNQMP
 	tristate "Xilinx Zynq Ultrascale+ MPSoC RTC"
-	depends on OF
+	depends on OF && HAS_IOMEM
 	help
 	  If you say yes here you get support for the RTC controller found on
 	  Xilinx Zynq Ultrascale+ MPSoC.
-- 
2.27.0



