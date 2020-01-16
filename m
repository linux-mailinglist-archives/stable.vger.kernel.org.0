Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89EB113E0E3
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgAPQqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbgAPQqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:46:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5192081E;
        Thu, 16 Jan 2020 16:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193176;
        bh=YmxviQcphLBR8NzYcPvIJ0lX4oXrzkF5P80tAiVe/KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RwXK2fXEr3SYtdQ9PxPW9iX9hUypyW8L+myzThA8yKgw9fH5IQEg3OD2jK+MAtg5
         QMygQAXuNTvLweR6CKTmsWFlwMu305MgVdsQfCRCZWCteNuWZarDrHWSyX5IMTH7we
         8fHherEr3Zrgvrz0M9Sv94zSNqgWsGoyA/UrUGlY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keiya Nobuta <nobuta.keiya@fujitsu.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 040/205] pinctrl: sh-pfc: Fix PINMUX_IPSR_PHYS() to set GPSR
Date:   Thu, 16 Jan 2020 11:40:15 -0500
Message-Id: <20200116164300.6705-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keiya Nobuta <nobuta.keiya@fujitsu.com>

[ Upstream commit d30710b8cce3a581c170d69002e311cc18ed47d3 ]

This patch allows PINMUX_IPSR_PHYS() to set bits in GPSR.
When assigning function to pin, GPSR should be set to peripheral
function.
For example when using SCL3, GPSR2 bit7 (PWM1_A pin) should be set to
peripheral function.

Signed-off-by: Keiya Nobuta <nobuta.keiya@fujitsu.com>
Link: https://lore.kernel.org/r/20191008060112.29819-1-nobuta.keiya@fujitsu.com
Fixes: 50d1ba1764b3e00a ("pinctrl: sh-pfc: Add physical pin multiplexing helper macros")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/sh_pfc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/sh_pfc.h b/drivers/pinctrl/sh-pfc/sh_pfc.h
index 835148fc0f28..cab7da130925 100644
--- a/drivers/pinctrl/sh-pfc/sh_pfc.h
+++ b/drivers/pinctrl/sh-pfc/sh_pfc.h
@@ -422,12 +422,12 @@ extern const struct sh_pfc_soc_info shx3_pinmux_info;
 /*
  * Describe a pinmux configuration in which a pin is physically multiplexed
  * with other pins.
- *   - ipsr: IPSR field (unused, for documentation purposes only)
+ *   - ipsr: IPSR field
  *   - fn: Function name
  *   - psel: Physical multiplexing selector
  */
 #define PINMUX_IPSR_PHYS(ipsr, fn, psel) \
-	PINMUX_DATA(fn##_MARK, FN_##psel)
+	PINMUX_DATA(fn##_MARK, FN_##psel, FN_##ipsr)
 
 /*
  * Describe a pinmux configuration for a single-function pin with GPIO
-- 
2.20.1

