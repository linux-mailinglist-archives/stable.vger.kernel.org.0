Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D44302A90
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbhAYSnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbhAYSnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDEF0206B2;
        Mon, 25 Jan 2021 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600190;
        bh=6qUKba3U+XS8Xjrh/Qv9ZVteUNEBPoA5480vfKdzlcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGuLQOVyS+Ph19RB8keNIYLRqOk5bQ7L6MSCv+s+xNizxP1W9wJ/bLEQ2VOZQp5ZC
         z0DeR0HXedHWrM64GkdGLnuLF0lUY331psjZZjcUlE6Ztyt6EgbGX5xe1xlyc7WRsQ
         4QU4q90Pj/G8kN9cbyn5PC2DJJ4KzlklR/4ABkUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Robert Richter <rric@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/58] i2c: octeon: check correct size of maximum RECV_LEN packet
Date:   Mon, 25 Jan 2021 19:39:26 +0100
Message-Id: <20210125183157.780600645@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 1b2cfa2d1dbdcc3b6dba1ecb7026a537a1d7277f ]

I2C_SMBUS_BLOCK_MAX defines already the maximum number as defined in the
SMBus 2.0 specs. No reason to add one to it.

Fixes: 886f6f8337dd ("i2c: octeon: Support I2C_M_RECV_LEN")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Robert Richter <rric@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-octeon-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-octeon-core.c b/drivers/i2c/busses/i2c-octeon-core.c
index d9607905dc2f1..845eda70b8cab 100644
--- a/drivers/i2c/busses/i2c-octeon-core.c
+++ b/drivers/i2c/busses/i2c-octeon-core.c
@@ -347,7 +347,7 @@ static int octeon_i2c_read(struct octeon_i2c *i2c, int target,
 		if (result)
 			return result;
 		if (recv_len && i == 0) {
-			if (data[i] > I2C_SMBUS_BLOCK_MAX + 1)
+			if (data[i] > I2C_SMBUS_BLOCK_MAX)
 				return -EPROTO;
 			length += data[i];
 		}
-- 
2.27.0



