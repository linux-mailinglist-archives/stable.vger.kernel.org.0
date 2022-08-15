Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2C5594514
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347104AbiHOWcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350658AbiHOWcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:32:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD94D7D07;
        Mon, 15 Aug 2022 12:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 511E26068D;
        Mon, 15 Aug 2022 19:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42074C433D6;
        Mon, 15 Aug 2022 19:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592914;
        bh=uoQNnByv+1FbqqjWQwrzqaf0ot43bfZtPaAvo624/cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfxJgyStA91rECfbdDrw4YbFDWUSe/g5EWkwlRPsvjo814k59YDbkefvrtEf4r0Cg
         Qf2XkMIDjwR5OyeVkyhk40nkwrArjwuwwqNOz5lan3yKlv4kz/BnbGYZzHwTIleCmE
         0xhR8gsWh8+2YmQ2LBQCLGyvoXFleDGyrf7+QYt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0186/1157] ARM: shmobile: rcar-gen2: Increase refcount for new reference
Date:   Mon, 15 Aug 2022 19:52:22 +0200
Message-Id: <20220815180447.198904398@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index abea41f7782e..117e7b07995b 100644
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



