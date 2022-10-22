Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CD3608C4B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiJVLHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiJVLHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:07:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBBF197F95;
        Sat, 22 Oct 2022 03:25:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ADA83CE2CAE;
        Sat, 22 Oct 2022 07:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A63C433C1;
        Sat, 22 Oct 2022 07:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425375;
        bh=j+D3BSRw6K3WPL1upC13NhG7/06VKOHGGwiFpM2s2cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZLqlskJat8RcPHh7+IdsMPLV874xZ99avmrGX9Z3LynOlAtcevOSINhBqPTRftDA
         W9zxKwxuZuH7yDRZ/NE4k/T2qVRPA+03uFDTvd/yAAe+G+imZrZGjrVZvq5RknWhjF
         VSWFqK0Q7r+qJnk2eIacCaHaYtnVujZb8I9jCynw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 480/717] clk: vc5: Fix 5P49V6901 outputs disabling when enabling FOD
Date:   Sat, 22 Oct 2022 09:25:59 +0200
Message-Id: <20221022072519.598997780@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit c388cc804016cf0f65afdc2362b120aa594ff3e6 ]

We have discovered random glitches during the system boot up procedure.
The problem investigation led us to the weird outcomes: when none of the
Renesas 5P49V6901 ports are explicitly enabled by the kernel driver, the
glitches disappeared. It was a mystery since the SoC external clock
domains were fed with different 5P49V6901 outputs. The driver code didn't
seem like bogus either. We almost despaired to find out a root cause when
the solution has been found for a more modern revision of the chip. It
turned out the 5P49V6901 clock generator stopped its output for a short
period of time during the VC5_OUT_DIV_CONTROL register writing. The same
problem was found for the 5P49V6965 revision of the chip and was
successfully fixed in commit fc336ae622df ("clk: vc5: fix output disabling
when enabling a FOD") by enabling the "bypass_sync" flag hidden inside
"Unused Factory Reserved Register". Even though the 5P49V6901 registers
description and programming guide doesn't provide any intel regarding that
flag, setting it up anyway in the officially unused register completely
eliminated the denoted glitches. Thus let's activate the functionality
submitted in commit fc336ae622df ("clk: vc5: fix output disabling when
enabling a FOD") for the Renesas 5P49V6901 chip too in order to remove the
ports implicit inter-dependency.

Fixes: dbf6b16f5683 ("clk: vc5: Add support for IDT VersaClock 5P49V6901")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Luca Ceresoli <luca@lucaceresoli.net>
Link: https://lore.kernel.org/r/20220929225402.9696-2-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-versaclock5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-versaclock5.c b/drivers/clk/clk-versaclock5.c
index e7be3e54b9be..03cfef494b49 100644
--- a/drivers/clk/clk-versaclock5.c
+++ b/drivers/clk/clk-versaclock5.c
@@ -1204,7 +1204,7 @@ static const struct vc5_chip_info idt_5p49v6901_info = {
 	.model = IDT_VC6_5P49V6901,
 	.clk_fod_cnt = 4,
 	.clk_out_cnt = 5,
-	.flags = VC5_HAS_PFD_FREQ_DBL,
+	.flags = VC5_HAS_PFD_FREQ_DBL | VC5_HAS_BYPASS_SYNC_BIT,
 };
 
 static const struct vc5_chip_info idt_5p49v6965_info = {
-- 
2.35.1



