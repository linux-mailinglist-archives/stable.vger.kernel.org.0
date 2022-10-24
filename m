Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5060AC4B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiJXOFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbiJXOC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:02:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7572C0997;
        Mon, 24 Oct 2022 05:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51A08612B4;
        Mon, 24 Oct 2022 12:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64312C433C1;
        Mon, 24 Oct 2022 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615718;
        bh=WDyOXrbFl1uJd00F4JRhGGH67hz1LHgixA315HYy2mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Z2wo+4u60gkC0ziDgX8NdFYLaAwkLmPoRFHwRfvdlDnc2vJtDPvvze/WkJOUFmqs
         RdxrJXXkfWIoxM0nJN/0j5j0IeEBDNtBxKJL4QY39BlFtVMJyfbCSi3dmKgOdrfU6w
         iAzICO8P/m9vtStRXxCOlP+/BujjI7I/YT49gH5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yujun <linyujun809@huawei.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 356/530] clk: imx: scu: fix memleak on platform_device_add() fails
Date:   Mon, 24 Oct 2022 13:31:40 +0200
Message-Id: <20221024113101.141484836@linuxfoundation.org>
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
index 083da31dc3ea..dc933fd5d5a0 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -690,7 +690,11 @@ struct clk_hw *imx_clk_scu_alloc_dev(const char *name,
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



