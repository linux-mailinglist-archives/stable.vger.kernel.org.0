Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8BF657FAF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbiL1QHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiL1QH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330CA10B7A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C74A961577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7CAC433EF;
        Wed, 28 Dec 2022 16:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243646;
        bh=TuF4wUYdyFvLGY9SACynje///QzokDH5XG2EpqcTumw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5uwyKelm++3ADoWpZaGJCTyLDf2v7/2A9s5FnKV1NajUIY3+KT2YLGDlhmwS6/zG
         ENXAZHXHG4z4lKG+OU8Lwv2evX3AQz0uEKTO/3V2F321HRu5Ownl5EC2cVjXOCcPCS
         t/TNQAUIEerrc2iN9TJsn0KLkEO+OJf5TrZAVYtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0527/1146] clk: socfpga: Fix memory leak in socfpga_gate_init()
Date:   Wed, 28 Dec 2022 15:34:26 +0100
Message-Id: <20221228144344.490879413@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 0b8ba891ad4d1ef6bfa4c72efc83f9f9f855f68b ]

Free @socfpga_clk and @ops on the error path to avoid memory leak issue.

Fixes: a30a67be7b6e ("clk: socfpga: Don't have get_parent for single parent ops")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221123031622.63171-1-xiujianfeng@huawei.com
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-gate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/socfpga/clk-gate.c b/drivers/clk/socfpga/clk-gate.c
index 53d6e3ec4309..c94b59b80dd4 100644
--- a/drivers/clk/socfpga/clk-gate.c
+++ b/drivers/clk/socfpga/clk-gate.c
@@ -188,8 +188,10 @@ void __init socfpga_gate_init(struct device_node *node)
 		return;
 
 	ops = kmemdup(&gateclk_ops, sizeof(gateclk_ops), GFP_KERNEL);
-	if (WARN_ON(!ops))
+	if (WARN_ON(!ops)) {
+		kfree(socfpga_clk);
 		return;
+	}
 
 	rc = of_property_read_u32_array(node, "clk-gate", clk_gate, 2);
 	if (rc)
@@ -243,6 +245,7 @@ void __init socfpga_gate_init(struct device_node *node)
 
 	err = clk_hw_register(NULL, hw_clk);
 	if (err) {
+		kfree(ops);
 		kfree(socfpga_clk);
 		return;
 	}
-- 
2.35.1



