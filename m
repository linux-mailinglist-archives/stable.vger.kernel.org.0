Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CECE4F3139
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350419AbiDEJ6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343988AbiDEJQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7ADBF40;
        Tue,  5 Apr 2022 02:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE604614E4;
        Tue,  5 Apr 2022 09:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E73C385A0;
        Tue,  5 Apr 2022 09:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149357;
        bh=fb9efia5mVrZlJD4idK/NLmTQmEyTQOi7uyPx6MOOJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLM7qxPA5Yxk6Sg9yNZ6wSQIAYE4CIfB271mJGmfBVdX4HE46G9fCF5zpKFKG02DG
         2fAsCxs4c6q4o9fP4P5fi8gbmVpU0SlQKJ/OnETIMMAXgXfmmSamDYkVE9RDW/Mc9N
         4E1da/NZa4ZgkqGkfBJk5XKg88bPyiDV6fr/baTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0686/1017] clk: hisilicon: Terminate clk_div_table with sentinel element
Date:   Tue,  5 Apr 2022 09:26:39 +0200
Message-Id: <20220405070414.639927189@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit 113b261bdf2b4fd34e7769a147a7acd0a4d9137f ]

In order that the end of a clk_div_table can be detected, it must be
terminated with a sentinel element (.div = 0).

Fixes: 6c81966107dc0 ("clk: hisilicon: Add clock driver for hi3559A SoC")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Link: https://lore.kernel.org/r/20220218000922.134857-4-j.neuschaefer@gmx.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/clk-hi3559a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/hisilicon/clk-hi3559a.c b/drivers/clk/hisilicon/clk-hi3559a.c
index 56012a3d0219..9ea1a80acbe8 100644
--- a/drivers/clk/hisilicon/clk-hi3559a.c
+++ b/drivers/clk/hisilicon/clk-hi3559a.c
@@ -611,8 +611,8 @@ static struct hisi_mux_clock hi3559av100_shub_mux_clks[] = {
 
 
 /* shub div clk */
-static struct clk_div_table shub_spi_clk_table[] = {{0, 8}, {1, 4}, {2, 2}};
-static struct clk_div_table shub_uart_div_clk_table[] = {{1, 8}, {2, 4}};
+static struct clk_div_table shub_spi_clk_table[] = {{0, 8}, {1, 4}, {2, 2}, {/*sentinel*/}};
+static struct clk_div_table shub_uart_div_clk_table[] = {{1, 8}, {2, 4}, {/*sentinel*/}};
 
 static struct hisi_divider_clock hi3559av100_shub_div_clks[] = {
 	{ HI3559AV100_SHUB_SPI_SOURCE_CLK, "clk_spi_clk", "shub_clk", 0, 0x20, 24, 2,
-- 
2.34.1



