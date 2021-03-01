Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BCA328B18
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbhCAS2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:28:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239772AbhCASWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:22:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C59D864EEE;
        Mon,  1 Mar 2021 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620886;
        bh=DYlf/iFE8udvSqLO5Aup3fUAc4SoPvkGbe0GVHJW5o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XX0D3vtqUHAaPRnaBLFYt2Tcoyt2vQNTwpYgg/asMPj79Bzctt22qWGdJ1PgAZtWo
         k9NEYGBDY4aioaeiGqk5A3QNxKTziMCAJdGwhchIn0DHkxBQ2iw47cK9N6UYfgAou3
         Noe4RH9O5VNmEAhtx8DdMCBt2va9xrf1XIQBZG6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 316/775] i2c: iproc: update slave isr mask (ISR_MASK_SLAVE)
Date:   Mon,  1 Mar 2021 17:08:04 +0100
Message-Id: <20210301161217.234502543@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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



