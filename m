Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8E66042B7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiJSLIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiJSLI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:08:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2BDF5CE8;
        Wed, 19 Oct 2022 03:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B6D9B82448;
        Wed, 19 Oct 2022 08:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10A1C433D6;
        Wed, 19 Oct 2022 08:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169972;
        bh=jY5QCfw7xTXd3ZKXFT3BA0Dy8YBjTPowLa9k7IVWMjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6qLd305VxxzEhr+1OUpWVItms4d04DaUTeDHkUdNlMVdgnMzp2m8qircqERZzZYy
         wgZyQiueTFuX9//NpY35XDc9T5N3pX/dOZL9WA+XWboQEGWuHQVMSHg+IpTi+Sv/Lt
         S7gMVJ05eJyfXQRe/aJnZDSur2/QkCMWnfCsx2+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 477/862] clk: tegra20: Fix refcount leak in tegra20_clock_init
Date:   Wed, 19 Oct 2022 10:29:24 +0200
Message-Id: <20221019083311.026012365@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 4e343bafe03ff68a62f48f8235cf98f2c685468b ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 37c26a906527 ("clk: tegra: add clock support for Tegra20")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220523152811.19692-1-linmq006@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra20.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index be3c33441cfc..8a4514f6d503 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1131,6 +1131,7 @@ static void __init tegra20_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		BUG();
-- 
2.35.1



