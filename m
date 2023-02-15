Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E143B69867A
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjBOUu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjBOUtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:49:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D038457FA;
        Wed, 15 Feb 2023 12:47:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBCBD61D9E;
        Wed, 15 Feb 2023 20:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62271C433A1;
        Wed, 15 Feb 2023 20:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494004;
        bh=TcEvZYHrQCR/hfcOxedM7Vg4Fnq1Z6Qy069MGALnJCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJvKQIOnsGfbIceRELHCD0TX0F8ClHISTXoTh/5wobSZDL24N0pctzLamBJ8fPSL6
         RGSWMW18uXOY4mFRyDl6wL00LkJdVdEs9k2uhqv7QP/lWRDS8Ej1vZTt8IoX1qKj4N
         BihCMu+mJ9t9mp/K74zoJAD3L92XLom8RRYuNnfvts7d4AelKs0HXkIKcJpuLV9128
         Yeifo2F2OD7Z5sQZyYAV+AwyQ0MQKLTJXglcS5pS+S6IjXupqWjkmzdUp2KQpK/NCs
         vE1bnaBgG8bO8WQM17LkqOnAZb4rpsQHVkwd7eDGuj6DhRLuCKHBcaR8LZHOGEWBDt
         PyR6YvajoKmLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Yu <jack.yu@realtek.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 08/12] ASoC: rt715-sdca: fix clock stop prepare timeout issue
Date:   Wed, 15 Feb 2023 15:46:30 -0500
Message-Id: <20230215204637.2761073-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204637.2761073-1-sashal@kernel.org>
References: <20230215204637.2761073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 2036890282d56bcbf7f915ba9e04bf77967ab231 ]

Modify clock_stop_timeout value for rt715-sdca according to
the requirement of internal clock trimming.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://lore.kernel.org/r/574b6586267a458cac78c5ac4d5b10bd@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdca-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt715-sdca-sdw.c b/sound/soc/codecs/rt715-sdca-sdw.c
index 0f4354eafef25..85abf8073c278 100644
--- a/sound/soc/codecs/rt715-sdca-sdw.c
+++ b/sound/soc/codecs/rt715-sdca-sdw.c
@@ -167,7 +167,7 @@ static int rt715_sdca_read_prop(struct sdw_slave *slave)
 	}
 
 	/* set the timeout values */
-	prop->clk_stop_timeout = 20;
+	prop->clk_stop_timeout = 200;
 
 	return 0;
 }
-- 
2.39.0

