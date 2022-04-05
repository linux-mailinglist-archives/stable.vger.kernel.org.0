Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEA64F3B35
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345332AbiDELvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356554AbiDEKYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:24:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5CFBD8AA;
        Tue,  5 Apr 2022 03:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 658D6B81CB5;
        Tue,  5 Apr 2022 10:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE464C385A7;
        Tue,  5 Apr 2022 10:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153310;
        bh=VQ5yBIa2FGaD+JwPV3eQXTVT9noiawHMQkRa0hXOq1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZSThBpQzo1Tn/paB+F7LyTUtxhOfy6tS5vWcQDM3ZRaC3GLrdbXbjHuqCHigMlHW
         pcZrLEQ2RNdZcr03dAXgkqRVaQjpxz36i/BnH5IttR8QnsgwGJzbE6rDBXUFgGQ7Vo
         vvEMb9iTXCw26m7aXcvfGiPpsfV7z7+Poo+1vKwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Ranquet <granquet@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/599] clocksource/drivers/timer-of: Check return value of of_iomap in timer_of_base_init()
Date:   Tue,  5 Apr 2022 09:27:34 +0200
Message-Id: <20220405070303.603379474@linuxfoundation.org>
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

From: Guillaume Ranquet <granquet@baylibre.com>

[ Upstream commit 4467b8bad2401794fb89a0268c8c8257180bf60f ]

of_base->base can either be iomapped using of_io_request_and_map() or
of_iomap() depending whether or not an of_base->name has been set.

Thus check of_base->base against NULL as of_iomap() does not return a
PTR_ERR() in case of error.

Fixes: 9aea417afa6b ("clocksource/drivers/timer-of: Don't request the resource by name")
Signed-off-by: Guillaume Ranquet <granquet@baylibre.com>
Link: https://lore.kernel.org/r/20220307172656.4836-1-granquet@baylibre.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-of.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-of.c b/drivers/clocksource/timer-of.c
index 572da477c6d3..b965f20174e3 100644
--- a/drivers/clocksource/timer-of.c
+++ b/drivers/clocksource/timer-of.c
@@ -157,9 +157,9 @@ static __init int timer_of_base_init(struct device_node *np,
 	of_base->base = of_base->name ?
 		of_io_request_and_map(np, of_base->index, of_base->name) :
 		of_iomap(np, of_base->index);
-	if (IS_ERR(of_base->base)) {
-		pr_err("Failed to iomap (%s)\n", of_base->name);
-		return PTR_ERR(of_base->base);
+	if (IS_ERR_OR_NULL(of_base->base)) {
+		pr_err("Failed to iomap (%s:%s)\n", np->name, of_base->name);
+		return of_base->base ? PTR_ERR(of_base->base) : -ENOMEM;
 	}
 
 	return 0;
-- 
2.34.1



