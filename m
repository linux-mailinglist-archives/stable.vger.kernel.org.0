Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4435C0B3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241312AbhDLJP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239674AbhDLJJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:09:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE6A761385;
        Mon, 12 Apr 2021 09:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218285;
        bh=NRtHKydRuvA7XqixRpGw4jbZ2dyk9afHXFvqaYT6jT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9oeB8/jUabr+27mmijTuTuaH+iiioeMcbaHJ7yPxOAUIPQkO5Y+51vHdKDWN5W/L
         krzbcKxokvVx/aKBWsDa9CM5kuzfOBiNUxskPWz66r1N6fmk6shM/A4hXLjvMjoMl4
         qsZ3trOtyAWxhz6nkNDtoPfJfCZivK5w9KR4M9V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E6=9D=A8=E6=96=87=E9=BE=99=20 ?= <ywltyut@sina.cn>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 141/210] I2C: JZ4780: Fix bug for Ingenic X1000.
Date:   Mon, 12 Apr 2021 10:40:46 +0200
Message-Id: <20210412084020.703650340@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>

[ Upstream commit 942bfbecc0281c75db84f744b9b77b0f2396f484 ]

Only send "X1000_I2C_DC_STOP" when last byte, or it will cause
error when I2C write operation which should look like this:

device_addr + w, reg_addr, data;

But without this patch, it looks like this:

device_addr + w, reg_addr, device_addr + w, data;

Fixes: 21575a7a8d4c ("I2C: JZ4780: Add support for the X1000.")
Reported-by: 杨文龙 (Yang Wenlong) <ywltyut@sina.cn>
Tested-by: 杨文龙 (Yang Wenlong) <ywltyut@sina.cn>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-jz4780.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-jz4780.c b/drivers/i2c/busses/i2c-jz4780.c
index cb4a25ebb890..2a946c207928 100644
--- a/drivers/i2c/busses/i2c-jz4780.c
+++ b/drivers/i2c/busses/i2c-jz4780.c
@@ -526,8 +526,8 @@ static irqreturn_t jz4780_i2c_irq(int irqno, void *dev_id)
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
2.30.2



