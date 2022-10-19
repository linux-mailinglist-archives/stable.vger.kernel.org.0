Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D23D603E2A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiJSJLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiJSJH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:07:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097AC2C127;
        Wed, 19 Oct 2022 01:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 354BB61800;
        Wed, 19 Oct 2022 08:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CA5C433C1;
        Wed, 19 Oct 2022 08:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169898;
        bh=EDcfOZ9GiROdzrYcCV/i2Qx1Q4cPalUM4Bdj4HFS6+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7TdHC0W+cUH7BNMadeWc3MOhtgNrgRsVvWAcIvxSCN5XMLGWOg5qgDfCtnY9+2XA
         9TlmNCwZXWWgf/QUx6v1DaCllpRpg1w0dSorEWpe8G0gQ5JjTEgXEQa05tvmDOclvz
         kFWHRaRx8oPgKmf/vJJCbiKyAdleSw++NKGj9anc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 417/862] memory: of: Fix refcount leak bug in of_lpddr3_get_ddr_timings()
Date:   Wed, 19 Oct 2022 10:28:24 +0200
Message-Id: <20221019083308.384611759@linuxfoundation.org>
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
index 8e2ef4bf6b17..fcd20d85d385 100644
--- a/drivers/memory/of_memory.c
+++ b/drivers/memory/of_memory.c
@@ -285,6 +285,7 @@ const struct lpddr3_timings
 		if (of_device_is_compatible(np_tim, tim_compat)) {
 			if (of_lpddr3_do_get_timings(np_tim, &timings[i])) {
 				devm_kfree(dev, timings);
+				of_node_put(np_tim);
 				goto default_timings;
 			}
 			i++;
-- 
2.35.1



