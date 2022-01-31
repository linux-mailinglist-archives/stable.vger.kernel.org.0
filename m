Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1AD4A43D0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376839AbiAaLYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378715AbiAaLUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1E5C0698FC;
        Mon, 31 Jan 2022 03:13:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93646B82A72;
        Mon, 31 Jan 2022 11:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37BAC340E8;
        Mon, 31 Jan 2022 11:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627617;
        bh=iawvoDM2oJeS8vpvOWXHjDaMvstzoHp2Ce2rUhh93CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wE2rzTnk1guY38j6Qs3eDIy0dQQu5aY+yDGoMCNOyPKDRfIXL4NMCeNF8hiUGlLcY
         /qwylg3JD0TfE0xPc79UwO+fo8ri8f1n+JPXEFqPLftNCC9LP3hSq1MMKwALBnrSBe
         Za5e/vkFGOx2BywDL6Oo7p0e6QVlNbATyVNoNndM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/171] can: tcan4x5x: regmap: fix max register value
Date:   Mon, 31 Jan 2022 11:56:48 +0100
Message-Id: <20220131105234.844852540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit e59986de5ff701494e14c722b78b6e6d513e0ab5 ]

The MRAM of the tcan4x5x has a size of 2K and starts at 0x8000. There
are no further registers in the tcan4x5x making 0x87fc the biggest
addressable register.

This patch fixes the max register value of the regmap config from
0x8ffc to 0x87fc.

Fixes: 6e1caaf8ed22 ("can: tcan4x5x: fix max register value")
Link: https://lore.kernel.org/all/20220119064011.2943292-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index ca80dbaf7a3f5..26e212b8ca7a6 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -12,7 +12,7 @@
 #define TCAN4X5X_SPI_INSTRUCTION_WRITE (0x61 << 24)
 #define TCAN4X5X_SPI_INSTRUCTION_READ (0x41 << 24)
 
-#define TCAN4X5X_MAX_REGISTER 0x8ffc
+#define TCAN4X5X_MAX_REGISTER 0x87fc
 
 static int tcan4x5x_regmap_gather_write(void *context,
 					const void *reg, size_t reg_len,
-- 
2.34.1



