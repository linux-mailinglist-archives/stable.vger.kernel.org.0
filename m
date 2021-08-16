Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8D43ED60A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhHPNQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240276AbhHPNPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE31632D1;
        Mon, 16 Aug 2021 13:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119539;
        bh=cWAgumuHDQdJbe6jjGEOiETEi0Es/ioEfexmXAzT58I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfdCu7Xj9a31WWVTOYms2siENBC0FC6zEiLcVQiDHQhhjF19iQPwk/0OuMIu25L5+
         YOgCm4IjWdHTecgHBlKw0p3+ldDjjbgjfARIAGKKzMBHUv3HK+CRzm0oYoPKcYcNiw
         81IZkin2WaW2lITwk8cMC1vgcyEgxcdZz3Rsqsw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Matteo Croce <mcroce@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Hubbard <jhubbard@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 058/151] net: mvvp2: fix short frame size on s390
Date:   Mon, 16 Aug 2021 15:01:28 +0200
Message-Id: <20210816125445.979349376@linuxfoundation.org>
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

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit 704e624f7b3e8a4fc1ce43fb564746d1d07b20c0 ]

On s390, the following build warning occurs:

drivers/net/ethernet/marvell/mvpp2/mvpp2.h:844:2: warning: overflow in
conversion from 'long unsigned int' to 'int' changes value from
'18446744073709551584' to '-32' [-Woverflow]
844 |  ((total_size) - MVPP2_SKB_HEADROOM - MVPP2_SKB_SHINFO_SIZE)

This happens because MVPP2_SKB_SHINFO_SIZE, which is 320 bytes (which is
already 64-byte aligned) on some architectures, actually gets ALIGN'd up
to 512 bytes in the s390 case.

So then, when this is invoked:

    MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_SHORT_FRAME_SIZE)

...that turns into:

     704 - 224 - 512 == -32

...which is not a good frame size to end up with! The warning above is a
bit lucky: it notices a signed/unsigned bad behavior here, which leads
to the real problem of a frame that is too short for its contents.

Increase MVPP2_BM_SHORT_FRAME_SIZE by 32 (from 704 to 736), which is
just exactly big enough. (The other values can't readily be changed
without causing a lot of other problems.)

Fixes: 07dd0a7aae7f ("mvpp2: add basic XDP support")
Cc: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Matteo Croce <mcroce@microsoft.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4a61c90003b5..722209a14f53 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -938,7 +938,7 @@ enum mvpp22_ptp_packet_format {
 #define MVPP2_BM_COOKIE_POOL_OFFS	8
 #define MVPP2_BM_COOKIE_CPU_OFFS	24
 
-#define MVPP2_BM_SHORT_FRAME_SIZE	704	/* frame size 128 */
+#define MVPP2_BM_SHORT_FRAME_SIZE	736	/* frame size 128 */
 #define MVPP2_BM_LONG_FRAME_SIZE	2240	/* frame size 1664 */
 #define MVPP2_BM_JUMBO_FRAME_SIZE	10432	/* frame size 9856 */
 /* BM short pool packet size
-- 
2.30.2



