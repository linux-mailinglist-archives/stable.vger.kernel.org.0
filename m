Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031D455DB43
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243530AbiF1CV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243529AbiF1CVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C65237D9;
        Mon, 27 Jun 2022 19:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F616617BC;
        Tue, 28 Jun 2022 02:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BE8C341CC;
        Tue, 28 Jun 2022 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382822;
        bh=fsCtIVhV2ef0xHT+nArdUMGg/mCyQ7k6RoDeoHr3e6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+71hMAkX7nOSSGoMEcDyw639f7q87wCDIX3B45yKw2t6kCCdSG3BxkyLSMU61Whn
         bdW4Spke2oQ16ypM9y1Cw0ia2Hy9aIsC6aQWeuEDOE2e9a3GL/btO+J7It6CdGALTy
         EnFYmz+MSibYNk/AXDpoCIO2da/6rdg3um/bi6mRuX5+aVCe8TuPYoMIPveA2aUlPx
         OMU979vQnUK/nbDDsKq29wtVB5C11DzpZ100WEfum8Lm4q+rNhMjCGZ6WbCljE7YxZ
         Ml9CWTp4CDcCJS/6eSRfRK1Ia0dqEPclOB3sZGE/WiQ2Ehahv5f7QEK4e96QJJmPWV
         63OlPTOHZsYxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, miodrag.dinic@mips.com,
        paulburton@kernel.org, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 39/53] arch: mips: generic: Add missing of_node_put() in board-ranchu.c
Date:   Mon, 27 Jun 2022 22:18:25 -0400
Message-Id: <20220628021839.594423-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 4becf6417bbdc293734a590fe4ed38437bbcea2c ]

In ranchu_measure_hpt_freq(), of_find_compatible_node() will return
a node pointer with refcount incremented. We should use of_put_node()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/generic/board-ranchu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/generic/board-ranchu.c b/arch/mips/generic/board-ranchu.c
index a89aaad59cb1..930c45041882 100644
--- a/arch/mips/generic/board-ranchu.c
+++ b/arch/mips/generic/board-ranchu.c
@@ -44,6 +44,7 @@ static __init unsigned int ranchu_measure_hpt_freq(void)
 		      __func__);
 
 	rtc_base = of_iomap(np, 0);
+	of_node_put(np);
 	if (!rtc_base)
 		panic("%s(): Failed to ioremap Goldfish RTC base!", __func__);
 
-- 
2.35.1

