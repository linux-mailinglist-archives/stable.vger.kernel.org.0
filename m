Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5FE5010B7
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344630AbiDNNtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343757AbiDNNjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764752F01B;
        Thu, 14 Apr 2022 06:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3C01CE29B3;
        Thu, 14 Apr 2022 13:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0489BC385A5;
        Thu, 14 Apr 2022 13:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943284;
        bh=knN+5Q7Xmx1iTi3Ru3PlZcbuiEyx86ubiS8hxYwuebs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNQSGgngj1OZqu3+ljObtQOXT7/zJfUJy2tGKWHi0gGMpHyEQOYaLCQYG+AL6kr93
         HgGA5Q51gJi4hyk9ood8ojbo2LMyVxNU8GkSZdYlQNE7aG72yMlZkei+D/FXN3Vubi
         jDe9jZmBGDpvRtQVhknqBwO5FGwLBNSVXdUqlqPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/475] hwrng: atmel - disable trng on failure path
Date:   Thu, 14 Apr 2022 15:08:06 +0200
Message-Id: <20220414110857.981050314@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index e55705745d5e..f4c94f8acfe0 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -96,6 +96,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
 
 err_register:
 	clk_disable_unprepare(trng->clk);
+	atmel_trng_disable(trng);
 	return ret;
 }
 
-- 
2.34.1



