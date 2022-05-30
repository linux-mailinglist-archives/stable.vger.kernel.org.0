Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FE65380EC
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbiE3Nw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbiE3Nvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B00DFF5;
        Mon, 30 May 2022 06:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78AE560F92;
        Mon, 30 May 2022 13:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B077DC3411E;
        Mon, 30 May 2022 13:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917815;
        bh=exPGkkNvsUk+zn+DuPTfeI/LZZeoAt13rijdsRPZbco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vw5OSNKQxK5Lozju0JC2OGis+ZUD+uPkhUz5Zb0OZiP7EALAE3HnJ4D5fbVKRDR6H
         AYDIeDwkphPaDKEzsNdTJrnvif8bv65mLBIz02FVauiBsM1LjsrBdydJ1uJCA0mLIZ
         gsd+4wzrwzoQkHcBe696ZMi3aL0H9dPssHc01Mhl+VjjGbDdSb1MgC3WyNnStqdhV8
         W6jETucGQIsh2rLIPdjVVBtJaVgboW4hQ5VeeZ5CTKQZPhvp7X5WdRKHgq6bdtNHec
         93T3FRHoNrpyFTfylEWugdKXxjfxTd1kctKWAoQ18fjw10UZcgm+XYvXBYe2Vkqi+v
         segUQfM0wvJaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 106/135] ASoC: rt5645: Fix errorenous cleanup order
Date:   Mon, 30 May 2022 09:31:04 -0400
Message-Id: <20220530133133.1931716-106-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 2def44d3aec59e38d2701c568d65540783f90f2f ]

There is a logic error when removing rt5645 device as the function
rt5645_i2c_remove() first cancel the &rt5645->jack_detect_work and
delete the &rt5645->btn_check_timer latter. However, since the timer
handler rt5645_btn_check_callback() will re-queue the jack_detect_work,
this cleanup order is buggy.

That is, once the del_timer_sync in rt5645_i2c_remove is concurrently
run with the rt5645_btn_check_callback, the canceled jack_detect_work
will be rescheduled again, leading to possible use-after-free.

This patch fix the issue by placing the del_timer_sync function before
the cancel_delayed_work_sync.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20220516092035.28283-1-linma@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 197c56047947..4b2e027c1033 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -4154,9 +4154,14 @@ static int rt5645_i2c_remove(struct i2c_client *i2c)
 	if (i2c->irq)
 		free_irq(i2c->irq, rt5645);
 
+	/*
+	 * Since the rt5645_btn_check_callback() can queue jack_detect_work,
+	 * the timer need to be delted first
+	 */
+	del_timer_sync(&rt5645->btn_check_timer);
+
 	cancel_delayed_work_sync(&rt5645->jack_detect_work);
 	cancel_delayed_work_sync(&rt5645->rcclock_work);
-	del_timer_sync(&rt5645->btn_check_timer);
 
 	regulator_bulk_disable(ARRAY_SIZE(rt5645->supplies), rt5645->supplies);
 
-- 
2.35.1

