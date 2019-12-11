Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE9911B065
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbfLKPWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732341AbfLKPWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587282073D;
        Wed, 11 Dec 2019 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077742;
        bh=tzIPCF9pfUrDbeXaCi6SR3s/T/FPApjCla/bYMttqQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHRleAXA+7cQ5E31Ntu2v3OxYl797+gMUwhjVng2ZGfdrq+QZHIFu73NaziTBZ2V7
         8OR00CZiS2+AfUM01fziI2+geshUJ/uENaG1bpJNjm4kPB6RTAaLuB1zjvIPYJe/2A
         vqWIuFwkBhCNr8YyWuiB3GHC/7e324E1EfljHx7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/243] clk: meson: Fix GXL HDMI PLL fractional bits width
Date:   Wed, 11 Dec 2019 16:04:38 +0100
Message-Id: <20191211150346.963397995@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 21310c39ec01e82ef3ef9bf8ac385b53ccdc158c ]

The GXL Documentation specifies 12 bits for the Fractional bit field,
bit the last bits have a different purpose that we cannot handle right
now, so update the bitwidth to have correct fractional calculations.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
[narmstrong: added comment on GXL HHI_HDMI_PLL_CNTL register shift]
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lkml.kernel.org/r/20181121111922.1277-1-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/gxbb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/meson/gxbb.c b/drivers/clk/meson/gxbb.c
index d94b65061b9f1..b039909e03cf8 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -295,6 +295,12 @@ static struct clk_regmap gxl_hdmi_pll = {
 			.shift   = 9,
 			.width   = 5,
 		},
+		/*
+		 * On gxl, there is a register shift due to
+		 * HHI_HDMI_PLL_CNTL1 which does not exist on gxbb,
+		 * so we use the HHI_HDMI_PLL_CNTL2 define from GXBB
+		 * instead which is defined at the same offset.
+		 */
 		.frac = {
 			/*
 			 * On gxl, there is a register shift due to
@@ -304,7 +310,7 @@ static struct clk_regmap gxl_hdmi_pll = {
 			 */
 			.reg_off = HHI_HDMI_PLL_CNTL + 4,
 			.shift   = 0,
-			.width   = 12,
+			.width   = 10,
 		},
 		.od = {
 			.reg_off = HHI_HDMI_PLL_CNTL + 8,
-- 
2.20.1



