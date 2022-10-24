Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480DD60A8FD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbiJXNNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiJXNMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:12:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA2F11C2A;
        Mon, 24 Oct 2022 05:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DD79611B0;
        Mon, 24 Oct 2022 12:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA54C433D6;
        Mon, 24 Oct 2022 12:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614205;
        bh=nggt5QNHZ4QL3rbqvTQdzEH1qGPeqU7CytS2iNQBeXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kvnnf8PN2Cu8GKJTWUiy3eKrlipIXBXHU/olsbl56go+CFP6An5hOnPFAD40Q+cpS
         LsOwfTffoqJgQxsiCSquEZjNk6MrwF09P3gLlxMSJAM0yTXfeLPqY1KKjITSbO0PKT
         BkmusSrkIZ6BSX4HLt3pGqeOzw86ziF5lSx/IVcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/390] memory: of: Fix refcount leak bug in of_get_ddr_timings()
Date:   Mon, 24 Oct 2022 13:29:29 +0200
Message-Id: <20221024113030.034732557@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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

[ Upstream commit 05215fb32010d4afb68fbdbb4d237df6e2d4567b ]

We should add the of_node_put() when breaking out of
for_each_child_of_node() as it will automatically increase
and decrease the refcount.

Fixes: e6b42eb6a66c ("memory: emif: add device tree support to emif driver")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220719085640.1210583-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/of_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/of_memory.c b/drivers/memory/of_memory.c
index d9f5437d3bce..d0a80aefdea8 100644
--- a/drivers/memory/of_memory.c
+++ b/drivers/memory/of_memory.c
@@ -134,6 +134,7 @@ const struct lpddr2_timings *of_get_ddr_timings(struct device_node *np_ddr,
 	for_each_child_of_node(np_ddr, np_tim) {
 		if (of_device_is_compatible(np_tim, tim_compat)) {
 			if (of_do_get_timings(np_tim, &timings[i])) {
+				of_node_put(np_tim);
 				devm_kfree(dev, timings);
 				goto default_timings;
 			}
-- 
2.35.1



