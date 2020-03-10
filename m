Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1C517FCCB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgCJM7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729690AbgCJM7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:59:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 807A12467D;
        Tue, 10 Mar 2020 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845151;
        bh=1aCofeW059HYtRuj0hfyGP+MaSXdJA7L1wUbLBEx+CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvcudYpH3SSAvaIzhWSIAkk5TTJNFpIq9vNfXbfw7xMSdbIRtIgoEy9vIE3cqrXh4
         CJWB2VyD4YwcS2zbk6xTSEjoDoTdpqMV0jxTtT0mgydLEXT4x4Efyd04tDLSxX9QnA
         D1lvmPjGs11SSQH5arRim8pTW9BtaO6Vc0twqKCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 032/189] net: atlantic: ptp gpio adjustments
Date:   Tue, 10 Mar 2020 13:37:49 +0100
Message-Id: <20200310123642.713155502@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

[ Upstream commit f08a464c27ca0a4050333baa271504b27ce834b7 ]

Clock adjustment data should be passed to FW as well, otherwise in some
cases a drift was observed when using GPIO features.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h       |  2 ++
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c    |  4 +++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c     | 12 ++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index cc70c606b6ef2..251767c31f7e5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -337,6 +337,8 @@ struct aq_fw_ops {
 
 	void (*enable_ptp)(struct aq_hw_s *self, int enable);
 
+	void (*adjust_ptp)(struct aq_hw_s *self, uint64_t adj);
+
 	int (*set_eee_rate)(struct aq_hw_s *self, u32 speed);
 
 	int (*get_eee_rate)(struct aq_hw_s *self, u32 *rate,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index fce587aaba33d..d20d91cdece86 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1165,6 +1165,8 @@ static int hw_atl_b0_adj_sys_clock(struct aq_hw_s *self, s64 delta)
 {
 	self->ptp_clk_offset += delta;
 
+	self->aq_fw_ops->adjust_ptp(self, self->ptp_clk_offset);
+
 	return 0;
 }
 
@@ -1215,7 +1217,7 @@ static int hw_atl_b0_gpio_pulse(struct aq_hw_s *self, u32 index,
 	fwreq.ptp_gpio_ctrl.index = index;
 	fwreq.ptp_gpio_ctrl.period = period;
 	/* Apply time offset */
-	fwreq.ptp_gpio_ctrl.start = start - self->ptp_clk_offset;
+	fwreq.ptp_gpio_ctrl.start = start;
 
 	size = sizeof(fwreq.msg_id) + sizeof(fwreq.ptp_gpio_ctrl);
 	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 97ebf849695fd..77a4ed64830fd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -30,6 +30,9 @@
 #define HW_ATL_FW3X_EXT_CONTROL_ADDR     0x378
 #define HW_ATL_FW3X_EXT_STATE_ADDR       0x37c
 
+#define HW_ATL_FW3X_PTP_ADJ_LSW_ADDR	 0x50a0
+#define HW_ATL_FW3X_PTP_ADJ_MSW_ADDR	 0x50a4
+
 #define HW_ATL_FW2X_CAP_PAUSE            BIT(CAPS_HI_PAUSE)
 #define HW_ATL_FW2X_CAP_ASYM_PAUSE       BIT(CAPS_HI_ASYMMETRIC_PAUSE)
 #define HW_ATL_FW2X_CAP_SLEEP_PROXY      BIT(CAPS_HI_SLEEP_PROXY)
@@ -475,6 +478,14 @@ static void aq_fw3x_enable_ptp(struct aq_hw_s *self, int enable)
 	aq_hw_write_reg(self, HW_ATL_FW3X_EXT_CONTROL_ADDR, ptp_opts);
 }
 
+static void aq_fw3x_adjust_ptp(struct aq_hw_s *self, uint64_t adj)
+{
+	aq_hw_write_reg(self, HW_ATL_FW3X_PTP_ADJ_LSW_ADDR,
+			(adj >>  0) & 0xffffffff);
+	aq_hw_write_reg(self, HW_ATL_FW3X_PTP_ADJ_MSW_ADDR,
+			(adj >> 32) & 0xffffffff);
+}
+
 static int aq_fw2x_led_control(struct aq_hw_s *self, u32 mode)
 {
 	if (self->fw_ver_actual < HW_ATL_FW_VER_LED)
@@ -633,4 +644,5 @@ const struct aq_fw_ops aq_fw_2x_ops = {
 	.enable_ptp         = aq_fw3x_enable_ptp,
 	.led_control        = aq_fw2x_led_control,
 	.set_phyloopback    = aq_fw2x_set_phyloopback,
+	.adjust_ptp         = aq_fw3x_adjust_ptp,
 };
-- 
2.20.1



