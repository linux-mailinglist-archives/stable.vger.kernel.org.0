Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9D7451EFA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344670AbhKPAiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344572AbhKOTZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C97861A56;
        Mon, 15 Nov 2021 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002799;
        bh=gqq9KKE0mgn3BJBjd3CNbKBSkZd21PDpbod6pCjr/CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TzGFYTFoFFY1JIX4r95dG4ObwLHteoWI6UxXEU/Y650GuHKHcyXso4YWn0tJvYJ3
         /5sVG2wIHi525Y25KySYBZRTLcgXcOLM/2v2iFldViveCACJsJSyjdzkNySYYG1/PE
         yISTRCV5Rw+UnksHV1zL4r+NHj3QoRyG9XAM2rsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sandeep Maheswaram <quic_c_sanm@quicinc.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 668/917] phy: qcom-snps: Correct the FSEL_MASK
Date:   Mon, 15 Nov 2021 18:02:43 +0100
Message-Id: <20211115165451.542865023@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Maheswaram <quic_c_sanm@quicinc.com>

[ Upstream commit b475bf0ec40a2b13fb32ef62f5706576d5858460 ]

The FSEL_MASK which selects the refclock is defined incorrectly.
It should be [4:6] not [5:7]. Due to this incorrect definition, the BIT(7)
in USB2_PHY_USB_PHY_HS_PHY_CTRL_COMMON0 is reset which keeps PHY analog
blocks ON during suspend.
Fix this issue by correctly defining the FSEL_MASK.

Fixes: 51e8114f80d0 ("phy: qcom-snps: Add SNPS USB PHY driver for QCOM based SOCs")
Signed-off-by: Sandeep Maheswaram <quic_c_sanm@quicinc.com>
Link: https://lore.kernel.org/r/1635135575-5668-1-git-send-email-quic_c_sanm@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c b/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
index ae4bac024c7b1..7e61202aa234e 100644
--- a/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
+++ b/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
@@ -33,7 +33,7 @@
 
 #define USB2_PHY_USB_PHY_HS_PHY_CTRL_COMMON0	(0x54)
 #define RETENABLEN				BIT(3)
-#define FSEL_MASK				GENMASK(7, 5)
+#define FSEL_MASK				GENMASK(6, 4)
 #define FSEL_DEFAULT				(0x3 << 4)
 
 #define USB2_PHY_USB_PHY_HS_PHY_CTRL_COMMON1	(0x58)
-- 
2.33.0



