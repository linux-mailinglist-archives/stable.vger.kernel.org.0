Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066604A4564
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349765AbiAaLkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376792AbiAaLg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:36:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DADC0401FC;
        Mon, 31 Jan 2022 03:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05570B82A71;
        Mon, 31 Jan 2022 11:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45041C340E8;
        Mon, 31 Jan 2022 11:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628287;
        bh=iawvoDM2oJeS8vpvOWXHjDaMvstzoHp2Ce2rUhh93CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eb65DwBneVfP6uHC1jGiOCqbdb4/N37ZnGpE9tmvb1oI27EjqTU/VlMOUmtDV7occ
         2RM/boZu8txy+DYAPE93RfbAWRtM2mDRoWgr9j/+O7znyNgmUxj+fF+jgfNIE73Lcs
         d2wSVsyCt9KE6lN4CILPTrq2ol2yuFKnGSDsIZ9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 167/200] can: tcan4x5x: regmap: fix max register value
Date:   Mon, 31 Jan 2022 11:57:10 +0100
Message-Id: <20220131105239.166992994@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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



