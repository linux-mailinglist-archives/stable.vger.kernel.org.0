Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF872C9C4F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390261AbgLAJRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389974AbgLAJMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DDCF221FF;
        Tue,  1 Dec 2020 09:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813940;
        bh=bEDj/ayOo9FSI2LF5zwMfXhptGHqEvSGIeU2P4MsVuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElmyZjjNU65v7LmKY7+Rc5LuvIkFrLKq5htA0yboV2/LRkXnYBbWmU4wAtg0179On
         vq/Mrj5T8R47djJxg38KE7xRar8qt0CvXeqczwkrK89jn9DL9HAzqm5zdTA88JuTd+
         btAlNA6pLV0p83ity21pdagmNJH3SwfzAMqRyz4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 082/152] phy: qualcomm: usb: Fix SuperSpeed PHY OF dependency
Date:   Tue,  1 Dec 2020 09:53:17 +0100
Message-Id: <20201201084722.638109463@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 44786a26a7485e12a1d2aaad2adfb3c82f6ad171 ]

This Kconfig entry should declare a dependency on OF

Fixes: 6076967a500c ("phy: qualcomm: usb: Add SuperSpeed PHY driver")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lkml.org/lkml/2020/11/13/414
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20201113151225.1657600-2-bryan.odonoghue@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/Kconfig b/drivers/phy/qualcomm/Kconfig
index 928db510b86c6..9129c4b8bb9b1 100644
--- a/drivers/phy/qualcomm/Kconfig
+++ b/drivers/phy/qualcomm/Kconfig
@@ -98,7 +98,7 @@ config PHY_QCOM_USB_HS_28NM
 
 config PHY_QCOM_USB_SS
 	tristate "Qualcomm USB Super-Speed PHY driver"
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on OF && (ARCH_QCOM || COMPILE_TEST)
 	depends on EXTCON || !EXTCON # if EXTCON=m, this cannot be built-in
 	select GENERIC_PHY
 	help
-- 
2.27.0



