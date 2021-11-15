Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B844450C15
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbhKOReh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237460AbhKORcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:32:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0D7863246;
        Mon, 15 Nov 2021 17:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996879;
        bh=kShRhABdBUyJwOpt0C2fuKl59fR3o3fwKi6brQChbe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwM/7b/eToPwuV2whlMi4d9HouvjlSimRaQofNY9nBumcQwtDruSD+8PfiMINFy9l
         YLVS2NcF1Kuf1QiiZ7PiJwZqMmRUSiql2aZ5nxPzoNAF+4kK6xY45GFJd75o+5Cpzc
         Dl2Nf3h95oWYwIgwsRbHRJ+LseMqg56HvfNMLbjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 300/355] dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro
Date:   Mon, 15 Nov 2021 18:03:44 +0100
Message-Id: <20211115165323.420799756@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 320c88a3104dc955f928a1eecebd551ff89530c0 ]

AT_XDMAC_CC_PERID() should be used to setup bits 24..30 of XDMAC_CC
register. Using it without parenthesis around 0x7f & (i) will lead to
setting all the time zero for bits 24..30 of XDMAC_CC as the << operator
has higher precedence over bitwise &. Thus, add paranthesis around
0x7f & (i).

Fixes: 15a03850ab8f ("dmaengine: at_xdmac: fix macro typo")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211007111230.2331837-3-claudiu.beznea@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index b58ac720d9a12..6f1e97ba3e786 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -145,7 +145,7 @@
 #define		AT_XDMAC_CC_WRIP	(0x1 << 23)	/* Write in Progress (read only) */
 #define			AT_XDMAC_CC_WRIP_DONE		(0x0 << 23)
 #define			AT_XDMAC_CC_WRIP_IN_PROGRESS	(0x1 << 23)
-#define		AT_XDMAC_CC_PERID(i)	(0x7f & (i) << 24)	/* Channel Peripheral Identifier */
+#define		AT_XDMAC_CC_PERID(i)	((0x7f & (i)) << 24)	/* Channel Peripheral Identifier */
 #define AT_XDMAC_CDS_MSP	0x2C	/* Channel Data Stride Memory Set Pattern */
 #define AT_XDMAC_CSUS		0x30	/* Channel Source Microblock Stride */
 #define AT_XDMAC_CDUS		0x34	/* Channel Destination Microblock Stride */
-- 
2.33.0



