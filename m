Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347CA2E3E05
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502729AbgL1OWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502725AbgL1OWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A52E1206D4;
        Mon, 28 Dec 2020 14:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165350;
        bh=iCaYDlAzEiBveYoobdPRUO9FaEYrf3eoqc+1e4iMvio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ck3ENNdRhzZNjzKmluFtFjevlD9ge77PuVar3ra1oOWAIiDINTUeaYnd1z/7Gscca
         EfrDi1TxoEd3k8+s7WaAAebS6vSxSb+5Yjppftj0mQE0mMybeDWUFpuKbHVUvoTBxo
         9LDEHGbc7tyk7putceLbDbD6ad5blcHr4f8PfJfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 499/717] clk: vc5: Use "idt,voltage-microvolt" instead of "idt,voltage-microvolts"
Date:   Mon, 28 Dec 2020 13:48:17 +0100
Message-Id: <20201228125044.870388370@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4b003f5fcadfa2d0e087e907b0c65d023f6e29fb ]

Commit 45c940184b501fc6 ("dt-bindings: clk: versaclock5: convert to
yaml") accidentally changed "idt,voltage-microvolts" to
"idt,voltage-microvolt" in the DT bindings, while the driver still used
the former.

Update the driver to match the bindings, as
Documentation/devicetree/bindings/property-units.txt actually recommends
using "microvolt".

Fixes: 260249f929e81d3d ("clk: vc5: Enable addition output configurations of the Versaclock")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20201218125253.3815567-1-geert+renesas@glider.be
Reviewed-by: Luca Ceresoli <luca@lucaceresoli.net>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-versaclock5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-versaclock5.c b/drivers/clk/clk-versaclock5.c
index c90460e7ef215..43db67337bc06 100644
--- a/drivers/clk/clk-versaclock5.c
+++ b/drivers/clk/clk-versaclock5.c
@@ -739,8 +739,8 @@ static int vc5_update_power(struct device_node *np_output,
 {
 	u32 value;
 
-	if (!of_property_read_u32(np_output,
-				  "idt,voltage-microvolts", &value)) {
+	if (!of_property_read_u32(np_output, "idt,voltage-microvolt",
+				  &value)) {
 		clk_out->clk_output_cfg0_mask |= VC5_CLK_OUTPUT_CFG0_PWR_MASK;
 		switch (value) {
 		case 1800000:
-- 
2.27.0



