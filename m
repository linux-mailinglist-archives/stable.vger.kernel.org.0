Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA34632AF87
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbhCCAZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:25:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244198AbhCBMVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:21:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 264AC64F14;
        Tue,  2 Mar 2021 11:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686317;
        bh=xHXRJThog1hkYwY3dSKNZooLBmgzZ2qlg5ktIXw3/Q0=;
        h=From:To:Cc:Subject:Date:From;
        b=j1ShV0X5vgMam0HnRvVfhzBy0ZotGymwSBPG32HpECN8LsX693IvB/hRm4B8FWJ/x
         P6k0TXZCswCY4mUHbz26UOV4Dqs7wpcFyst9uLovO+kQgexjhx5zd2boa1LSz+xzWp
         d40ZFG7Do+Pxorh6/vGNiz4yqJu5UuhiTczW0NoxZJiUJYnyx0eRQv/O0wSG9j4/Aj
         bVf8iF8vF+ck/P5teXHj3/j3JC+uAxJH8KW2Sa8tjzCC5CohQG8TYxhI/k1NZZcyxe
         MQavWcEz4PjDmddO7ZqRUaDh6GQR70rGu1mDio1rh4hc0nHKLO0PFZHy9zcrroFX4U
         SG6CdGC4l+fCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/21] i2c: rcar: optimize cacheline to minimize HW race condition
Date:   Tue,  2 Mar 2021 06:58:15 -0500
Message-Id: <20210302115835.63269-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
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
index f9029800d399..3ea2ceec676c 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -117,6 +117,7 @@ enum rcar_i2c_type {
 };
 
 struct rcar_i2c_priv {
+	u32 flags;
 	void __iomem *io;
 	struct i2c_adapter adap;
 	struct i2c_msg *msg;
@@ -127,7 +128,6 @@ struct rcar_i2c_priv {
 
 	int pos;
 	u32 icccr;
-	u32 flags;
 	u8 recovery_icmcr;	/* protected by adapter lock */
 	enum rcar_i2c_type devtype;
 	struct i2c_client *slave;
-- 
2.30.1

