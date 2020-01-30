Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CBC14E1F3
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbgA3Srn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730566AbgA3Srm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:47:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BF28205F4;
        Thu, 30 Jan 2020 18:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410062;
        bh=E5MHSmI3yutRirhYzzRsacg3dm4AkkPV77sttgFsImA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJcYZdeUsi5jQ5cbOrZDfVbiyYiNCT9A/iO8FDZL3+QsUhk11ha0MjxC+f4ebtFVQ
         ol5sU2RPhnlVv6JKX8De63wQcso5Eq2QctPfPp7xGreelTTdNq5L0lDyfjIdPQSajS
         YtLxPjwKttcuiX1q4/wJcioKzbz0t3KB3hpCMNZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Evan Green <evgreen@chromium.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/55] phy: qcom-qmp: Increase PHY ready timeout
Date:   Thu, 30 Jan 2020 19:39:12 +0100
Message-Id: <20200130183614.289558622@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit cd217ee6867d285ceecd610fa1006975d5c683fa ]

It's typical for the QHP PHY to take slightly above 1ms to initialize,
so increase the timeout of the PHY ready check to 10ms - as already done
in the downstream PCIe driver.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Evan Green <evgreen@chromium.org>
Tested-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 4c470104a0d61..cf515928fed09 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -66,7 +66,7 @@
 /* QPHY_V3_PCS_MISC_CLAMP_ENABLE register bits */
 #define CLAMP_EN				BIT(0) /* enables i/o clamp_n */
 
-#define PHY_INIT_COMPLETE_TIMEOUT		1000
+#define PHY_INIT_COMPLETE_TIMEOUT		10000
 #define POWER_DOWN_DELAY_US_MIN			10
 #define POWER_DOWN_DELAY_US_MAX			11
 
-- 
2.20.1



