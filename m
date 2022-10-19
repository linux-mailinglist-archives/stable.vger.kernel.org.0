Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1108F603EBE
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiJSJUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiJSJSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:18:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BE7D9977;
        Wed, 19 Oct 2022 02:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6588A617F1;
        Wed, 19 Oct 2022 09:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C631C433D7;
        Wed, 19 Oct 2022 09:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170406;
        bh=1Y7qpSB/p47Zdgo29zn1EKjizf5xN3DqjUZFK+QYqKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqrJxjZLYMe32NBRt0lQAHjx5yiltiJGgJWcJdOezvyWXHE8+IHa170HuvW0cGKcB
         5q1eIiVl3L7NLgW5vKEXxTfdWE0JAC86SYfATMcVVfUCtgMG0GAalm3xe9VtALTV2e
         FEjocvzD9qKgFTj5uIk3Y5uxO6aT0DkSPCSLdm/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yujun <linyujun809@huawei.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 598/862] clk: imx: scu: fix memleak on platform_device_add() fails
Date:   Wed, 19 Oct 2022 10:31:25 +0200
Message-Id: <20221019083316.386165857@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Yujun <linyujun809@huawei.com>

[ Upstream commit 855ae87a2073ebf1b395e020de54fdf9ce7d166f ]

No error handling is performed when platform_device_add()
fails. Add error processing before return, and modified
the return value.

Fixes: 77d8f3068c63 ("clk: imx: scu: add two cells binding support")
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Link: https://lore.kernel.org/r/20220914033206.98046-1-linyujun809@huawei.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-scu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index c56e406138db..1e6870f3671f 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -695,7 +695,11 @@ struct clk_hw *imx_clk_scu_alloc_dev(const char *name,
 		pr_warn("%s: failed to attached the power domain %d\n",
 			name, ret);
 
-	platform_device_add(pdev);
+	ret = platform_device_add(pdev);
+	if (ret) {
+		platform_device_put(pdev);
+		return ERR_PTR(ret);
+	}
 
 	/* For API backwards compatiblilty, simply return NULL for success */
 	return NULL;
-- 
2.35.1



