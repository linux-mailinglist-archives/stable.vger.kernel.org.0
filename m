Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F59A340A2E
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 17:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhCRQ0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 12:26:13 -0400
Received: from out28-99.mail.aliyun.com ([115.124.28.99]:54566 "EHLO
        out28-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbhCRQZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 12:25:56 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.108678|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0111474-0.000705085-0.988147;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.JmuzqJv_1616084746;
Received: from zhouyanjie-virtual-machine.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.JmuzqJv_1616084746)
          by smtp.aliyun-inc.com(10.147.41.138);
          Fri, 19 Mar 2021 00:25:52 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     wsa@kernel.org, paul@crapouillou.net
Cc:     stable@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        sernia.zhou@foxmail.com
Subject: [PATCH] I2C: JZ4780: Fix bug for Ingenic X1000.
Date:   Fri, 19 Mar 2021 00:25:43 +0800
Message-Id: <1616084743-112402-2-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616084743-112402-1-git-send-email-zhouyanjie@wanyeetech.com>
References: <1616084743-112402-1-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only send "X1000_I2C_DC_STOP" when last byte, or it will cause
error when I2C write operation.

Fixes: 21575a7a8d4c ("I2C: JZ4780: Add support for the X1000.")

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---
 drivers/i2c/busses/i2c-jz4780.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-jz4780.c b/drivers/i2c/busses/i2c-jz4780.c
index 8509c5f..1ad093a 100644
--- a/drivers/i2c/busses/i2c-jz4780.c
+++ b/drivers/i2c/busses/i2c-jz4780.c
@@ -520,13 +520,12 @@ static irqreturn_t jz4780_i2c_irq(int irqno, void *dev_id)
 
 			i2c_sta = jz4780_i2c_readw(i2c, JZ4780_I2C_STA);
 
-			while ((i2c_sta & JZ4780_I2C_STA_TFNF) &&
-					(i2c->wt_len > 0)) {
+			while ((i2c_sta & JZ4780_I2C_STA_TFNF) && (i2c->wt_len > 0)) {
 				i2c_sta = jz4780_i2c_readw(i2c, JZ4780_I2C_STA);
 				data = *i2c->wbuf;
 				data &= ~JZ4780_I2C_DC_READ;
-				if ((!i2c->stop_hold) && (i2c->cdata->version >=
-						ID_X1000))
+				if ((i2c->wt_len == 1) && (!i2c->stop_hold) &&
+						(i2c->cdata->version >= ID_X1000))
 					data |= X1000_I2C_DC_STOP;
 				jz4780_i2c_writew(i2c, JZ4780_I2C_DC, data);
 				i2c->wbuf++;
-- 
2.7.4

