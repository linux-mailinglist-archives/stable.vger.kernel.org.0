Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B189E150C7A
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbgBCQgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:36:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730838AbgBCQgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:36:49 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96CCF20721;
        Mon,  3 Feb 2020 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747809;
        bh=2bw8ONqF5wWv8EMEfFmi4FwVGAIpjIvCxuDNEcyGETE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqOupMdTuz363J+xL3v8JMxm7qZY7xTu6Ssget5G6VU0t1PmRForoDnyYlVhPDp5I
         eUI8KrJEbdpXuHpIaQnkbjZBmiegAzwllVEZXpNsiY+b/k22rzvLYvtm8T4hib0B+D
         rPR3mxYZZcY2hTb2zd6ESxUkZMTOj1mPBDHmBTyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 79/90] r8152: avoid the MCU to clear the lanwake
Date:   Mon,  3 Feb 2020 16:20:22 +0000
Message-Id: <20200203161926.839801919@linuxfoundation.org>
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

[ Upstream commit 19813162895a696c5814d76e5f8fb6203d70f6e0 ]

Avoid the MCU to clear the lanwake after suspending. It may cause the
WOL fail. Disable LANWAKE_CLR_EN before suspending. Besides,enable it
and reset the lanwake status when resuming or initializing.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 1f61859baa531..5f59affa94d0c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -63,6 +63,7 @@
 #define PLA_LED_FEATURE		0xdd92
 #define PLA_PHYAR		0xde00
 #define PLA_BOOT_CTRL		0xe004
+#define PLA_LWAKE_CTRL_REG	0xe007
 #define PLA_GPHY_INTR_IMR	0xe022
 #define PLA_EEE_CR		0xe040
 #define PLA_EEEP_CR		0xe080
@@ -90,6 +91,7 @@
 #define PLA_TALLYCNT		0xe890
 #define PLA_SFF_STS_7		0xe8de
 #define PLA_PHYSTATUS		0xe908
+#define PLA_CONFIG6		0xe90a /* CONFIG6 */
 #define PLA_BP_BA		0xfc26
 #define PLA_BP_0		0xfc28
 #define PLA_BP_1		0xfc2a
@@ -286,6 +288,9 @@
 #define LINK_ON_WAKE_EN		0x0010
 #define LINK_OFF_WAKE_EN	0x0008
 
+/* PLA_CONFIG6 */
+#define LANWAKE_CLR_EN		BIT(0)
+
 /* PLA_CONFIG5 */
 #define BWF_EN			0x0040
 #define MWF_EN			0x0020
@@ -342,6 +347,9 @@
 /* PLA_BOOT_CTRL */
 #define AUTOLOAD_DONE		0x0002
 
+/* PLA_LWAKE_CTRL_REG */
+#define LANWAKE_PIN		BIT(7)
+
 /* PLA_SUSPEND_FLAG */
 #define LINK_CHG_EVENT		BIT(0)
 
@@ -4004,6 +4012,8 @@ static void rtl8152_down(struct r8152 *tp)
 
 static void rtl8153_up(struct r8152 *tp)
 {
+	u32 ocp_data;
+
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
 
@@ -4011,6 +4021,15 @@ static void rtl8153_up(struct r8152 *tp)
 	r8153_u2p3en(tp, false);
 	r8153_aldps_en(tp, false);
 	r8153_first_init(tp);
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data |= LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data &= ~LANWAKE_PIN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
+
 	r8153_aldps_en(tp, true);
 
 	switch (tp->version) {
@@ -4029,11 +4048,17 @@ static void rtl8153_up(struct r8152 *tp)
 
 static void rtl8153_down(struct r8152 *tp)
 {
+	u32 ocp_data;
+
 	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
 		rtl_drop_queued_tx(tp);
 		return;
 	}
 
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data &= ~LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+
 	r8153_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
 	r8153_power_cut_en(tp, false);
@@ -4465,6 +4490,14 @@ static void r8153_init(struct r8152 *tp)
 	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
 
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data |= LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data &= ~LANWAKE_PIN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
+
 	/* rx aggregation */
 	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-- 
2.20.1



