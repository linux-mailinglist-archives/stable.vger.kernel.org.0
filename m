Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B56CA8A80
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732441AbfIDP7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732435AbfIDP7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F30342070C;
        Wed,  4 Sep 2019 15:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612776;
        bh=ogNCz7KeuQSuQwt1JQpiR7OKnj0Zgec1T27hcVBDLco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MZxWIuLiBXEFEoFM3v/66RFHvS4tdrXFMh8oDpgi7WAeMfKNS/rEdJtDpVCEbnY5
         5SqoJCOCT9/LuhM+E+nM26vJ1VKHWAplix1lGOykH+R6G2PdHFHYxWhm5B/1oQyU4G
         Pu8FHIHvylkQdatF6R6XcWp8aOTm9lzgOYGihwSY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hsin-Yi Wang <hsinyi@chromium.org>,
        Alexandru M Stan <amstan@chromium.org>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 74/94] i2c: mediatek: disable zero-length transfers for mt8183
Date:   Wed,  4 Sep 2019 11:57:19 -0400
Message-Id: <20190904155739.2816-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit abf4923e97c3abbbd1e59f0e13c7c214c93c6aaa ]

Quoting from mt8183 datasheet, the number of transfers to be
transferred in one transaction should be set to bigger than 1,
so we should forbid zero-length transfer and update functionality.

Reported-by: Alexandru M Stan <amstan@chromium.org>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Qii Wang <qii.wang@mediatek.com>
[wsa: shortened commit message a little]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 252edb433fdfb..29eae1bf4f861 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -234,6 +234,10 @@ static const struct i2c_adapter_quirks mt7622_i2c_quirks = {
 	.max_num_msgs = 255,
 };
 
+static const struct i2c_adapter_quirks mt8183_i2c_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN,
+};
+
 static const struct mtk_i2c_compatible mt2712_compat = {
 	.regs = mt_i2c_regs_v1,
 	.pmic_i2c = 0,
@@ -298,6 +302,7 @@ static const struct mtk_i2c_compatible mt8173_compat = {
 };
 
 static const struct mtk_i2c_compatible mt8183_compat = {
+	.quirks = &mt8183_i2c_quirks,
 	.regs = mt_i2c_regs_v2,
 	.pmic_i2c = 0,
 	.dcm = 0,
@@ -870,7 +875,11 @@ static irqreturn_t mtk_i2c_irq(int irqno, void *dev_id)
 
 static u32 mtk_i2c_functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	if (adap->quirks->flags & I2C_AQ_NO_ZERO_LEN)
+		return I2C_FUNC_I2C |
+			(I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
+	else
+		return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
 static const struct i2c_algorithm mtk_i2c_algorithm = {
-- 
2.20.1

