Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0378664A0C6
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiLLNaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiLLNaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:30:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89003BED
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 386A1B80D52
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231D0C433D2;
        Mon, 12 Dec 2022 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851818;
        bh=h43qkf0rKfY5QTvcqTT+0K5WneF+XEtifReMEzQkUTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSJYZ5569FT0YcVjUS+LlAOelelNcrx+FK7h2s8K9IiPu8mlXgZn8xZcF1ZUVzRRv
         OF77X7+KUiqxVQaHJ5RfjiIJTAhgoPqo0S94bAusVwC0mWPCqmTEHH2u+Mf9GTNsIs
         WYiX5UrBsgNFMrrj7Rrf+fVBqxrhWF3MA05gtBP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/123] clk: Fix pointer casting to prevent oops in devm_clk_release()
Date:   Mon, 12 Dec 2022 14:17:05 +0100
Message-Id: <20221212130929.409587991@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 8b3d743fc9e2542822826890b482afabf0e7522a ]

The release function is called with a pointer to the memory returned by
devres_alloc(). I was confused about that by the code before the
generalization that used a struct clk **ptr.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: abae8e57e49a ("clk: generalize devm_clk_get() a bit")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20220620171815.114212-1-u.kleine-koenig@pengutronix.de
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-devres.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index 43ccd20e0298..4fb4fd4b06bd 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -11,7 +11,7 @@ struct devm_clk_state {
 
 static void devm_clk_release(struct device *dev, void *res)
 {
-	struct devm_clk_state *state = *(struct devm_clk_state **)res;
+	struct devm_clk_state *state = res;
 
 	if (state->exit)
 		state->exit(state->clk);
-- 
2.35.1



