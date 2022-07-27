Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC6B5830B3
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242747AbiG0Rk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242754AbiG0RkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A48F88CF4;
        Wed, 27 Jul 2022 09:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDD21B821D5;
        Wed, 27 Jul 2022 16:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BE8C433D6;
        Wed, 27 Jul 2022 16:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940681;
        bh=Y2lqLdKXlUsPjo/KKDUbq0isrq7bD1P1nDugIYzLdZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5D1zRSdr44fepxCQgDfzjw2lpR6EbesN+tW4PW4RbWp0pz/yCp8/IUUQ02jlBuMz
         7fFepENm7Zdi8MA9jQRsd0gZVULqkYYqd+gGmY3yWpZMzvLAcpmHHTB1UH8755RFUQ
         rNw8IMqzchgml3OkKmiTxh29zN9U/R3WAceJ7GzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 111/158] can: rcar_canfd: Add missing of_node_put() in rcar_canfd_probe()
Date:   Wed, 27 Jul 2022 18:12:55 +0200
Message-Id: <20220727161025.923480839@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 7b66dfcc6e1e1f018492619c3d0fc432b6b54272 ]

We should use of_node_put() for the reference returned by
of_get_child_by_name() which has increased the refcount.

Fixes: 45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")
Link: https://lore.kernel.org/all/20220712095623.364287-1-windhl@126.com
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 589996cef5db..8d457d2c3bcc 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1850,6 +1850,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		of_child = of_get_child_by_name(pdev->dev.of_node, name);
 		if (of_child && of_device_is_available(of_child))
 			channels_mask |= BIT(i);
+		of_node_put(of_child);
 	}
 
 	if (chip_id != RENESAS_RZG2L) {
-- 
2.35.1



