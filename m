Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A50419A53
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbhI0RIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236192AbhI0RHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DD4760F3A;
        Mon, 27 Sep 2021 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762347;
        bh=Rinp+8UG8WWYUHOf7V9BalhrUi/cbAfp6mnfPjz5qtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1do46uhByjoP6SYJggeHx7lGnC6uG/VeUGpaigdtlIY3u3PLUsGLfk2+RVk1qTKrb
         6kXqBrEI4P2/CMCxVKKycGyT+vMv/tak5mtlb/MgVTmmLg+UPq9RA13D/OiGiDndZV
         feWTNwPSk7YGUR47aYgd0DTTynMZZFhNnmEzzY1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/68] net: i825xx: Use absolute_pointer for memcpy from fixed memory location
Date:   Mon, 27 Sep 2021 19:02:52 +0200
Message-Id: <20210927170221.901098198@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit dff2d13114f0beec448da9b3716204eb34b0cf41 ]

gcc 11.x reports the following compiler warning/error.

  drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
  arch/m68k/include/asm/string.h:72:25: error:
	'__builtin_memcpy' reading 6 bytes from a region of size 0 [-Werror=stringop-overread]

Use absolute_pointer() to work around the problem.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/82596.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index 92929750f832..54d5b402b0e8 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1155,7 +1155,7 @@ struct net_device * __init i82596_probe(int unit)
 			err = -ENODEV;
 			goto out;
 		}
-		memcpy(eth_addr, (void *) 0xfffc1f2c, ETH_ALEN);	/* YUCK! Get addr from NOVRAM */
+		memcpy(eth_addr, absolute_pointer(0xfffc1f2c), ETH_ALEN); /* YUCK! Get addr from NOVRAM */
 		dev->base_addr = MVME_I596_BASE;
 		dev->irq = (unsigned) MVME16x_IRQ_I596;
 		goto found;
-- 
2.33.0



