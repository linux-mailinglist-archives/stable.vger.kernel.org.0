Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B903ED55A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbhHPNLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239048AbhHPNJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A803860F46;
        Mon, 16 Aug 2021 13:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119297;
        bh=Y9Xib0C+x/b20AG6OSQWYiS+G5hgP8FtbkZzPmKQwH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bflIYXO0u1hTCHgzrOnXVrRztk1Fi7pn+siwHOnSEvhJdShno6lS/H5fQ0N8hoB3f
         7qhmyBx2D8Ndv3lPANEKDHUWbTnOK0zQxudlcqmQQxr/1ECBku9DmEzFu/62lQYyS1
         sQrayUS6wMO//x0Y+7MtfpFvT6mxj4gpJB+nprKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Matteo Croce <mcroce@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Hubbard <jhubbard@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/96] net: mvvp2: fix short frame size on s390
Date:   Mon, 16 Aug 2021 15:01:45 +0200
Message-Id: <20210816125436.122511505@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
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
index a1aefce55e65..d825eb021b22 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -854,7 +854,7 @@ enum mvpp22_ptp_packet_format {
 #define MVPP2_BM_COOKIE_POOL_OFFS	8
 #define MVPP2_BM_COOKIE_CPU_OFFS	24
 
-#define MVPP2_BM_SHORT_FRAME_SIZE	704	/* frame size 128 */
+#define MVPP2_BM_SHORT_FRAME_SIZE	736	/* frame size 128 */
 #define MVPP2_BM_LONG_FRAME_SIZE	2240	/* frame size 1664 */
 #define MVPP2_BM_JUMBO_FRAME_SIZE	10432	/* frame size 9856 */
 /* BM short pool packet size
-- 
2.30.2



