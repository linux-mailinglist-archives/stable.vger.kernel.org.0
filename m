Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD8D4F4147
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356512AbiDEMXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356168AbiDEKXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E84BA33B;
        Tue,  5 Apr 2022 03:07:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EAD0B81BC0;
        Tue,  5 Apr 2022 10:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79337C385A1;
        Tue,  5 Apr 2022 10:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153240;
        bh=aR1A0SezXpkQGZdReRE0MJZ9Tozm4kPC8Waf9Ta+wng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHyxgE5y5Cqn0GAIjERw4F1we3eefSJKLvfV2urHdW1CIm5O+NWebrZ9XmJuQjUgm
         kbLwXhs3SoSJd+0YwGK9C08GtpHfPDBenJHf3rpia8b6FN5gHO1e1XUOXsiu/r0TsZ
         64L79ClePOcPx6Czv8h+nxJbKbkHUaBXyACSM55c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/599] hwrng: atmel - disable trng on failure path
Date:   Tue,  5 Apr 2022 09:27:25 +0200
Message-Id: <20220405070303.336180296@linuxfoundation.org>
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



