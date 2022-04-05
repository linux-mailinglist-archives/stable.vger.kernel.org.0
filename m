Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CB84F3195
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244860AbiDEJLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244654AbiDEIwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD4BD64D2;
        Tue,  5 Apr 2022 01:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21154B81BBF;
        Tue,  5 Apr 2022 08:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6589FC385A1;
        Tue,  5 Apr 2022 08:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148099;
        bh=aR1A0SezXpkQGZdReRE0MJZ9Tozm4kPC8Waf9Ta+wng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9XwKHmlVcpbN0kJK2OS1GMPLbZOldeBs0E2ROYLcDvUkN7uY/jYg1VrqYN0FbFCP
         aJnp6tzEYS2r0ZhkEfKx4cH/W243ZIrZnwdH1lgFfWWTxzG9jYokGOQrrH5I9n4+JP
         BH9AJHaBqP7Ujy6Ktr6aaUXNoL8nncdhx13hdJgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0235/1017] hwrng: atmel - disable trng on failure path
Date:   Tue,  5 Apr 2022 09:19:08 +0200
Message-Id: <20220405070401.232855681@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit a223ea9f89ab960eb254ba78429efd42eaf845eb ]

Call atmel_trng_disable() on failure path of probe.

Fixes: a1fa98d8116f ("hwrng: atmel - disable TRNG during suspend")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/atmel-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index ecb71c4317a5..8cf0ef501341 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -114,6 +114,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
 
 err_register:
 	clk_disable_unprepare(trng->clk);
+	atmel_trng_disable(trng);
 	return ret;
 }
 
-- 
2.34.1



