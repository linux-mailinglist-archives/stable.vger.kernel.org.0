Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19B733B8EC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhCOOEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232305AbhCON6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C199C64F43;
        Mon, 15 Mar 2021 13:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816715;
        bh=Hl0B26JDSLEcH9BPI5Pxmy6u+z2PZl4XUVNynyK+8Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aV9bSzermvyRckmtWuedlrhSYiX9AQLJWM62wD3QIbHpNEhTpxEQpjlgZ/A1PuNst
         19DuZMBKjasb7mFJKpSN6ws+dWT7Trba3pZl0BSoS5ajiBoEAWQt2iJa1p9p4e62hH
         +4BSP8isMTfSjkc2Y/9c7ZDAsWs0AbplZb3gSIAw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/168] i2c: rcar: optimize cacheline to minimize HW race condition
Date:   Mon, 15 Mar 2021 14:54:55 +0100
Message-Id: <20210315135552.443572886@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 25c2e0fb5fefb8d7847214cf114d94c7aad8e9ce ]

'flags' and 'io' are needed first, so they should be at the beginning of
the private struct.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 9d54ae935524..d0c4b3019e41 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -116,6 +116,7 @@ enum rcar_i2c_type {
 };
 
 struct rcar_i2c_priv {
+	u32 flags;
 	void __iomem *io;
 	struct i2c_adapter adap;
 	struct i2c_msg *msg;
@@ -126,7 +127,6 @@ struct rcar_i2c_priv {
 
 	int pos;
 	u32 icccr;
-	u32 flags;
 	u8 recovery_icmcr;	/* protected by adapter lock */
 	enum rcar_i2c_type devtype;
 	struct i2c_client *slave;
-- 
2.30.1



