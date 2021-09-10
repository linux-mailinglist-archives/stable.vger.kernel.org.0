Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710944061CB
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241228AbhIJAnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233158AbhIJATd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 349676023D;
        Fri, 10 Sep 2021 00:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233103;
        bh=CCPc2KEfzyYjN6SZpmpoAA91vT3aw1WWkavUzpxYK28=;
        h=From:To:Cc:Subject:Date:From;
        b=FpugKfpfF57vYlpXUwGI6PFs9Ny87ntuVIf2VWrW0u8uaxvkamQDev+USNZRsiZBu
         QEn8kG7aSiGWb1DoCGsCN2f3DGT9jIKgB5EOOUlMgDz4llydzBi+VOgYit4AZLAdhf
         31v3ufxCrf5CfLLbiAXvPK4XEpe+0xD67jmCy/veK2UmSE1z+Ssjz848Dqei7KbevR
         vOZqE/UUFlhFlG8YcqkBgDEs8/N+oIENM3OD9Olf/kohup2vESotbuTNYNXjNLYNdN
         b83HPFzQEEQMzAPDs02NP8kXJKTIOB0CyYw/gqgv18XuziyBmw2P+7CmavG0QUEzvC
         1tmWuwv+OX4qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 01/88] pinctrl: renesas: rcar: Avoid changing PUDn when disabling bias
Date:   Thu,  9 Sep 2021 20:16:53 -0400
Message-Id: <20210910001820.174272-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7ebaa41047738d46fca6376b3f1765ef69c463c5 ]

When disabling pin bias, there is no need to touch the LSI pin
pull-up/down control register (PUDn), which selects between pull-up and
pull-down.  Just disabling the pull-up/down function through the LSI pin
pull-enable register (PUENn) is sufficient.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/071ec644de2555da593a4531ef5d3e4d79cf997d.1625064076.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl.c b/drivers/pinctrl/renesas/pinctrl.c
index bb488af29862..85cb78cfcfa6 100644
--- a/drivers/pinctrl/renesas/pinctrl.c
+++ b/drivers/pinctrl/renesas/pinctrl.c
@@ -898,17 +898,17 @@ void rcar_pinmux_set_bias(struct sh_pfc *pfc, unsigned int pin,
 
 	if (reg->puen) {
 		enable = sh_pfc_read(pfc, reg->puen) & ~BIT(bit);
-		if (bias != PIN_CONFIG_BIAS_DISABLE)
+		if (bias != PIN_CONFIG_BIAS_DISABLE) {
 			enable |= BIT(bit);
 
-		if (reg->pud) {
-			updown = sh_pfc_read(pfc, reg->pud) & ~BIT(bit);
-			if (bias == PIN_CONFIG_BIAS_PULL_UP)
-				updown |= BIT(bit);
+			if (reg->pud) {
+				updown = sh_pfc_read(pfc, reg->pud) & ~BIT(bit);
+				if (bias == PIN_CONFIG_BIAS_PULL_UP)
+					updown |= BIT(bit);
 
-			sh_pfc_write(pfc, reg->pud, updown);
+				sh_pfc_write(pfc, reg->pud, updown);
+			}
 		}
-
 		sh_pfc_write(pfc, reg->puen, enable);
 	} else {
 		enable = sh_pfc_read(pfc, reg->pud) & ~BIT(bit);
-- 
2.30.2

