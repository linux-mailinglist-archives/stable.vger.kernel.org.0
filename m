Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A1558C0A4
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243166AbiHHBxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243627AbiHHBv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CEF193F3;
        Sun,  7 Aug 2022 18:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2082560E06;
        Mon,  8 Aug 2022 01:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D80C433C1;
        Mon,  8 Aug 2022 01:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922701;
        bh=hwBSpc7erig/674qMUa5THYn7tKXm6QBe24djanajcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwuUzKh11NqF3YccmbX6LFxs7a5CmyuDxk2VGm9KPnZT53zN8JAXe69H2YUIt3XQh
         hJO44JCsIbUk31KIctGN5Ar7dXG+xMRkPDZ1Byu/Gz70jaZ5JiPLsLOVV7Ol7KTUOj
         0GffDxkxU024zqJkDHVK/X/RbTV6nShcypEuswF9RCeSUn5+r7HXqiCiIINlThbTJO
         lBtwIYc1Kp6RiKXKbAJ00ppqW4NuDKDeapo5mq3iEpbRn5WxLk96wn/jAyI7tFC+V1
         RjuDq//FLvVqjS/DvgTCrPHOw+M0RF+8rQZvOUvCqJjWV6UEzpYGnM42K6Z9PcFQQ2
         lfZYHq31jYaUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, magnus.damm@gmail.com,
        linux@armlinux.org.uk, linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 25/29] ARM: shmobile: rcar-gen2: Increase refcount for new reference
Date:   Sun,  7 Aug 2022 21:37:35 -0400
Message-Id: <20220808013741.316026-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 75a185fb92e58ccd3670258d8d3b826bd2fa6d29 ]

In rcar_gen2_regulator_quirk(), for_each_matching_node_and_match() will
automatically increase and decrease the refcount.  However, we should
call of_node_get() for the new reference created in 'quirk->np'.
Besides, we also should call of_node_put() before the 'quirk' being
freed.

Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220701121804.234223-1-windhl@126.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c b/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
index 09ef73b99dd8..ba44cec5e59a 100644
--- a/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
+++ b/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
@@ -125,6 +125,7 @@ static int regulator_quirk_notify(struct notifier_block *nb,
 
 	list_for_each_entry_safe(pos, tmp, &quirk_list, list) {
 		list_del(&pos->list);
+		of_node_put(pos->np);
 		kfree(pos);
 	}
 
@@ -174,11 +175,12 @@ static int __init rcar_gen2_regulator_quirk(void)
 		memcpy(&quirk->i2c_msg, id->data, sizeof(quirk->i2c_msg));
 
 		quirk->id = id;
-		quirk->np = np;
+		quirk->np = of_node_get(np);
 		quirk->i2c_msg.addr = addr;
 
 		ret = of_irq_parse_one(np, 0, argsa);
 		if (ret) {	/* Skip invalid entry and continue */
+			of_node_put(np);
 			kfree(quirk);
 			continue;
 		}
@@ -225,6 +227,7 @@ static int __init rcar_gen2_regulator_quirk(void)
 err_mem:
 	list_for_each_entry_safe(pos, tmp, &quirk_list, list) {
 		list_del(&pos->list);
+		of_node_put(pos->np);
 		kfree(pos);
 	}
 
-- 
2.35.1

