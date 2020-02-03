Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B08150CD0
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgBCQgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730911AbgBCQgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:36:47 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F62A20721;
        Mon,  3 Feb 2020 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747806;
        bh=k1u6+l4ImzTwBq1QY2DMDIFsiPThilxBmkl8gjpHXcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFMDNelNFEQPWclazUN5nHRle+mO6Yl06mTpXwdtJrEPDQzlbP/HMnh8hcq/COYP/
         T404B1dOCaDt+spjTNoBcN6IrJvD71WPeruY6grcggB5uSirK/T7gsFg62t1OkxDmm
         9qLVDXs8EMmCNh7g74WL2pE0r7zR5IyG0+6g42U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 78/90] r8152: disable test IO for RTL8153B
Date:   Mon,  3 Feb 2020 16:20:21 +0000
Message-Id: <20200203161926.755377982@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit d7f1b59655efb5a285d227c8f9853a98eab5c2fd ]

For RTL8153B with QFN32, disable test IO. Otherwise, it may cause
abnormal behavior for the device randomly.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2d3374a373f83..1f61859baa531 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -298,6 +298,7 @@
 /* PLA_PHY_PWR */
 #define TX_10M_IDLE_EN		0x0080
 #define PFM_PWM_SWITCH		0x0040
+#define TEST_IO_OFF		BIT(4)
 
 /* PLA_MAC_PWR_CTRL */
 #define D3_CLK_GATED_EN		0x00004000
@@ -4540,6 +4541,15 @@ static void r8153b_init(struct r8152 *tp)
 	ocp_data &= ~PLA_MCU_SPDWN_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
 
+	if (tp->version == RTL_VER_09) {
+		/* Disable Test IO for 32QFN */
+		if (ocp_read_byte(tp, MCU_TYPE_PLA, 0xdc00) & BIT(5)) {
+			ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+			ocp_data |= TEST_IO_OFF;
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
+		}
+	}
+
 	set_bit(GREEN_ETHERNET, &tp->flags);
 
 	/* rx aggregation */
-- 
2.20.1



