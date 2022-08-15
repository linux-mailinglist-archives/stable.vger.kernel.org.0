Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB47593743
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343778AbiHOTS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344307AbiHOTQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:16:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A54752FD5;
        Mon, 15 Aug 2022 11:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B972161143;
        Mon, 15 Aug 2022 18:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFC6C433D6;
        Mon, 15 Aug 2022 18:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588685;
        bh=drjjw1OcmSZKyXWnDea21kgHQ4W665P0NdF114hFKv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+8nLpS3NJEymhs4GQb7goDIIG1z7kYnGfMSVwqNoGKLC52L3Mrdz65TzM/WqUXdZ
         9/avVJUHR080yk3ZdLQErnOx2bMCT0QmKSO3SqpJdkv18CY+J+pzZ5Bl3nnzt/nI4T
         riPracJA9cfjLv5JYif2JIS/u6LZi0HHWTBTFx78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.15 482/779] of: device: Fix missing of_node_put() in of_dma_set_restricted_buffer
Date:   Mon, 15 Aug 2022 20:02:06 +0200
Message-Id: <20220815180357.856053649@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit d17e37c41b7ed38459957a5d2968ba61516fd5c2 ]

We should use of_node_put() for the reference 'node' returned by
of_parse_phandle() which will increase the refcount.

Fixes: fec9b625095f ("of: Add plumbing for restricted DMA pool")
Co-authored-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220702014449.263772-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index b0800c260f64..45335fe523f7 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -81,8 +81,11 @@ of_dma_set_restricted_buffer(struct device *dev, struct device_node *np)
 		 * restricted-dma-pool region is allowed.
 		 */
 		if (of_device_is_compatible(node, "restricted-dma-pool") &&
-		    of_device_is_available(node))
+		    of_device_is_available(node)) {
+			of_node_put(node);
 			break;
+		}
+		of_node_put(node);
 	}
 
 	/*
-- 
2.35.1



