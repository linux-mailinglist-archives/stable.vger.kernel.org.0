Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87D2328D92
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhCATNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239210AbhCATJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:09:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DECB7651C3;
        Mon,  1 Mar 2021 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619009;
        bh=DYlf/iFE8udvSqLO5Aup3fUAc4SoPvkGbe0GVHJW5o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4jL5SqZHXfBwxt1R2E6u+gwmxrvolE6dFZcMVJALPZM1v+eYx0BOAcpTUGAvSgfH
         vINkBmIB5WshQJUmJqV4kUAfvVXqrI3vHncS351Jx2odFGz8mXesjzSr6XDSNOcOqw
         alofGEE4KNC1KxyB2jTP4Fe6bkSizcKHh/+rGmeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/663] i2c: iproc: update slave isr mask (ISR_MASK_SLAVE)
Date:   Mon,  1 Mar 2021 17:08:36 +0100
Message-Id: <20210301161155.075653549@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index b98433c04d184..68db2068f38b0 100644
--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -215,7 +215,8 @@ struct bcm_iproc_i2c_dev {
 
 #define ISR_MASK_SLAVE (BIT(IS_S_START_BUSY_SHIFT)\
 		| BIT(IS_S_RX_EVENT_SHIFT) | BIT(IS_S_RD_EVENT_SHIFT)\
-		| BIT(IS_S_TX_UNDERRUN_SHIFT))
+		| BIT(IS_S_TX_UNDERRUN_SHIFT) | BIT(IS_S_RX_FIFO_FULL_SHIFT)\
+		| BIT(IS_S_RX_THLD_SHIFT))
 
 static int bcm_iproc_i2c_reg_slave(struct i2c_client *slave);
 static int bcm_iproc_i2c_unreg_slave(struct i2c_client *slave);
-- 
2.27.0



