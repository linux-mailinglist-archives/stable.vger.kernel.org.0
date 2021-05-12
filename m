Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B043637C555
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhELPji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234567AbhELPdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:33:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35B6A61166;
        Wed, 12 May 2021 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832617;
        bh=Mh1CjhzMOAedYmFFKli7reS70OHNVUIm2gJXJe6rLYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oF9WPp/PqpVe69s729sK1F+TP5QZZDXsFARzpWzuNjpUDOUEcPOx22GK18Ic5+8kX
         iHao+gDW/WJg+DVn7OTQJpvRsZrRV29bT4SC7Vi5GLPGmF2lPzMGt+JywNrCReBvbo
         P7wiZYWWXg8vtV1D/aKX6BngUMFNedRlUWle2p9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/530] wilc1000: write value to WILC_INTR2_ENABLE register
Date:   Wed, 12 May 2021 16:47:43 +0200
Message-Id: <20210512144831.387964890@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit e21b6e5a54628cd3935f200049d4430c25c54e03 ]

Write the value instead of reading it twice.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210224163706.519658-1-marcus.folkesson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 351ff909ab1c..e14b9fc2c67a 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -947,7 +947,7 @@ static int wilc_sdio_sync_ext(struct wilc *wilc, int nint)
 			for (i = 0; (i < 3) && (nint > 0); i++, nint--)
 				reg |= BIT(i);
 
-			ret = wilc_sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
+			ret = wilc_sdio_write_reg(wilc, WILC_INTR2_ENABLE, reg);
 			if (ret) {
 				dev_err(&func->dev,
 					"Failed write reg (%08x)...\n",
-- 
2.30.2



