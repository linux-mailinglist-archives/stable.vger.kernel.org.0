Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021D832AFF3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhCCA3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237788AbhCBMnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:43:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D68DE64F7E;
        Tue,  2 Mar 2021 11:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686274;
        bh=usTZBEyYoeHw+d0qswx2qWUgUYZxRBkXSl4lWppua3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMWuaPpADRSIWFtJ8waDecrTR23oGYQVxpzB1AFbJUNjNuDiiBa4jSCTVyD1AnO9p
         o2u2NhsBp1HzKP1LYohxXb9gUFLQC1klKOVIZCV5RRCKNQEb63xGQrWG/WPMQFWCHx
         YIrMXGI/3hFqSPrlPpTSHmtyUCenqeuirhVvMoMOXVr0cvjFSH53syy2FrdK0oY0gt
         rI+PEigDAFKJ1ssFjPYKlqFbHi1f31gZ4geYl5TQqYFkRKSm47ucqB+Z7t5JCyyUMq
         VoPWzDPfYek2yeRQpyrSr3SYATEkKIl7qlMlX0q97Cfed8wYkPikES3zl1psMnzeQ3
         3we2ozjsZQzxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/33] i2c: rcar: optimize cacheline to minimize HW race condition
Date:   Tue,  2 Mar 2021 06:57:18 -0500
Message-Id: <20210302115749.62653-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
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

