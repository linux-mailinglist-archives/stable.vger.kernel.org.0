Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F6B38385E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbhEQPwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345083AbhEQPuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E6AA61D4E;
        Mon, 17 May 2021 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262732;
        bh=4qn/o1jq7ot2iUr5OwZVguiLDDYmq2cO08lHXczxDQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3Yss0GmNMya8bBVCDNrgc+uSOvqMKp0g7s9QG6HCeVxqWzYS7K9cvbrInEKHXa6w
         1aBSu7xlgy5M4f+SDlw546qTL79r5OyJ7QfQ3Sk258mmCXhEEhIRdix5cxFb4Cu76n
         nnify5tgk4keUz2yq2evjKCTf7hRTn8nkyDodMe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 283/289] i2c: mediatek: Fix send master code at more than 1MHz
Date:   Mon, 17 May 2021 16:03:28 +0200
Message-Id: <20210517140314.664246684@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qii Wang <qii.wang@mediatek.com>

commit 63ce8e3df8f6deca2da52eaf064751ad4018b46e upstream.

There are some omissions in the previous patch about replacing
I2C_MAX_FAST_MODE__FREQ with I2C_MAX_FAST_MODE_PLUS_FREQ and
need to fix it.

Fixes: b44658e755b5("i2c: mediatek: Send i2c master code at more than 1MHz")
Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mt65xx.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -564,7 +564,7 @@ static const struct i2c_spec_values *mtk
 
 static int mtk_i2c_max_step_cnt(unsigned int target_speed)
 {
-	if (target_speed > I2C_MAX_FAST_MODE_FREQ)
+	if (target_speed > I2C_MAX_FAST_MODE_PLUS_FREQ)
 		return MAX_HS_STEP_CNT_DIV;
 	else
 		return MAX_STEP_CNT_DIV;
@@ -635,7 +635,7 @@ static int mtk_i2c_check_ac_timing(struc
 	if (sda_min > sda_max)
 		return -3;
 
-	if (check_speed > I2C_MAX_FAST_MODE_FREQ) {
+	if (check_speed > I2C_MAX_FAST_MODE_PLUS_FREQ) {
 		if (i2c->dev_comp->ltiming_adjust) {
 			i2c->ac_timing.hs = I2C_TIME_DEFAULT_VALUE |
 				(sample_cnt << 12) | (high_cnt << 8);
@@ -850,7 +850,7 @@ static int mtk_i2c_do_transfer(struct mt
 
 	control_reg = mtk_i2c_readw(i2c, OFFSET_CONTROL) &
 			~(I2C_CONTROL_DIR_CHANGE | I2C_CONTROL_RS);
-	if ((i2c->speed_hz > I2C_MAX_FAST_MODE_FREQ) || (left_num >= 1))
+	if ((i2c->speed_hz > I2C_MAX_FAST_MODE_PLUS_FREQ) || (left_num >= 1))
 		control_reg |= I2C_CONTROL_RS;
 
 	if (i2c->op == I2C_MASTER_WRRD)
@@ -1067,7 +1067,8 @@ static int mtk_i2c_transfer(struct i2c_a
 		}
 	}
 
-	if (i2c->auto_restart && num >= 2 && i2c->speed_hz > I2C_MAX_FAST_MODE_FREQ)
+	if (i2c->auto_restart && num >= 2 &&
+		i2c->speed_hz > I2C_MAX_FAST_MODE_PLUS_FREQ)
 		/* ignore the first restart irq after the master code,
 		 * otherwise the first transfer will be discarded.
 		 */


