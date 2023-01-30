Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D25681325
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbjA3O2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbjA3O2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536CA40BFE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97319CE16AA
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F21FC433D2;
        Mon, 30 Jan 2023 14:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088815;
        bh=PTAN08f624d61xpyE0rHVMlxXktCuUz+QiffyKAkUKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWY2XjCsBpN7jATjFfPFIohtB7xkxl5roR67QpwHwJtAjAgTZNEydtXoOQZj4lSQG
         M6i96ZY6GX8xBByxTD0Y7PsUS3CmdSLOQrcvHizkkwjjwf/9FRH4ugrUB6KBMrmobg
         4srUB+VCf/3nk5g85Oopg2yzZoiF+FLwgK607mHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 143/143] clk: Fix pointer casting to prevent oops in devm_clk_release()
Date:   Mon, 30 Jan 2023 14:53:20 +0100
Message-Id: <20230130134312.771064196@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 8b3d743fc9e2542822826890b482afabf0e7522a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -11,7 +11,7 @@ struct devm_clk_state {
 
 static void devm_clk_release(struct device *dev, void *res)
 {
-	struct devm_clk_state *state = *(struct devm_clk_state **)res;
+	struct devm_clk_state *state = res;
 
 	if (state->exit)
 		state->exit(state->clk);


