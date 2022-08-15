Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6781F59384B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245625AbiHOTHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiHOTGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:06:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB43BE6;
        Mon, 15 Aug 2022 11:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D8C61019;
        Mon, 15 Aug 2022 18:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C12EC433C1;
        Mon, 15 Aug 2022 18:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588519;
        bh=hVpoeMwUvpglwrk2FaC7xACVbQKklXD3rXGWF/M7v7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBBZF3XuroKftKrTO8M9lx8AtvO5KX4HEqm/xynFCDb2Z8Oyiruy0tDlU5mmIQLoW
         rS+B0e9hvpvQ/RZ2obkhhJurTPc1udAKaL+8EAp9O3EsSaeqQwnJFAbNjohzzAT8wz
         k6sWqaH7pSrCKzrhWYe6xRgF/1KY0FsGbmYlZe7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralph Siemsen <ralph.siemsen@linaro.org>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/779] clk: renesas: r9a06g032: Fix UART clkgrp bitsel
Date:   Mon, 15 Aug 2022 20:00:33 +0200
Message-Id: <20220815180353.921877745@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Siemsen <ralph.siemsen@linaro.org>

[ Upstream commit 2dee50ab9e72a3cae75b65e5934c8dd3e9bf01bc ]

There are two UART clock groups, each having a mux to select its
upstream clock source. The register/bit definitions for accessing these
two muxes appear to have been reversed since introduction. Correct them
so as to match the hardware manual.

Fixes: 4c3d88526eba ("clk: renesas: Renesas R9A06G032 clock driver")

Signed-off-by: Ralph Siemsen <ralph.siemsen@linaro.org>
Reviewed-by: Phil Edworthy <phil.edworthy@renesas.com>
Link: https://lore.kernel.org/r/20220518182527.1693156-1-ralph.siemsen@linaro.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a06g032-clocks.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/r9a06g032-clocks.c b/drivers/clk/renesas/r9a06g032-clocks.c
index c99942f0e4d4..abc0891fd96d 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -286,8 +286,8 @@ static const struct r9a06g032_clkdesc r9a06g032_clocks[] = {
 		.name = "uart_group_012",
 		.type = K_BITSEL,
 		.source = 1 + R9A06G032_DIV_UART,
-		/* R9A06G032_SYSCTRL_REG_PWRCTRL_PG1_PR2 */
-		.dual.sel = ((0xec / 4) << 5) | 24,
+		/* R9A06G032_SYSCTRL_REG_PWRCTRL_PG0_0 */
+		.dual.sel = ((0x34 / 4) << 5) | 30,
 		.dual.group = 0,
 	},
 	{
@@ -295,8 +295,8 @@ static const struct r9a06g032_clkdesc r9a06g032_clocks[] = {
 		.name = "uart_group_34567",
 		.type = K_BITSEL,
 		.source = 1 + R9A06G032_DIV_P2_PG,
-		/* R9A06G032_SYSCTRL_REG_PWRCTRL_PG0_0 */
-		.dual.sel = ((0x34 / 4) << 5) | 30,
+		/* R9A06G032_SYSCTRL_REG_PWRCTRL_PG1_PR2 */
+		.dual.sel = ((0xec / 4) << 5) | 24,
 		.dual.group = 1,
 	},
 	D_UGATE(CLK_UART0, "clk_uart0", UART_GROUP_012, 0, 0, 0x1b2, 0x1b3, 0x1b4, 0x1b5),
-- 
2.35.1



