Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D88C60A92A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiJXNQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbiJXNOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:14:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA1DA23EC;
        Mon, 24 Oct 2022 05:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59BF1B81289;
        Mon, 24 Oct 2022 12:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE78EC433C1;
        Mon, 24 Oct 2022 12:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613364;
        bh=YCXQS2xzc48G6OVfeIwrWrM+RKOJvvmspSjHPzG5Owo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK4q3fUKJTgLgXLYKcxOJsRuo5PU/pK3SBjqvHojMbKj3EFfmvzPzJ5ga5bzbaex1
         J7weXY98U6/mHmc80/Rxe+Bxv63J1R/Mfan8dGPXnL5b+yZ/mmrjNwCmXun4Ebp1kn
         BNlm7/yqmxm45cwMjOv8GkETNceQU+6hPj0dSuT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/255] memory: pl353-smc: Fix refcount leak bug in pl353_smc_probe()
Date:   Mon, 24 Oct 2022 13:30:18 +0200
Message-Id: <20221024113006.059859095@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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

[ Upstream commit 61b3c876c1cbdb1efd1f52a1f348580e6e14efb6 ]

The break of for_each_available_child_of_node() needs a
corresponding of_node_put() when the reference 'child' is not
used anymore. Here we do not need to call of_node_put() in
fail path as '!match' means no break.

While the of_platform_device_create() will created a new
reference by 'child' but it has considered the refcounting.

Fixes: fee10bd22678 ("memory: pl353: Add driver for arm pl353 static memory controller")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220716031324.447680-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/pl353-smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/pl353-smc.c b/drivers/memory/pl353-smc.c
index cc01979780d8..322d7ead0031 100644
--- a/drivers/memory/pl353-smc.c
+++ b/drivers/memory/pl353-smc.c
@@ -416,6 +416,7 @@ static int pl353_smc_probe(struct amba_device *adev, const struct amba_id *id)
 	if (init)
 		init(adev, child);
 	of_platform_device_create(child, NULL, &adev->dev);
+	of_node_put(child);
 
 	return 0;
 
-- 
2.35.1



