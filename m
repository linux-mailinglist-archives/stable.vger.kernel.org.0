Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9E45BBDE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244549AbhKXMY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:24:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243997AbhKXMWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:22:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F2D4611C9;
        Wed, 24 Nov 2021 12:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756006;
        bh=nYCtE5+NQ35onNhDfGKFucckRAFjzNzXecm8ge5NkXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hsrb+UrW/nDYWbaJgs/uJkjR4lWydLOO+guuLiYc6nmzPwlcWP3yKhgIVije8Orsi
         UMg1Crfqs0B4fRfn6QzzWOpOtV48aE2veKOhEn3+3s2hw3yV8SMC2kY30YHvkSjlgz
         lJl9/6JM/+7H0l+6IcO4hJtDCGaNlx62JnVMDyj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 136/207] dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro
Date:   Wed, 24 Nov 2021 12:56:47 +0100
Message-Id: <20211124115708.433606971@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
index 12d9048293245..a505be9ef96da 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -156,7 +156,7 @@
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



