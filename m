Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8766088AD
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiJVIU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiJVITo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:19:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FD22DE461;
        Sat, 22 Oct 2022 00:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0F79B82DEF;
        Sat, 22 Oct 2022 07:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D37BC433D6;
        Sat, 22 Oct 2022 07:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424985;
        bh=VDRe/5Hbi95puk/YwoQKy5coXP8NgEp+rB9ALswaBwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geNApx98+8y52WChecnzNJ5W1XFPnKSNGY251SlLxqIHF33FvizogYOF3LD4qOHLK
         MLRCQwLH2U4RR7pEDrK6zlGqgY6IIfEBafDwHL+unctAq5RWMbViq+4aTgbLw6cAGb
         u45alUgL1TBZUSUkvWg9/etvAHiZ7vzwPuNYAkDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 349/717] memory: of: Fix refcount leak bug in of_get_ddr_timings()
Date:   Sat, 22 Oct 2022 09:23:48 +0200
Message-Id: <20221022072511.162072362@linuxfoundation.org>
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
index dbdf87bc0b78..8e2ef4bf6b17 100644
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



