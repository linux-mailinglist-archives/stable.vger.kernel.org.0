Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B44582FD1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbiG0RaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242393AbiG0R3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:29:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A16080526;
        Wed, 27 Jul 2022 09:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B0E5B8200D;
        Wed, 27 Jul 2022 16:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0532EC433C1;
        Wed, 27 Jul 2022 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940437;
        bh=jsF4LpQm777PxNt5/h+cNChfYSEvUrbp0KZNEszQamk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bo2Sp00JN+is7LRQH5e9eoHXZkOYSizB84pnapgJX/YvStm4+7Et1K4wpMpKxf2d2
         Lk0LNMGI0BOb0f14ORtinW3MI5MvTDp/DaVrLXB8PGxvENutMbEKZwqrz87bAZuHk2
         38FFLWE3G52RYawIPx8yvkfx7bLHw0mag7XekTvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 022/158] power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe
Date:   Wed, 27 Jul 2022 18:11:26 +0200
Message-Id: <20220727161022.356820953@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 80192eff64eee9b3bc0594a47381937b94b9d65a ]

of_find_matching_node_and_match() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 0e545f57b708 ("power: reset: driver for the Versatile syscon reboot")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/arm-versatile-reboot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/arm-versatile-reboot.c b/drivers/power/reset/arm-versatile-reboot.c
index 08d0a07b58ef..c7624d7611a7 100644
--- a/drivers/power/reset/arm-versatile-reboot.c
+++ b/drivers/power/reset/arm-versatile-reboot.c
@@ -146,6 +146,7 @@ static int __init versatile_reboot_probe(void)
 	versatile_reboot_type = (enum versatile_reboot)reboot_id->data;
 
 	syscon_regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 
-- 
2.35.1



