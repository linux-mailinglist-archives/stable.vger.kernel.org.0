Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5764360886D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiJVIQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiJVIQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:16:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E571E2CCA13;
        Sat, 22 Oct 2022 00:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC0860AC3;
        Sat, 22 Oct 2022 07:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E10C4314C;
        Sat, 22 Oct 2022 07:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425396;
        bh=kEJlBh+wNtWmXqcwtAkfwDO8V/HHGFV5VPH8ZyBTNso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUz/ueP2GksGPlESuPnNTjCY8clEMmKdQe6VFcTyMecW2kkgYPzpCrQt752yk5gby
         j51Z4E39aIlotQA033GHfpEOrszkRbABHjhQlWxDElpWzeobDmGB32bi8QGEDLkZkn
         fuFiM3beNsEiIYnttIYOz+M40Ua7Ng4pUjlfaE2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 486/717] clk: ti: Balance of_node_get() calls for of_find_node_by_name()
Date:   Sat, 22 Oct 2022 09:26:05 +0200
Message-Id: <20221022072519.859940424@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 058a3996b888ab60eb1857fb4fd28f1b89a9a95a ]

In ti_find_clock_provider(), of_find_node_by_name() will call
of_node_put() for the 'from' argument, possibly putting the node one too
many times. Let's maintain the of_node_get() from the previous search
and only put when we're exiting the function early. This should avoid a
misbalanced reference count on the node.

Fixes: 51f661ef9a10 ("clk: ti: Add ti_find_clock_provider() to use clock-output-names")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220915031121.4003589-1-windhl@126.com
[sboyd@kernel.org: Rewrite commit text, maintain reference instead of
get again]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ti/clk.c b/drivers/clk/ti/clk.c
index 121d8610beb1..6b2de32ef88d 100644
--- a/drivers/clk/ti/clk.c
+++ b/drivers/clk/ti/clk.c
@@ -148,11 +148,12 @@ static struct device_node *ti_find_clock_provider(struct device_node *from,
 			break;
 		}
 	}
-	of_node_put(from);
 	kfree(tmp);
 
-	if (found)
+	if (found) {
+		of_node_put(from);
 		return np;
+	}
 
 	/* Fall back to using old node name base provider name */
 	return of_find_node_by_name(from, name);
-- 
2.35.1



