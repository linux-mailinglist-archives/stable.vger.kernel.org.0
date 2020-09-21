Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9C027280A
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgIUOk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgIUOk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B7DD2371F;
        Mon, 21 Sep 2020 14:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699252;
        bh=epOgRHJDgXsxln8kuvcmrBtLdvOqe96oF8UpA61L8X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8dOr7n3XFo3w/dITei4kEhijo8bA7pfeJjTGLdIoTAzNQHX+9LDRzwxg07Rah27X
         T+lOxryJphhl3GV7UN0LaoBe2vBRH6o9TuF/YXhL7HrJFo3CXn32+5NoA9nFyUlNro
         otRQ1V8+p2AiS1RVz5r22jCdDLLWLnGmrsFfeCgU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qii Wang <qii.wang@mediatek.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 19/20] i2c: mediatek: Send i2c master code at more than 1MHz
Date:   Mon, 21 Sep 2020 10:40:26 -0400
Message-Id: <20200921144027.2135390-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qii Wang <qii.wang@mediatek.com>

[ Upstream commit b44658e755b5a733e9df04449facbc738df09170 ]

The master code needs to being sent when the speed is more than
I2C_MAX_FAST_MODE_PLUS_FREQ, not I2C_MAX_FAST_MODE_FREQ in the
latest I2C-bus specification and user manual.

Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index deef69e569062..440b12eba1e3c 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -736,7 +736,7 @@ static int mtk_i2c_set_speed(struct mtk_i2c *i2c, unsigned int parent_clk)
 	for (clk_div = 1; clk_div <= max_clk_div; clk_div++) {
 		clk_src = parent_clk / clk_div;
 
-		if (target_speed > I2C_MAX_FAST_MODE_FREQ) {
+		if (target_speed > I2C_MAX_FAST_MODE_PLUS_FREQ) {
 			/* Set master code speed register */
 			ret = mtk_i2c_calculate_speed(i2c, clk_src,
 						      I2C_MAX_FAST_MODE_FREQ,
-- 
2.25.1

