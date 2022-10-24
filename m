Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66D260ABB5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiJXNzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbiJXNy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:54:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127C3BD068;
        Mon, 24 Oct 2022 05:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52A26612A1;
        Mon, 24 Oct 2022 12:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64852C433C1;
        Mon, 24 Oct 2022 12:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615431;
        bh=ImaiAK7jHhbV8YcUYAVGJfAjkWTkK3o5h2uJ0SiwaWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cV4wlzEXgtm3ySn7sF5mMx11GydR3LDllgSRKuwf7Z4Iapc/muF7cXIi1RHnB/+Ok
         63o5fOtRT+BitZd1xUwFaVb9zhmVpUbHKB2MtLAghEUS2MliToWkAaL1s0xwLSckJ0
         GCspZKGfUQ58Zar05711qzk4DxQ0VZw7PWLCLqBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/530] memory: of: Fix refcount leak bug in of_lpddr3_get_ddr_timings()
Date:   Mon, 24 Oct 2022 13:29:52 +0200
Message-Id: <20221024113056.340926529@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 48af14fb0eaa63d9aa68f59fb0b205ec55a95636 ]

We should add the of_node_put() when breaking out of
for_each_child_of_node() as it will automatically increase
and decrease the refcount.

Fixes: 976897dd96db ("memory: Extend of_memory with LPDDR3 support")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220719085640.1210583-2-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/of_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/of_memory.c b/drivers/memory/of_memory.c
index d0a80aefdea8..1791614f324b 100644
--- a/drivers/memory/of_memory.c
+++ b/drivers/memory/of_memory.c
@@ -283,6 +283,7 @@ const struct lpddr3_timings
 		if (of_device_is_compatible(np_tim, tim_compat)) {
 			if (of_lpddr3_do_get_timings(np_tim, &timings[i])) {
 				devm_kfree(dev, timings);
+				of_node_put(np_tim);
 				goto default_timings;
 			}
 			i++;
-- 
2.35.1



