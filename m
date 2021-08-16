Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C823ED65B
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbhHPNUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240390AbhHPNQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54EE1632F0;
        Mon, 16 Aug 2021 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119609;
        bh=6FYjnnopDEIiNfFuGWomzYCvtOd2o0OymAESuz2mu58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvY65EIPxxJLp0gnRaL3Q0AJH7ioL+7bwffWM5UD5VGhIOg8wbSrysjDHkmR5XWQD
         kFj+ZvLBTVtQET3xgCH78jEWRPT0pFAVGi0SsT7rbcAFG3JQDbTHhhIHTRSSrqJHT9
         nPjMybBjTV5fa1MpgJS9WhcC+MudEN8hDHg/Wfec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 091/151] net: dsa: microchip: Fix ksz_read64()
Date:   Mon, 16 Aug 2021 15:02:01 +0200
Message-Id: <20210816125447.075556223@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@mind.be>

[ Upstream commit c34f674c8875235725c3ef86147a627f165d23b4 ]

ksz_read64() currently does some dubious byte-swapping on the two
halves of a 64-bit register, and then only returns the high bits.
Replace this with a straightforward expression.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 2e6bfd333f50..6afbb41ad39e 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -205,12 +205,8 @@ static inline int ksz_read64(struct ksz_device *dev, u32 reg, u64 *val)
 	int ret;
 
 	ret = regmap_bulk_read(dev->regmap[2], reg, value, 2);
-	if (!ret) {
-		/* Ick! ToDo: Add 64bit R/W to regmap on 32bit systems */
-		value[0] = swab32(value[0]);
-		value[1] = swab32(value[1]);
-		*val = swab64((u64)*value);
-	}
+	if (!ret)
+		*val = (u64)value[0] << 32 | value[1];
 
 	return ret;
 }
-- 
2.30.2



