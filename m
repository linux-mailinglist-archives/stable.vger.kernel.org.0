Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EEC32AFE1
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbhCCA3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344108AbhCBMiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:38:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1342964F40;
        Tue,  2 Mar 2021 11:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686209;
        bh=T9VhanuWJu/sRtrg731RxKgJzqEsndhyllDNaolkWuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SX8bsl84EkdaEA9NltU7Y+Q+KKt5z8f0VVZ05Pq5q5oe6GH2vOqkYWZpoZti0keA2
         EnBSuDB/EgfM4A/ksiPjbwJ/75oDPhOp6v/UUen0w41iQTROyLWCJgDQXFv6ZW82vi
         uHZs6F0fIt9gnPI8u8nIH/Z0KiSF9d9BLKHVKsBJSJR9+uk0ctpe9N/B50oQzk44qR
         6v93rfB9KDfeAXWK6pZGdGB9IrZcbS6Dom+88SX4kWEY3HUEjf42OeiBbiIFXzcC1S
         L8KnqTgjbXFHFImOxDYlzP8Vc/1qbmOBs6VtrY/sJf3MDodxgMomfSnKFwcBTqTa5R
         t+exo2k7M+WMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/47] i2c: rcar: optimize cacheline to minimize HW race condition
Date:   Tue,  2 Mar 2021 06:56:01 -0500
Message-Id: <20210302115646.62291-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 824586d7ee56..ad6630e3cc77 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -119,6 +119,7 @@ enum rcar_i2c_type {
 };
 
 struct rcar_i2c_priv {
+	u32 flags;
 	void __iomem *io;
 	struct i2c_adapter adap;
 	struct i2c_msg *msg;
@@ -129,7 +130,6 @@ struct rcar_i2c_priv {
 
 	int pos;
 	u32 icccr;
-	u32 flags;
 	u8 recovery_icmcr;	/* protected by adapter lock */
 	enum rcar_i2c_type devtype;
 	struct i2c_client *slave;
-- 
2.30.1

