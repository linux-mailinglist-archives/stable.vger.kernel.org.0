Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E97C1C8E8D
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgEGO2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgEGO2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DAAD2084D;
        Thu,  7 May 2020 14:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861683;
        bh=JpMqNa6KjjZACMc14JpRz2Qlsk+u9kAyVz8DlBvFEG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B//tsRXIep6Gf8/h90s+PRqDFmRSBnsVLvHOXzzIJ6LNnzxPAH+dCX4bAMif71Z1Y
         fhEs6zcG0t3TyW0Dk4T3R5F6t6BGPAISnT7pW1RGYRsGnxqSNcHqeAa5i8H/LV3NzO
         skYpq4VxIzqkf3fWF3RuiYeHK6u5iajtjwF+lVTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 29/50] i2c: iproc: generate stop event for slave writes
Date:   Thu,  7 May 2020 10:27:05 -0400
Message-Id: <20200507142726.25751-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

[ Upstream commit 068143a8195fb0fdeea1f3ca430b3db0f6d04a53 ]

When slave status is I2C_SLAVE_RX_END, generate I2C_SLAVE_STOP
event to i2c_client.

Fixes: c245d94ed106 ("i2c: iproc: Add multi byte read-write support for slave mode")
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-bcm-iproc.c b/drivers/i2c/busses/i2c-bcm-iproc.c
index 30efb7913b2e1..b58224b7ba791 100644
--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -360,6 +360,9 @@ static bool bcm_iproc_i2c_slave_isr(struct bcm_iproc_i2c_dev *iproc_i2c,
 			value = (u8)((val >> S_RX_DATA_SHIFT) & S_RX_DATA_MASK);
 			i2c_slave_event(iproc_i2c->slave,
 					I2C_SLAVE_WRITE_RECEIVED, &value);
+			if (rx_status == I2C_SLAVE_RX_END)
+				i2c_slave_event(iproc_i2c->slave,
+						I2C_SLAVE_STOP, &value);
 		}
 	} else if (status & BIT(IS_S_TX_UNDERRUN_SHIFT)) {
 		/* Master read other than start */
-- 
2.20.1

