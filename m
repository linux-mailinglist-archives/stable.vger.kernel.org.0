Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92296896BE
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbjBCKcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjBCKan (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1606D1557A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CD30B82A65
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D114EC433EF;
        Fri,  3 Feb 2023 10:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420183;
        bh=PTAN08f624d61xpyE0rHVMlxXktCuUz+QiffyKAkUKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Loo5mYyE8BSiy7hyqbdm5bQ1utAo1bXa1GalQwp5WPQKzZr3/EiAAhOWx7hCIaiUS
         qas0sAsTMS94H1ObDuoo+F3PCAqrZIvgDsmbe859Zi/sOGWOzccy7CjM8SEJFOq77/
         lE3vVpx8qnTCrsZWKMFkfh6d7yjhekRbtg759GOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 108/134] clk: Fix pointer casting to prevent oops in devm_clk_release()
Date:   Fri,  3 Feb 2023 11:13:33 +0100
Message-Id: <20230203101028.680984232@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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


