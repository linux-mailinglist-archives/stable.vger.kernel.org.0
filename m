Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656154F3B4E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348256AbiDELwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357235AbiDEKZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:25:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5485C27B36;
        Tue,  5 Apr 2022 03:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0647B81C8A;
        Tue,  5 Apr 2022 10:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B37C385A1;
        Tue,  5 Apr 2022 10:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153386;
        bh=sVR33FUtTlVIApPJsjKgr9pJZo5UOvcNrviZQ+t5OWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLPq974f1ExBEQUMtBI2jirpyJD1RM8xn9eLbEEsyXun0nagWifOcGJCgMKc06t7U
         7cnxaZ7KdsOY7piuDqOH3B1X5XIu5umKd2j+6IDKrcxFBKb6rvJc9cDmRfk1LySnEg
         G8Fj/SCzLZjyCUIVsRTQ1ls95w4oK7/wy+bMTww0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/599] hwrng: nomadik - Change clk_disable to clk_disable_unprepare
Date:   Tue,  5 Apr 2022 09:27:40 +0200
Message-Id: <20220405070303.782754804@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7f0f1f3ef62ed7a40e30aff28115bd94c4211d1d ]

The corresponding API for clk_prepare_enable is clk_disable_unprepare,
other than clk_disable_unprepare.

Fix this by changing clk_disable to clk_disable_unprepare.

Fixes: beca35d05cc2 ("hwrng: nomadik - use clk_prepare_enable()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/nomadik-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
index 67947a19aa22..e8f9621e7954 100644
--- a/drivers/char/hw_random/nomadik-rng.c
+++ b/drivers/char/hw_random/nomadik-rng.c
@@ -65,14 +65,14 @@ static int nmk_rng_probe(struct amba_device *dev, const struct amba_id *id)
 out_release:
 	amba_release_regions(dev);
 out_clk:
-	clk_disable(rng_clk);
+	clk_disable_unprepare(rng_clk);
 	return ret;
 }
 
 static void nmk_rng_remove(struct amba_device *dev)
 {
 	amba_release_regions(dev);
-	clk_disable(rng_clk);
+	clk_disable_unprepare(rng_clk);
 }
 
 static const struct amba_id nmk_rng_ids[] = {
-- 
2.34.1



