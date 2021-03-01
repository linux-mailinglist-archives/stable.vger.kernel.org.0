Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CD13288A7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbhCARn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236270AbhCARhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:37:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67C39650B2;
        Mon,  1 Mar 2021 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617692;
        bh=8Zfej8UGyP2IBtuE65LCzugeSGEYDv6oLSCzHmWVmJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkdXalZXKQwXER8zCaE7pGjWb1gJGZmAlKis02Utcxk9WEUQWVUK9MzhQ3eyM9Lzy
         YxCtxbIVP4MK1Bw+YA9e8pQGlRA0dwhcWuyx1q5FbaYWpXNHV97rAffm3PTLrgki9h
         b/pvfW63XIfiX06WIK/bebZxiwFYeq08tS+VcQp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/340] i2c: iproc: update slave isr mask (ISR_MASK_SLAVE)
Date:   Mon,  1 Mar 2021 17:11:17 +0100
Message-Id: <20210301161054.854523850@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

[ Upstream commit 603e77af7b0704bdb057de0368f1f2b04fc9552c ]

Update slave isr mask (ISR_MASK_SLAVE) to include remaining
two slave interrupts.

Fixes: c245d94ed106 ("i2c: iproc: Add multi byte read-write support for slave mode")
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-bcm-iproc.c b/drivers/i2c/busses/i2c-bcm-iproc.c
index 2983cd9f855b4..38a28bf6cfee4 100644
--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -213,7 +213,8 @@ struct bcm_iproc_i2c_dev {
 
 #define ISR_MASK_SLAVE (BIT(IS_S_START_BUSY_SHIFT)\
 		| BIT(IS_S_RX_EVENT_SHIFT) | BIT(IS_S_RD_EVENT_SHIFT)\
-		| BIT(IS_S_TX_UNDERRUN_SHIFT))
+		| BIT(IS_S_TX_UNDERRUN_SHIFT) | BIT(IS_S_RX_FIFO_FULL_SHIFT)\
+		| BIT(IS_S_RX_THLD_SHIFT))
 
 static int bcm_iproc_i2c_reg_slave(struct i2c_client *slave);
 static int bcm_iproc_i2c_unreg_slave(struct i2c_client *slave);
-- 
2.27.0



