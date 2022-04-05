Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308D64F3449
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349691AbiDEKuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345351AbiDEJnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:43:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9D0C3345;
        Tue,  5 Apr 2022 02:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1B4AB81CAD;
        Tue,  5 Apr 2022 09:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF50C385A0;
        Tue,  5 Apr 2022 09:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150930;
        bh=DgaIpDFEc+A61h9xhkJGjlT1kiDaci5Wzlmlp8QsmaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InYYuFxXxrm4WjZIemceQyj/RLWV8glgLOB9BFbYwkhkAefnjsFASiXAgxCGoEuGR
         8WKN0Ys/rv1IHyFw0t/2yE2tb+jKwAO5MBbD7kuH8aMPuwfBclOPztuXN08oO6+VJ3
         Ds3xGHzVtBQ5qVipFOV2aYn1rYgodnBGDxyA3wXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Ranquet <granquet@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/913] clocksource/drivers/timer-of: Check return value of of_iomap in timer_of_base_init()
Date:   Tue,  5 Apr 2022 09:21:34 +0200
Message-Id: <20220405070346.810433611@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 529cc6a51cdb..c3f54d9912be 100644
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



