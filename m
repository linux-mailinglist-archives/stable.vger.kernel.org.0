Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BE94290C4
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbhJKOMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243244AbhJKOKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1DEE6124D;
        Mon, 11 Oct 2021 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960941;
        bh=8L3975OaSYpqTim0Qx00igMh2s33hT0RoHzUtntULoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4FZqhnrjLni+P4UtVncoFwzEfiiuC2cOfa98TNRYpK6PWbOw1GsnFiKxHzpTS5mY
         JTW0NY6jC9cPcnTgQpo64ohaYGHxRECtNddUVyBCdxsFWtaXn0M+v1pWuNBOrSIkLh
         GIrat/JAMIZmtTLOsqgNAPi6cjrCoNDKtoZdCzps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kewei Xu <kewei.xu@mediatek.com>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 120/151] i2c: mediatek: Add OFFSET_EXT_CONF setting back
Date:   Mon, 11 Oct 2021 15:46:32 +0200
Message-Id: <20211011134521.700197926@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kewei Xu <kewei.xu@mediatek.com>

[ Upstream commit 3bce7703c7ba648bd9e174dc1413f422b7998833 ]

In the commit be5ce0e97cc7 ("i2c: mediatek: Add i2c ac-timing adjust
support"), we miss setting OFFSET_EXT_CONF register if
i2c->dev_comp->timing_adjust is false, now add it back.

Fixes: be5ce0e97cc7 ("i2c: mediatek: Add i2c ac-timing adjust support")
Signed-off-by: Kewei Xu <kewei.xu@mediatek.com>
Reviewed-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 477480d1de6b..7d4b3eb7077a 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -41,6 +41,8 @@
 #define I2C_HANDSHAKE_RST		0x0020
 #define I2C_FIFO_ADDR_CLR		0x0001
 #define I2C_DELAY_LEN			0x0002
+#define I2C_ST_START_CON		0x8001
+#define I2C_FS_START_CON		0x1800
 #define I2C_TIME_CLR_VALUE		0x0000
 #define I2C_TIME_DEFAULT_VALUE		0x0003
 #define I2C_WRRD_TRANAC_VALUE		0x0002
@@ -480,6 +482,7 @@ static void mtk_i2c_init_hw(struct mtk_i2c *i2c)
 {
 	u16 control_reg;
 	u16 intr_stat_reg;
+	u16 ext_conf_val;
 
 	mtk_i2c_writew(i2c, I2C_CHN_CLR_FLAG, OFFSET_START);
 	intr_stat_reg = mtk_i2c_readw(i2c, OFFSET_INTR_STAT);
@@ -518,8 +521,13 @@ static void mtk_i2c_init_hw(struct mtk_i2c *i2c)
 	if (i2c->dev_comp->ltiming_adjust)
 		mtk_i2c_writew(i2c, i2c->ltiming_reg, OFFSET_LTIMING);
 
+	if (i2c->speed_hz <= I2C_MAX_STANDARD_MODE_FREQ)
+		ext_conf_val = I2C_ST_START_CON;
+	else
+		ext_conf_val = I2C_FS_START_CON;
+
 	if (i2c->dev_comp->timing_adjust) {
-		mtk_i2c_writew(i2c, i2c->ac_timing.ext, OFFSET_EXT_CONF);
+		ext_conf_val = i2c->ac_timing.ext;
 		mtk_i2c_writew(i2c, i2c->ac_timing.inter_clk_div,
 			       OFFSET_CLOCK_DIV);
 		mtk_i2c_writew(i2c, I2C_SCL_MIS_COMP_VALUE,
@@ -544,6 +552,7 @@ static void mtk_i2c_init_hw(struct mtk_i2c *i2c)
 				       OFFSET_HS_STA_STO_AC_TIMING);
 		}
 	}
+	mtk_i2c_writew(i2c, ext_conf_val, OFFSET_EXT_CONF);
 
 	/* If use i2c pin from PMIC mt6397 side, need set PATH_DIR first */
 	if (i2c->have_pmic)
-- 
2.33.0



