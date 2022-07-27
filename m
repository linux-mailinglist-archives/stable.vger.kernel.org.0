Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E860582CFD
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbiG0Qwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240822AbiG0QwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A140F4D16E;
        Wed, 27 Jul 2022 09:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B6CC61A7E;
        Wed, 27 Jul 2022 16:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4438AC43470;
        Wed, 27 Jul 2022 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939646;
        bh=jsF4LpQm777PxNt5/h+cNChfYSEvUrbp0KZNEszQamk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mkb+EWlh3jL7W/yh8od5O4bCOtytQBtYe41sLTMCuSTIffv+GElVI2ZZBA+y+DaLR
         JIpTrzSm+7PqJYegGHzi4hj9NU6ZnnSrBpEZ8+R5I6wrBwvkOJ34F+X52fQc16fi30
         WnVZ+j0crgj3frRt7uXaaXcT+TzRcV2qqhG5Xn2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/105] power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe
Date:   Wed, 27 Jul 2022 18:10:09 +0200
Message-Id: <20220727161013.024294674@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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



