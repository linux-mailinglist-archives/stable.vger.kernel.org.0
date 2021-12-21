Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B32647B760
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhLUB7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbhLUB7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:59:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50FFC061373;
        Mon, 20 Dec 2021 17:58:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2625B81110;
        Tue, 21 Dec 2021 01:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2302AC36AE9;
        Tue, 21 Dec 2021 01:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051934;
        bh=Afu9l4w/gvyA5c/feIE1na4rvdsZEWsBjcE5lry7ZvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gK3KyxNY6yRzPPLOdD4vIvdSZRYfTLtJ3/LXLDtghEXSBtpnb7PVTKvNTfruuAh+r
         Hhb8gdMAtOUqQI6gEATZcSinOP9F2PhQXEe8R9KfQnHg81j8VrY8a52Ui7o6NFatfN
         9rPW2LF7bxEGMP8rBmGmgzqmQ+YBIQPHISCKn4l8DZDFNXiPeWKAlMJAZ9Sigjk9TC
         FN5UGqCr10EyKJI/oRpPTdNe8OzHNuG3eUvoQ8QRL/8OpP2M8hRIZNCvWCjqTU/BTd
         KY+Vm87Q+TjybJd3EzO9nXU7RP13b7x4w86tStD97W6bVruxlh12+jKziMiDSZ8yL5
         wzzXwVCkF1L9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Pelletier <plr.vincent@gmail.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, qiuwenbo@kylinos.com.cn,
        yash.shah@sifive.com, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 25/29] riscv: dts: sifive unmatched: Expose the board ID eeprom
Date:   Mon, 20 Dec 2021 20:57:46 -0500
Message-Id: <20211221015751.116328-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Pelletier <plr.vincent@gmail.com>

[ Upstream commit 8120393b74b31bbaf293f59896de6b0d50febc48 ]

Mark it as read-only as it is factory-programmed with identifying
information, and no executable nor configuration:
- eth MAC address
- board model (PCB version, BoM version)
- board serial number
Accidental modification would cause misidentification which could brick
the board, so marking read-only seem like both a safe and non-constraining
choice.

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
index a788b99638af8..7ea1c8da5fb2e 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
@@ -63,6 +63,16 @@ temperature-sensor@4c {
 		interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
 	};
 
+	eeprom@54 {
+		compatible = "microchip,24c02", "atmel,24c02";
+		reg = <0x54>;
+		vcc-supply = <&vdd_bpro>;
+		label = "board-id";
+		pagesize = <16>;
+		read-only;
+		size = <256>;
+	};
+
 	pmic@58 {
 		compatible = "dlg,da9063";
 		reg = <0x58>;
-- 
2.34.1

