Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A4B150DE6
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgBCQ1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729320AbgBCQ1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:27:03 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FBAD2080C;
        Mon,  3 Feb 2020 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747222;
        bh=RMVr5lbZNUQ5PLSw+ZOShgdvCLUUmzfmSdmzJ+42/WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAdZLVaqokJzuy1cqmjh0IFKxzN+gIpLw1WcIV2xU0tXyf6gruiYOfH0gcigWQ/8A
         HkzuJd4sUJ4ujVHFFGgKcUOVs1VKowDur0CYbB6gLGUzTytjhCp3wwXzmI6MOyAhz+
         5TJJodzEkMw1zVPM41FUTqAqHEw0Zu1edK69xyXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 63/68] net/sonic: Use MMIO accessors
Date:   Mon,  3 Feb 2020 16:19:59 +0000
Message-Id: <20200203161915.228280155@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit e3885f576196ddfc670b3d53e745de96ffcb49ab ]

The driver accesses descriptor memory which is simultaneously accessed by
the chip, so the compiler must not be allowed to re-order CPU accesses.
sonic_buf_get() used 'volatile' to prevent that. sonic_buf_put() should
have done so too but was overlooked.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/sonic.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index 1fd61d7f79bcb..a009a99c0e544 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -342,30 +342,30 @@ static void sonic_tx_timeout(struct net_device *dev);
    as far as we can tell. */
 /* OpenBSD calls this "SWO".  I'd like to think that sonic_buf_put()
    is a much better name. */
-static inline void sonic_buf_put(void* base, int bitmode,
+static inline void sonic_buf_put(u16 *base, int bitmode,
 				 int offset, __u16 val)
 {
 	if (bitmode)
 #ifdef __BIG_ENDIAN
-		((__u16 *) base + (offset*2))[1] = val;
+		__raw_writew(val, base + (offset * 2) + 1);
 #else
-		((__u16 *) base + (offset*2))[0] = val;
+		__raw_writew(val, base + (offset * 2) + 0);
 #endif
 	else
-	 	((__u16 *) base)[offset] = val;
+		__raw_writew(val, base + (offset * 1) + 0);
 }
 
-static inline __u16 sonic_buf_get(void* base, int bitmode,
+static inline __u16 sonic_buf_get(u16 *base, int bitmode,
 				  int offset)
 {
 	if (bitmode)
 #ifdef __BIG_ENDIAN
-		return ((volatile __u16 *) base + (offset*2))[1];
+		return __raw_readw(base + (offset * 2) + 1);
 #else
-		return ((volatile __u16 *) base + (offset*2))[0];
+		return __raw_readw(base + (offset * 2) + 0);
 #endif
 	else
-		return ((volatile __u16 *) base)[offset];
+		return __raw_readw(base + (offset * 1) + 0);
 }
 
 /* Inlines that you should actually use for reading/writing DMA buffers */
-- 
2.20.1



