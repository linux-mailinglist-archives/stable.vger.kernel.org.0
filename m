Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5297B3C4A65
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbhGLGwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237726AbhGLGs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B93961107;
        Mon, 12 Jul 2021 06:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072271;
        bh=wmT3ghuA3heAMB5MQWTYOkchAIJ2Ua+6fwqtLY6D6jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mM4e64OXHDxorY+1e41Jwi2gA8JCtyzFMC4HwYyHlG4Xheyri2iei14Rzxwo7OwG7
         y1COm+dxN3kvcvMGG452LGVpVpAyOZz7Jn/O2hLWMZ1kuHZjsCgePAu2miUzm3jumf
         vzF3WViGMqMZg/j9V9UAbUO7XEXgRUHvdnB+WTn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/593] clk: si5341: Update initialization magic
Date:   Mon, 12 Jul 2021 08:09:45 +0200
Message-Id: <20210712060935.096668266@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 3c9b49b0031aefb81adfdba5ab0ddf3ca3a2cdc9 ]

Update the default register settings to include the VCO_RESET_CALCODE
settings (set by the SiLabs ClockBuilder software but not described in
the datasheet). Also update part of the initialization sequence to match
ClockBuilder and the datasheet.

Fixes: 3044a860fd ("clk: Add Si5341/Si5340 driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20210325192643.2190069-6-robert.hancock@calian.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index da40b90c2aa8..eb22f4fdbc6b 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -350,6 +350,8 @@ static const struct si5341_reg_default si5341_reg_defaults[] = {
 	{ 0x094A, 0x00 }, /* INx_TO_PFD_EN (disabled) */
 	{ 0x0A02, 0x00 }, /* Not in datasheet */
 	{ 0x0B44, 0x0F }, /* PDIV_ENB (datasheet does not mention what it is) */
+	{ 0x0B57, 0x10 }, /* VCO_RESET_CALCODE (not described in datasheet) */
+	{ 0x0B58, 0x05 }, /* VCO_RESET_CALCODE (not described in datasheet) */
 };
 
 /* Read and interpret a 44-bit followed by a 32-bit value in the regmap */
@@ -1104,7 +1106,7 @@ static const struct si5341_reg_default si5341_preamble[] = {
 	{ 0x0B25, 0x00 },
 	{ 0x0502, 0x01 },
 	{ 0x0505, 0x03 },
-	{ 0x0957, 0x1F },
+	{ 0x0957, 0x17 },
 	{ 0x0B4E, 0x1A },
 };
 
-- 
2.30.2



